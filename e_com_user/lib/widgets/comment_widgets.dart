import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Comments extends StatefulWidget {
  String pid;
   Comments({Key? key,required this.pid}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final txtController=TextEditingController();
  late ProductProvider provider;
  @override
  void dispose() {
    txtController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    provider=Provider.of<ProductProvider>(context,listen: false);
    provider.getAllComments(widget.pid);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       provider.commentsList.isEmpty?const Center(child:Text('No Comment found'),): ListView.builder(
          itemCount: provider.commentsList.length,
            itemBuilder: (context, index) {
              final comM=provider.commentsList[index];
              return Text(comM.comment);
            },),
        Row(
          children: [
            TextField(
              controller: txtController,
              decoration: const InputDecoration(
                hintText: 'Enter You Comments',
                suffixIcon: Icon(Icons.message)
              ),

            ),
            ElevatedButton(onPressed: txtController.text.isEmpty?null:(){}, child:const Text('Sent'))
          ],
        )
      ],
    );
  }
}
