import 'package:e_com_06/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  static const String routeName = '/category';

  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    final nameController = TextEditingController();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Page'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) => provider.categoryList.isEmpty
            ? const Center(
                child: Text(
                  'No items found',
                  style: TextStyle(fontSize: 30),
                ),
              )
            : ListView.builder(
                itemCount: provider.categoryList.length,
                itemBuilder: (context, index) {
                  final category = provider.categoryList[index];

                  return Card(
                    child: ListTile(
                      title:
                          Text(' ${category.catName}(${category.productCount})'),

                    ),
                  );
                },
              ),
      ),
      bottomSheet: DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.6,
        minChildSize: 0.1,
        initialChildSize: 0.1,
        builder: (BuildContext context, ScrollController scrollController) {
          return Card(
            // elevation: 0,
            child: ListView(
              controller: scrollController,
              children: [
                const Center(child: Icon(Icons.drag_handle)),
                const SizedBox(height: 5,),
                const Text('Add Category',style: TextStyle(fontSize: 20),),


                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter new category',
                      filled: true),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty) {
                        return;
                      } else {
                        await Provider.of<ProductProvider>(context,listen: false)
                            .addCategory(nameController.text);
                        nameController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add '))
              ],
            ),
          );
        },
      ),

    );
  }
}
