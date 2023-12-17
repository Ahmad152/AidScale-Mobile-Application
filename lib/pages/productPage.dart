import 'package:aid_scale/models/worker.dart';
import 'package:flutter/material.dart';
import 'package:aid_scale/pages/services/database.dart';
import 'package:aid_scale/models/product.dart';
import 'package:provider/provider.dart';


class ProductPage extends StatefulWidget {
  const ProductPage({Key? key,required this.product}) : super(key: key);
  final Product product;

  @override
  State<ProductPage> createState() => _ProductState();
}

class _ProductState extends State<ProductPage> {
  TextStyle textStyle = TextStyle(
    color: Colors.white,
    letterSpacing: 2.0,
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    Product product = widget.product;
    return Scaffold(
      //backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            _updateProduct(
                context,
                product,
                );
          }, icon: Icon(Icons.build , color: Colors.white)),
        ],
        title: Text('Product'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent[100],
      ),
      body: ListView(
          children: [Padding(
            padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                    child: Image(image: AssetImage("asset/workerIcon.png"),fit: BoxFit.fill,),
                    backgroundColor: Colors.transparent,
                    radius: 60.0,
                  ),
                ),
                Divider(
                  height: 10.0,
                  color: Colors.blueAccent[100],
                ),
                Text("Name",style: TextStyle(
                  color: Colors.blueAccent[100],
                  letterSpacing: 2.0,
                ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(product.name,style: TextStyle(
                  color: Colors.blueAccent[700],
                  letterSpacing: 2.0,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text("ID",style: TextStyle(
                  color: Colors.blueAccent[100],
                  letterSpacing: 2.0,
                ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(product.id,style: TextStyle(
                  color: Colors.blueAccent[700],
                  letterSpacing: 2.0,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text("Unit weight",style: TextStyle(
                  color: Colors.blueAccent[100],
                  letterSpacing: 2.0,
                ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(product.unit,style: TextStyle(
                  color: Colors.blueAccent[700],
                  letterSpacing: 2.0,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  children: <Widget>[
                    //SizedBox(width: 10.0,),
                    Text("units per pack",style: TextStyle(
                      color: Colors.blueAccent[100],
                      letterSpacing: 2.0,
                    ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(product.pack,style: TextStyle(
                      color: Colors.blueAccent[700],
                      letterSpacing: 2.0,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ],
                ),
              ],
            ),
          ),]
      ),
    );
  }

  Future<void> _updateProduct(BuildContext context,Product product) async {
    TextEditingController _name = TextEditingController();
    TextEditingController _pack = TextEditingController();
    TextEditingController _unit = TextEditingController();
    product.name != null? _name.text = product.name : {};
    product.pack != null? _pack.text = product.pack :  {print("pack")};
    product.unit != null? _unit.text = product.unit :  {print("unit")};

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('update product'),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        product.name = value;
                      });
                    },
                    controller: _name,
                    decoration: InputDecoration(hintText: "Name"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: TextField(
                        keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          product.unit = value;
                        });
                      },
                      controller: _unit,
                      decoration: InputDecoration(hintText: "Unit"),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          product.pack = value;
                        });
                      },
                      controller: _pack,
                      decoration: InputDecoration(hintText: "Pack"),
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    DatabaseService().updateProductData(product.name, product.id, product.unit, product.pack);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                },
              ),

            ],
          );
        });
  }
}
