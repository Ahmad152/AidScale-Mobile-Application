import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:aid_scale/pages/services/database.dart';
import 'package:aid_scale/pages/productPage.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({Key? key,required this.product}) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: Colors.blue[100],
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: Slidable(
          useTextDirection: true,
          closeOnScroll: true,
          startActionPane: ActionPane(motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context){DatabaseService().removeProduct(product.id);},
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  //TODO: edit...
                  onPressed: (context){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ProductPage(product: product,))
                    );
                  },
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'edit',
                ),
              ]),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              child: Image(image: AssetImage("asset/screw1.png"),fit: BoxFit.fill,),//AssetImage("asset/nail.png"),
              backgroundColor: Colors.transparent,
            ),
            title: Text(product.name),
            subtitle: Text('unit weight: ${product.unit}\npack weight: ${product.pack}\nID: ${product.id}'),
            trailing: TextButton(
              onPressed: () {

              },
              child: Icon(Icons.edit,color: Colors.blue[200],),
            ),
          ),
        ),
      ),
    );
  }
}

class Product{
  String id;
  String name;
  String unit;
  String pack;

  Product({required this.id,required this.name,required this.unit,required this.pack});

}

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Product>?>(context);
    return products == null ? Container():ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index){
        return ProductTile(product: products[index]);
      },
    );
  }
}




class ProductDropDown extends StatefulWidget {
  ProductDropDown(this.name,{Key? key}) : super(key: key);
  Product name;
  @override
  State<ProductDropDown> createState() => _ProductDropDownState();
}

class _ProductDropDownState extends State<ProductDropDown> {
  @override
  Widget build(BuildContext context) {

    final products = Provider.of<List<Product>?>(context);
    if(products == null) return Container(
      child: Text('there is no products',style: TextStyle(color: Colors.red),),
    );
    return DropdownButtonFormField(
      icon: Icon(Icons.arrow_right),
      value: products.first,
      items: products.map((product) {

        return DropdownMenuItem(
          child: Text('${product.name}'),
          value: product,
        );
      }).toList(),
      onChanged: (value) {
        value as Product;
        setState(()=> //_currentProduct = value);
        widget.name.name=value.id.toString());
        },
    );
  }
}
