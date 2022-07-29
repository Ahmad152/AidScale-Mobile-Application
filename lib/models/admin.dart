//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AdminTile extends StatelessWidget {
  const AdminTile({Key? key,required this.admin}) : super(key: key);
  final Admin admin;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: Colors.blue[100],
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.black,
          ),
          title: Text(admin.name),
          subtitle: Text('email: ${admin.email}\nAuthority: ${admin.authority}'),
          trailing: TextButton(
            onPressed: () {

            },
            child: Icon(Icons.edit,color: Colors.blue[200],),
          ),
        ),
      ),
    );
  }
}

class Admin{
  String name;
  String email;
  String authority;

  Admin({required this.authority,required this.email,required this.name});

}

class AdminsList extends StatefulWidget {
  const AdminsList({Key? key}) : super(key: key);

  @override
  State<AdminsList> createState() => _AdminsListState();
}

class _AdminsListState extends State<AdminsList> {
  @override
  Widget build(BuildContext context) {
    final admins = Provider.of<List<Admin>?>(context);
    return admins == null ? Container():ListView.builder(
      itemCount: admins.length,
      itemBuilder: (context, index){
        return AdminTile(admin: admins[index]);
      },
    );
  }
}
