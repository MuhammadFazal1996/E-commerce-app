import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/pages/products_page.dart';

class ProductDetailPage extends StatelessWidget {
  final Product item;
  ProductDetailPage({
    this.item
  });


  @override
  Widget build(BuildContext context) {

    final String pictureUrl =   'http://192.168.18.6:1337${item.picture['url']}';
    final Orientation orientation = MediaQuery.of(context).orientation;


    return Scaffold(
      appBar: AppBar(
        title: Text(item.name)
      ),
      body: Container(
        decoration: gradientBackground,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Hero(
                  tag: item,
                  child: Image.network(pictureUrl,
                    width: orientation == Orientation.portrait ? 600 : 250,
                    height: orientation == Orientation.portrait ? 400 : 200,
                    fit: BoxFit.cover,),
                ),
            ),
            Text(item.name, style: Theme.of(context).textTheme.headline6,),
            Text('\$${item.price}', style: Theme.of(context).textTheme.bodyText2,),
             Flexible(
               child: SingleChildScrollView(
                 child: Padding(padding: EdgeInsets.only(left: 32, right: 32, bottom: 32),
                 child: Text(item.description),),
               ),
             )
          ],
        ),
      )
    );
  }
}
