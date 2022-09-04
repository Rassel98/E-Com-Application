import 'package:e_com_user/auth/auth_service.dart';
import 'package:e_com_user/pages/login_page.dart';
import 'package:e_com_user/pages/registration_page.dart';
import 'package:e_com_user/utils/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PhoneVerificationPage extends StatefulWidget {
  static const String routeName = 'phone_verification';
  const PhoneVerificationPage({Key? key}) : super(key: key);

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final phoneNumberController = TextEditingController();
  final otpController = TextEditingController();
  late  bool _first=true;
  String vId='';
  @override
  void didChangeDependencies() {
    phoneNumberController.text='+880';
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    phoneNumberController.dispose();
    otpController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AnimatedCrossFade(
            duration: const Duration(seconds: 1),
            firstChild: phoneVerificationColumn(),
            secondChild: otpVerificationColumn(),
            crossFadeState: _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ),
        ),
      )
    );
  }

  Column phoneVerificationColumn() {
    return Column(
      mainAxisSize:MainAxisSize.min ,
      children: [
        TextField(
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.phone,
          controller: phoneNumberController,
          decoration: const InputDecoration(
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            hintText: 'Enter Mobile Number',
            labelText: 'Mobile Number',
            prefixIcon: Icon(Icons.phone),
            filled: true,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Center(
          child: ElevatedButton(onPressed: () {
            if(phoneNumberController.text.isEmpty){
              showDisplayMessage(context, 'Field can not empty');
              return;
            }
            setState(() {
              _first=false;

            });
            _verifyPhone();
          }, child: const Text('SUBMIT')),
        )
      ],
    );
  }

  Column otpVerificationColumn() {
    return Column(
      mainAxisSize:MainAxisSize.min ,
      children: [
        const Text('Phone Verification'),
        const SizedBox(height: 10,),
        Text('Your Number ${phoneNumberController.text}'),
        const SizedBox(height: 10,),
        PinCodeTextField(
          length: 6,
          obscureText: false,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.underline,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
          ),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.blue.shade50,
          enableActiveFill: false,
          //errorAnimationController: errorController,
          controller: otpController,
          onChanged: (value) {
            if(value.length==6){
              EasyLoading.show(status: 'Please wait',dismissOnTap: false);
              sendOtp();
            }
          },
          appContext: context,
        )
      ],
    );
  }

  void _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: phoneNumberController.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        showDisplayMessage(context, e.code);
      },
      codeSent: (String verificationId, int? resendToken) {
        vId=verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        //Navigator.pop(context);
      },
    );

  }

  void sendOtp() {
    PhoneAuthCredential credential = PhoneAuthProvider
        .credential(verificationId: vId, smsCode: otpController.text);
    FirebaseAuth.instance.signInWithCredential(credential)
        .then((credentialUser) {
      if(credentialUser != null) {
        EasyLoading.dismiss();
        AuthService.logout();
        Navigator.pushReplacementNamed(context, RegisterPage.routeName,arguments: phoneNumberController.text);
        //Navigator.pushReplacementNamed(context, RegistrationPage.routeName, arguments: phoneController.text);
      }
    }).catchError((err){
      EasyLoading.dismiss();
      showDisplayMessage(context, err);
      Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, (route) => false);
    });
  }
}
