import 'package:aid_scale/models/worker.dart';
import 'package:flutter/material.dart';
import 'package:aid_scale/pages/services/database.dart';
import 'package:aid_scale/models/product.dart';
import 'package:provider/provider.dart';


class WorkerPage extends StatefulWidget {
  const WorkerPage({Key? key,required this.worker}) : super(key: key);
  final Worker worker;

  @override
  State<WorkerPage> createState() => _WorkerState();
}

class _WorkerState extends State<WorkerPage> {
  TextStyle textStyle = TextStyle(
    color: Colors.white,
    letterSpacing: 2.0,
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    Worker worker = widget.worker;
    return Scaffold(
      //backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            _updateWorker(
                context,
                worker.id,
                productName: worker.product,
                name: worker.name,
                language: worker.language);
          }, icon: Icon(Icons.build , color: Colors.white)),
        ],
        title: Text('Worker'),
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
              Text(worker.name,style: TextStyle(
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
              Text(worker.id,style: TextStyle(
                color: Colors.blueAccent[700],
                letterSpacing: 2.0,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text("Language",style: TextStyle(
                color: Colors.blueAccent[100],
                letterSpacing: 2.0,
              ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(worker.language,style: TextStyle(
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
                  Text("Product",style: TextStyle(
                    color: Colors.blueAccent[100],
                    letterSpacing: 2.0,
                  ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(worker.product,style: TextStyle(
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

  Future<void> _updateWorker(BuildContext context,String id,{String? name = null,String? language = null,required String productName}) async {
    TextEditingController _name = TextEditingController();
    name != null? _name.text = name : {};
    late List<String> _languages = ['Arabic','Hebrew','Russian'];
    String  _currentLanguage = 'Arabic';
    language != null? _currentLanguage = language : {};
    Product _currentProduct =  Product(id: '', name: productName, unit: '', pack: '');

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: StreamProvider<List<Product>?>.value(
              value: DatabaseService().product,
              initialData: [],
              child: Container(
                height: 200,
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      controller: _name,
                      decoration: InputDecoration(hintText: "Update Worker"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      child: DropdownButtonFormField(
                        icon: Icon(Icons.arrow_right),
                        value: _currentLanguage,
                        items: _languages.map((language) {
                          return DropdownMenuItem(
                            child: Text('${language}'),
                            value: language,
                          );
                        }).toList(),
                        onChanged: (value) { setState(()=> _currentLanguage = value.toString()); },
                      ),
                    ),
                    Padding(padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                      child: ProductDropDown(_currentProduct),
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    DatabaseService().updateWorkerData(name!, id, _currentLanguage, _currentProduct.name);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                },
              ),

            ],
          );
        });
  }

  // static Future<List<Product>> _getEventsFromFirestore() async {
  //   CollectionReference ref = FirebaseFirestore.instance.collection('Products');
  //   QuerySnapshot eventsQuery = await ref
  //       .where("time", isGreaterThan: new DateTime.now().millisecondsSinceEpoch)
  //       .where("food", isEqualTo: true)
  //       .getDocuments();
  //
  //   HashMap<String, AustinFeedsMeEvent> eventsHashMap = new HashMap<String, AustinFeedsMeEvent>();
  //
  //   eventsQuery.documents.forEach((document) {
  //     eventsHashMap.putIfAbsent(document['id'], () => new AustinFeedsMeEvent(
  //         name: document['name'],
  //         time: document['time'],
  //         description: document['description'],
  //         url: document['event_url'],
  //         photoUrl: _getEventPhotoUrl(document['group']),
  //         latLng: _getLatLng(document)));
  //   });
  //
  //   return eventsHashMap.values.toList();
  // }

}
