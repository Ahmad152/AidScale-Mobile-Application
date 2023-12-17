import 'package:aid_scale/models/admin.dart';
import 'package:aid_scale/models/product.dart';
import 'package:aid_scale/models/worker.dart';
import 'package:aid_scale/pages/statistics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseService {


  //Workers Collection
  final CollectionReference workerData = FirebaseFirestore.instance.collection('Workers');

  //Admins Collection
  final CollectionReference adminsData = FirebaseFirestore.instance.collection('Admins');

  //Products Collection
  final CollectionReference productsData = FirebaseFirestore.instance.collection('Products');

  //Jobs Collection
  final CollectionReference jobsData = FirebaseFirestore.instance.collection('Jobs');




  //update worker
  Future updateWorkerData(String name,String id, String language, String product) async{
    return await workerData.doc(id).set({
      'Name': name,
      'ID': id,
      'Language': language,
      'Product': product,
    });
  }

  //update admin
  Future updateAdminData(String name,String id, String email, String authority) async{
    return await adminsData.doc(email).set({
      'Name': name,
      'ID': id,
      'Email': email,
      'Authority': authority,
    });
  }

  //update product
  Future updateProductData(String name,String id, String unit, String pack) async{
    return await productsData.doc(id).set({
      'Name': name,
      'ID': id,
      'Unit': unit,
      'Pack': pack,
    });
  }

  //update job
  Future updateJobData(
      {required String id,
      required String name,
      required String weight,
      String submitTime = '12:12' ,
      required String workTime,
      required String tolerance,
      required String date}) async{
    Map<String,Object?> map1 = {
      'ID': id,
      'Name': name ,
      'Weight': weight,
      'SubmitTime': submitTime,
      'WorkTime':workTime,
      'Tolerance':tolerance
    };
    List a = [map1];
    Map<String,Object?> map2 = {'jobs': FieldValue.arrayUnion(a) };
    return await jobsData.doc(date).update(map2)
    //     {
    //
    //   // 'ID': id,
    //   // 'Weight': weight,
    //   // 'Time': time,
    // }
    ;
  }




  //remove worker
  void removeWorker(String id){
    print(id);
    FirebaseFirestore.instance.collection('Workers').doc(id).delete();
  }

  //remove admin
  void removeAdmin(String id){
    print(id);
    FirebaseFirestore.instance.collection('Admins').doc(id).delete();
  }

  //remove product
  void removeProduct(String id){
    print(id);
    FirebaseFirestore.instance.collection('Products').doc(id).delete();
  }




  //make a list of workers from a snapshot
  List<Worker>? _workerListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      Map ddt = doc.data() as Map;
      return Worker(
          product: ddt['Product'].toString(),
          language: ddt['Language'].toString(),
          name: ddt['Name'].toString(),
          id: ddt['ID'].toString()
      );
    }).toList();
  }

  //make a list of workers from a snapshot
  List<Admin>? _adminsListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      Map ddt = doc.data() as Map;
      return Admin(
          email: ddt['Email'].toString(),
          authority: ddt['Authority'].toString(),
          name: ddt['Name'].toString(),
      );
    }).toList();
  }

  //make a list of workers from a snapshot
  List<Product>? _productsListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc) {
      Map ddt = doc.data() as Map;
      return Product(
        name: ddt['Name'].toString(),
        id : ddt['ID'].toString(),
        unit: ddt['Unit'].toString(),
        pack: ddt['Pack'].toString(),
      );
    }).toList();
  }

  //make a list of data from a snapshot
  Future<List<WorkerData>> jobsPerWorker(String from,String to)async{
      CollectionReference data = FirebaseFirestore.instance.collection('Jobs');
      List<WorkerData> list = [];
      int year = int.parse(from.substring(6,10));
      int month = int.parse(from.substring(3,5));
      int day = int.parse(from.substring(0,2));
      DateTime curr = DateTime.utc(year,month,day);
      year = int.parse(to.substring(6,10));
      month = int.parse(to.substring(3,5));
      day = int.parse(to.substring(0,2));
      DateTime until = DateTime.utc(year,month,day);
      print(curr);
      print(until);
      for(;curr!=until.add(Duration(days: 1));curr = curr.add(Duration(days: 1))) {
        print(curr);
        String today = (curr.day < 10 ? "0":"") + curr.day.toString() +
            (curr.month < 10 ? ".0":".") + curr.month.toString() +
            "." + curr.year.toString();
      DocumentSnapshot snapshot = await data.doc(today).get();
      if(!snapshot.exists){
        print('$snapshot :=> date does not exists in function jobsPerWorker\n');
        continue;
      }
      List<dynamic> dat = snapshot['jobs'];
      bool firstInDay = true;
        for (int i = 0; i < dat.length; i++) {
          // print(dat[i]);
          bool flag = false;
          list.forEach((element) {
            // print(element.name + ' =? ' + dat[i]['ID']);
            if (element.name == dat[i]['Name']) {
              String subTime = dat[i]['SubmitTime'].toString();
              var times = subTime.split(":");
              print('hours: ${int.parse(times[0])*3600} min: ${int.parse(times[1])*60} sec: ${int.parse(times[2])}');
              double workTime = dat[i]['WorkTime'] as double;
              double startTime = (int.parse(times[0])*3600)+
                  (int.parse(times[1])*60)+
                  int.parse(times[2])
                  - workTime;
              if(element.endTime<startTime) element.endTime = startTime;
              if(firstInDay) {
                element.startTime = startTime;
                element.endTime = startTime + workTime;
                firstInDay = false;
              }
              print('start time: ${element.startTime} end time: ${element.endTime}');
              element.jobs++;
              element.workTime += dat[i]['WorkTime'] as double;
              element.tolerance += dat[i]['Tolerance'].abs() ;
              flag = true;
            }
          });
          if (!flag) {
            String subTime = dat[i]['SubmitTime'].toString();
            var times = subTime.split(":");
            double workTime = dat[i]['WorkTime'];
            double startTime = (int.parse(times[0])*3600)+
                            (int.parse(times[1])*60)+
                            int.parse(times[2])
                            - workTime;
            list.add(WorkerData(dat[i]['Name'], 1, dat[i]['WorkTime'] as double,
                startTime,startTime+workTime,0,0,0));
            firstInDay = false;
          }
        }
        list.forEach((element) {
          print('start time: ${element.startTime} end time: ${element.endTime}');
          element.totalTime+=(element.endTime-element.startTime);
          print('total: ${element.totalTime}');
          element.workDays++;
        });
      }
      return list;
    }

  Future<List<WorkerData>> jobsPerProducts(String from, String to)async{
    CollectionReference data = FirebaseFirestore.instance.collection('Jobs');
    List<WorkerData> list = [];
    int year = int.parse(from.substring(6,10));
    int month = int.parse(from.substring(3,5));
    int day = int.parse(from.substring(0,2));
    DateTime curr = DateTime.utc(year,month,day);
    year = int.parse(to.substring(6,10));
    month = int.parse(to.substring(3,5));
    day = int.parse(to.substring(0,2));
    DateTime until = DateTime.utc(year,month,day);
    for(;curr!=until.add(Duration(days: 1));curr = curr.add(Duration(days: 1))) {
      print(curr);
      String today = (curr.day < 10 ? "0" : "") + curr.day.toString() +
          (curr.month < 10 ? ".0" : ".") + curr.month.toString() +
          "." + curr.year.toString();
      DocumentSnapshot snapshot = await data.doc(today).get();
      if(!snapshot.exists){
        print('$snapshot :=> date does not exists in function jobsPerProducts\n');
        continue;
      }
      List<dynamic> dat = snapshot['jobs'];
      for (int i = 0; i < dat.length; i++) {
        // print(dat[i]);
        bool flag = false;
        list.forEach((element) {
          // print(element.name + ' =? ' + dat[i]['ID']);
          if (element.name == dat[i]['ProductName']) {
            element.jobs++;
            element.workTime += dat[i]['Tolerance'] as double;
            flag = true;
          }
        });
        if (!flag) list.add(WorkerData(
            dat[i]['ProductName'],
            1,
            dat[i]['Tolerance'] as double,
            0,0,0,0,0));
      }
      // print(list);
    }
    return list;
  }

  Future<List<WorkerData>> workerPerProduct(String from,String to, String product,PrimitiveWrapper avg)async {
    CollectionReference data = FirebaseFirestore.instance.collection('Jobs');
    List<WorkerData> list = [];



    int year = int.parse(from.substring(6,10));
    int month = int.parse(from.substring(3,5));
    int day = int.parse(from.substring(0,2));
    DateTime curr = DateTime.utc(year,month,day);
    year = int.parse(to.substring(6,10));
    month = int.parse(to.substring(3,5));
    day = int.parse(to.substring(0,2));
    DateTime until = DateTime.utc(year,month,day);
    double sum=0 , num=0;
    for(;curr!=until.add(Duration(days: 1));curr = curr.add(Duration(days: 1))) {
      print(curr);
      String today = (curr.day < 10 ? "0" : "") + curr.day.toString() +
          (curr.month < 10 ? ".0" : ".") + curr.month.toString() +
          "." + curr.year.toString();

      DocumentSnapshot snapshot = await data.doc(today).get();
      if (!snapshot.exists) {
        print('$snapshot :=> date: $today does not exists in function jobsPerWorker\n');
        continue;
      }
      List<dynamic> dat = snapshot['jobs'];
      for (int i = 0; i < dat.length; i++) {
        // print(dat[i]);
        bool flag = false;
        list.forEach((element) {
          // print(element.name + ' =? ' + dat[i]['ID']);
          if (element.name == dat[i]['Name'] &&
              product == dat[i]['ProductName']) {
            sum += dat[i]['Tolerance'];
            num++;
            element.totalTime = dat[i]['Tolerance'];
            element.jobs++;
            element.workTime += dat[i]['WorkTime'] as double;
            flag = true;
          }
        });
        if (!flag && product == dat[i]['ProductName'])
          list.add(WorkerData(
              dat[i]['Name'],
              1,
              dat[i]['WorkTime'] as double,
              0,0,0,0,0));
        else {
          print(dat[i]['ProductName']);
          print(product);
          print(product == dat[i]['ProductName']);
        }
      }
    }
    // print(list);
    avg.value = sum/num;
    return list;
  }


  Future<List<List<dynamic>>> getRawData(String from,String to)async{
    CollectionReference data = FirebaseFirestore.instance.collection('Jobs');
    List<List<dynamic>> list = <List<dynamic>>[];
    list.add([
      "ID",
      "Name",
      "ProductName",
      "SubmitTime",
      "Tolerance [%]",
      "Weight [g]",
      "WorkTime [sec]"
    ]);
    int year = int.parse(from.substring(6,10));
    int month = int.parse(from.substring(3,5));
    int day = int.parse(from.substring(0,2));
    DateTime curr = DateTime.utc(year,month,day);
    year = int.parse(to.substring(6,10));
    month = int.parse(to.substring(3,5));
    day = int.parse(to.substring(0,2));
    DateTime until = DateTime.utc(year,month,day);
    print(curr);
    print(until);
    for(;curr!=until.add(Duration(days: 1));curr = curr.add(Duration(days: 1))) {
      print(curr);
      String today = (curr.day < 10 ? "0":"") + curr.day.toString() +
          (curr.month < 10 ? ".0":".") + curr.month.toString() +
          "." + curr.year.toString();
      DocumentSnapshot snapshot = await data.doc(today).get();
      if(!snapshot.exists){
        print('$snapshot :=> date does not exists in function jobsPerWorker\n');
        continue;
      }
      List<dynamic> dat = snapshot['jobs'];
      for (int i = 0; i < dat.length; i++) {
        List<dynamic> row = <dynamic>[];
        row.add(dat[i]['ID']);
        row.add(dat[i]['Name']);
        row.add(dat[i]['ProductName']);
        row.add(dat[i]['SubmitTime']);
        row.add(dat[i]['Tolerance']);
        row.add(dat[i]['Weight']);
        row.add(dat[i]['WorkTime']);
        list.add(row);
      }
    }
    return list;
  }
  // Future<List<Data>> productListFromSnapshot()async{
  //   CollectionReference data = FirebaseFirestore.instance.collection('Products');
  //   DocumentSnapshot snapshot = await data.doc().get();
  //   return snapshot.docs.map((doc) {
  //     Map ddt = doc.data() as Map;
  //     return Product(
  //       name: ddt['Name'].toString(),
  //       id : ddt['ID'].toString(),
  //       unit: ddt['Unit'].toString(),
  //       pack: ddt['Pack'].toString(),
  //     );
  //   }).toList();
  // }





  //make a stream for workers
  Stream<List<Worker>?> get worker {
    return workerData.snapshots().map(_workerListFromSnapshot);
  }

  //make a stream for workers
  Stream<List<Admin>?> get admin {
    return adminsData.snapshots().map(_adminsListFromSnapshot);
  }

  //make a stream for workers
  Stream<List<Product>?> get product {
    return productsData.snapshots().map(_productsListFromSnapshot);
  }





}