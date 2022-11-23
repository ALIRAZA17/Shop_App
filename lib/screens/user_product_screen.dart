import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/user_product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';
  const UserProductsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(
              Icons.add,
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (context, index) => UserProductItem(
            productsData.items[index].title,
            productsData.items[index].imageUrl,
          ),
          itemCount: productsData.items.length,
        ),
      ),
    );
  }
}
