import 'package:e_com_user/provider/order_provider.dart';
import 'package:e_com_user/utils/constrains.dart';
import 'package:e_com_user/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyOrderPage extends StatelessWidget {
  static const String routeName='/my_order';
  const MyOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context,listen: false).getAllOrderByUserId();
    return Scaffold(
      body: Consumer<OrderProvider>(
        builder: (context,provider,_)=>
          provider.orderListCurrentUser.isEmpty?const Center(child: Text('You have currently no orders'),):
              ListView.builder(
                itemCount: provider.orderListCurrentUser.length,
                  itemBuilder: (context,index){
                  final orderM=provider.orderListCurrentUser[index];
                  return ListTile(
                    title: Text(getFormattedDateTime(orderM.orderDate.timestamp.toDate(), 'dd/MM/yyy hh:mm a')),
                    subtitle: Text(orderM.orderStatus),
                    trailing: Text('$currencySymbols${orderM.grantTotal}'),
                  );
                  }
              )

      ),
    );
  }
}
