import 'package:flutter/material.dart';

class OrderSucessfullPage extends StatelessWidget {
  static const String routeName='/my_order';
  const OrderSucessfullPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Success',style: TextStyle(fontSize: 30,color: Colors.green),),
      ),
    );
  }
}
