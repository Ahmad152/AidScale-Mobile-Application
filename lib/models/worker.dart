//import 'dart:html';
import 'package:aid_scale/pages/loading.dart';
import 'package:aid_scale/pages/workerPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:aid_scale/pages/services/database.dart';



class WorkerTile extends StatelessWidget {
  const WorkerTile({Key? key,required this.worker}) : super(key: key);
  final Worker worker;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.0,bottom: 4.0),
      child: Card(
        color: Colors.blue[100],
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: Slidable(
          useTextDirection: true,
          closeOnScroll: true,
          startActionPane: ActionPane(motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context){DatabaseService().removeWorker(worker.id);},
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: (context){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  WorkerPage(worker: worker,))
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
              radius: 30,
              child: Image(image: AssetImage("asset/workerIcon.png"),fit: BoxFit.fill,),
              backgroundColor: Colors.transparent,
            ),
            title: Text(worker.name),
            subtitle: Text('ID: ${worker.id}\nlanguage: ${worker.language}'),
            trailing: Icon(Icons.arrow_right)
          ),
        ),
      ),
    );
  }
}

class Worker{
  String name;
  String id;
  String language;
  String product;

  Worker({required this.product,required this.language,required this.name,required this.id});

}

class WorkersList extends StatefulWidget {
  const WorkersList({Key? key}) : super(key: key);

  @override
  State<WorkersList> createState() => _WorkersListState();
}

class _WorkersListState extends State<WorkersList> {
  @override
  Widget build(BuildContext context) {
    final workers = Provider.of<List<Worker>?>(context);
    //print(workers.docs);
    // if(workers == null) print('NULL LIST');
    workers?.forEach((worker) {
      print(worker.id );
      print(worker.name);
      print(worker.language);
      print(worker.product);
    });
    return workers == null ? Loading():ListView.builder(
      itemCount: workers.length,
      itemBuilder: (context, index){
        return WorkerTile(worker: workers[index]);
      },
    );
  }
}
