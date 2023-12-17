import 'package:aid_scale/models/product.dart';
import 'package:aid_scale/models/worker.dart';
import 'package:aid_scale/pages/authenticate/auth.dart';
import 'package:flutter/material.dart';
import 'package:aid_scale/pages/statistics.dart';
import 'package:aid_scale/pages/services/database.dart';
import 'package:provider/provider.dart';
import 'package:aid_scale/models/admin.dart';

String name = "";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);



  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  final AuthService _auth = AuthService();
  int _selectedIndex = 0;
  late List<String> _languages = ['Arabic','Hebrew','Russian'];


  @override
  Widget build(BuildContext context) {
    Widget FB(int index) {
      if (index == 0) {
        return Container();
      }
      if(index == 3){
        return FloatingActionButton.extended(
            onPressed: () => addNewProduct(),
            backgroundColor: Colors.blue,
            icon: Icon(Icons.add),
            label: Text('Add')
        );
      }
      return FloatingActionButton.extended(
        onPressed: () => addNewWorker(),
        backgroundColor: Colors.blue,
        icon: Icon(Icons.add),
        label: Text('Add'),
      );
    }


    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () async {
              await _auth.signout();
            },
            icon: Icon(Icons.logout, color: Colors.white,),
            label: Text('logout', style: TextStyle(color: Colors.white),),
          ),
        ],
        title: const Text('Aid Scale'),
      ),
      body:  option(_selectedIndex),
      floatingActionButton: FB(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        selectedFontSize: 15,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.ssid_chart_outlined,),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_ind,),
            label: 'Workers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business,),
            label: 'Admins',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront,),
            label: 'Products',
          ),
        ],
      ),
    );
  }


  void addNewWorker() {
    TextEditingController _name = TextEditingController();
    TextEditingController _id = TextEditingController();
    String  _currentLanguage = 'Arabic';
    Product _currentProduct =  Product(id: '', name: '', unit: '', pack: '');



    showModalBottomSheet(context: context,isScrollControlled: true, builder: (context) {
      return StreamProvider<List<Product>?>.value(
        value: DatabaseService().product,
        initialData: [],
        child: Scaffold(
          appBar: AppBar(
            title: Text('New Worker'),
          ),
          body: SingleChildScrollView(
            child: Form(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Center(
                      child: Container(
                          width: 200,
                          height: 150,
                          child: Image.asset('asset/workerIcon.png')),
                    ),
                  ),
                  Padding(
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
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: TextField(
                      controller: _id,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'ID',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
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
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: ProductDropDown(_currentProduct),
                  ),
                  SizedBox(
                    height: 50,
                  ),

                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () async {
                        DatabaseService().updateWorkerData(_name.text, _id.text, _currentLanguage, _currentProduct.name);
                        _name.clear();
                        _id.clear();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void addNewAdmin() {
    TextEditingController _name = TextEditingController();
    TextEditingController _id = TextEditingController();
    TextEditingController _email = TextEditingController();
    List<String> _authorities = ['0','1','2'];
    String  _currentAuthority = '1';

    showModalBottomSheet(context: context,isScrollControlled: true, builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('New Admin'),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: Container(
                        width: 200,
                        height: 150,
                        child: Image.asset('asset/workerIcon.png')),
                  ),
                ),
                Padding(
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
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextField(
                    controller: _id,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ID',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: DropdownButtonFormField(
                    icon: Icon(Icons.arrow_right),
                    value: _currentAuthority,
                    items: _authorities.map((auth) {
                      return DropdownMenuItem(
                        child: Text('${auth}'),
                        value: auth,
                      );
                    }).toList(),
                    onChanged: (value) { setState(()=> _currentAuthority = value.toString()); },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),

                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () async {
                      DatabaseService().updateAdminData(_name.text, _id.text, _email.text, _currentAuthority);
                      _name.clear();
                      _id.clear();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void addNewProduct() {
    TextEditingController _name = TextEditingController();
    TextEditingController _id = TextEditingController();
    TextEditingController _unit = TextEditingController();
    TextEditingController _pack = TextEditingController();

    showModalBottomSheet(context: context,isScrollControlled: true, builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('New Product'),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: Container(
                        width: 200,
                        height: 150,
                        child: Image.asset('asset/nail.png')),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextField(
                    controller: _id,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Product name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextField(
                    controller: _name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _unit,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Unit weight',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _pack,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Units Per Pack',
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),

                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () async {
                      DatabaseService().updateProductData(_name.text, _id.text, _unit.text, _pack.text);
                      _name.clear();
                      _id.clear();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void addJob() {

    TextEditingController _id = TextEditingController();
    TextEditingController _name = TextEditingController();
    TextEditingController _time = TextEditingController();
    TextEditingController _weight = TextEditingController();

    showModalBottomSheet(context: context,isScrollControlled: true, builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Add job'),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Center(
                    child: Container(
                        width: 200,
                        height: 150,
                        child: Image.asset('asset/workerIcon.png')),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: _id,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'worker id',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextField(
                    controller: _name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextField(
                    controller: _time,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'time',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextField(
                    controller: _weight,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'weight',
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),

                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () async {
                      DatabaseService().updateJobData(
                          id:_id.text,
                          weight:_weight.text,
                          workTime:_time.text,
                          date: '5.25.2022',
                          name: _name.text,
                          tolerance: '0'
                      );
                      _id.clear();
                      _weight.clear();
                      _time.clear();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget option(int index) {
    if (index == 0) {
      return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("asset/background.png"),
              )
          ),
          child: Statistics()
      );
    }
    if (index == 1) {
      return StreamProvider<List<Worker>?>.value(
          value: DatabaseService().worker,
          initialData: null,
          child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("asset/background.png"),
                )
              ),
              child: WorkersList(),
          ),
      );
    }
    if (index == 2) {
      return StreamProvider<List<Admin>?>.value(
        value: DatabaseService().admin,
        initialData: null,
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("asset/background.png"),
                )
            ),
            child: AdminsList()
        ),
      );
    }
    return StreamProvider.value(
      value: DatabaseService().product,
      initialData: null,
      child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("asset/background.png"),
              )
          ),
          child: ProductsList()
      ),
    );
  }
}


