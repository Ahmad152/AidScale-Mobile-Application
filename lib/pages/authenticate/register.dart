import 'package:aid_scale/pages/authenticate/auth.dart';
import 'package:aid_scale/pages/loading.dart';
import 'package:flutter/material.dart';
import 'package:aid_scale/pages/services/database.dart';

class Register extends StatefulWidget {
  const Register({Key? key ,required this.toggleView}) : super(key: key);

  final Function toggleView ;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _id = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Register Page"),
        actions: [
          TextButton.icon(
            onPressed: (){
              widget.toggleView();
            },
            label: Text("",style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.close,color: Colors.white,),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      /*decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50.0)),*/
                      child: Image.asset('asset/shake.png')),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                  ),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),                child: TextField(
                  controller: _id,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ID',
                  ),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),                child: TextField(
                  controller: _email,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter valid email id as abc@gmail.com'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                ),
              ),
              SizedBox(height: 25.0,),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () async {
                    setState((){ loading = true; });
                    dynamic result = await _auth.registerEmail(_email.text, _password.text);
                    if(result == null){
                      setState((){ loading = false; });
                      _email.clear();
                      _password.clear();
                      print('error sign up');
                    } else {
                      DatabaseService().updateAdminData(_name.text, _id.text, _email.text, '2');
                    }



                    // dynamic result = await _auth.signInAnon();
                    // if(result == null){
                    //   print('error signing in');
                    // }else{
                    //   print('signed in');
                    // }

                  },
                  child: Text(
                    'sign up',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 130,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
