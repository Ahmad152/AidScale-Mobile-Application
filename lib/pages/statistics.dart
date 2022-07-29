import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:aid_scale/pages/services/database.dart';
import 'package:aid_scale/models/product.dart';
import 'package:provider/provider.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  void initState() {
    _chartJobsPerWorker = [];
    _chartJobsPerProduct = [];
    _barWorkerPerProduct = [];
    super.initState();
  }

  // int _selectedIndex = 0;
  late List<WorkerData> _chartJobsPerWorker;
  late List<WorkerData> _chartJobsPerProduct;
  late List<WorkerData> _barWorkerPerProduct;

  // static const TextStyle optionStyle =
  // TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  void updateData() async {
    String date = (selectedDate.day < 10 ? "0":"") + selectedDate.day.toString() +
        (selectedDate.month < 10 ? ".0":".") + selectedDate.month.toString() +
        "." + selectedDate.year.toString();
    print(date);
    var list2 = DatabaseService().jobsPerWorker(date);
    var list1 = DatabaseService().jobsPerProducts(date);
    showDialog(context: context, builder: (context) {
      return Container(
        child: SpinKitChasingDots(

          color: Colors.blue,
          size: 50.0,
        ),
      );
    });
    await list2.then((value) async => await (_chartJobsPerWorker = value));
    await list1.then((value) async => await (_chartJobsPerProduct = value));
    Navigator.pop(context);
    setState(() {
      // print(list);
      //_selectedIndex = index;
      list2.then((value) => (_chartJobsPerWorker = _chartJobsPerWorker));
      //print(await _chartData);
    });
  }
  void updateWorkers(String product) async {
    String date = (selectedDate.day < 10 ? "0":"") + selectedDate.day.toString() +
        (selectedDate.month < 10 ? ".0":".") + selectedDate.month.toString() +
        "." + selectedDate.year.toString();
    print(date);
    var list1 = DatabaseService().workerPerProduct(date,product);

    showDialog(context: context, builder: (context) {
      return Container(
        child: SpinKitChasingDots(

          color: Colors.blue,
          size: 50.0,
        ),
      );
    });
    await list1.then((value) async => await (_barWorkerPerProduct = value));
    Navigator.pop(context);
    setState(() {
      // print(list);
      //_selectedIndex = index;
      list1.then((value) => (_barWorkerPerProduct = _barWorkerPerProduct));
      //print(await _chartData);
    });
  }

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022, 3),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
    updateData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        //backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            viewChart(1),
            viewChart(2),
            viewChart(3),
            viewChart(4),
            viewChart(5),
            SizedBox(height: 100,)

          ],
        ),
      ),

    //scroll and drag:
      /*SizedBox.expand(
        child: DraggableScrollableSheet(
        builder: (BuildContext context, ScrollController scrollController) {
      return Container(
        color: Colors.blue[100],
        child: ListView.builder(
          controller: scrollController,
          itemCount: 25,
          itemBuilder: (BuildContext context, int index) {
            return viewChart(index);
          },
        ),
      );
    },
    ),
      ),*/

      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
          onPressed: //updateData,
            () => _selectDate(context),
          backgroundColor: Colors.blue,
          icon: Icon(Icons.bar_chart),
          label: Text('Statistics'),
          ),
          SizedBox(height: 10,),
          FloatingActionButton.extended(
            onPressed:
                () => chooseProduct(),
            backgroundColor: Colors.blue,
            label: Text('Top Workers'),
          ),
          SizedBox(height: 5,),
        ],
      ),

    );
  }


  Widget viewChart(int num) {
    if(_chartJobsPerProduct.isEmpty && num == 1){
      return Center(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Image.asset('asset/Stat.png'),
              SizedBox(height: 10,),
              Text('display statistics charts according to the date by'),
              Text(' pressing the statistics button'),
              Text(' statistics',style: TextStyle(color: Colors.blue,fontSize: 20),),
              Text(' button'),
            ],
          )
      );
    }else if(_chartJobsPerProduct.isEmpty && num != 5) return Container();
    if(num == 1){
      return SafeArea(
        child: SfCircularChart(
          title: ChartTitle(text: 'product per worker',textStyle: TextStyle(color: Colors.blueAccent,fontSize: 20,)),
          legend: Legend(
              isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
          series: <CircularSeries>[
            RadialBarSeries<WorkerData, String>(
              //trackColor: Colors.blue[200]!,
              //maximumValue: 22,
              dataSource: _chartJobsPerWorker,
              xValueMapper: (WorkerData data, _) => data.name,
              yValueMapper: (WorkerData data, _) => data.jobs,
              dataLabelSettings: DataLabelSettings(isVisible: false),
            )
          ],
        ),
      );
    }
    if(num == 2){
      return SafeArea(
        child: Column(
          children: [
            SfCartesianChart(

                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries>[
                  ColumnSeries<WorkerData, String>(
                      dataSource: _chartJobsPerWorker,
                      xValueMapper: (WorkerData data, _) => data.name,
                      yValueMapper: (WorkerData data, _) => data.jobs,
                      // Map color for each data points from the data source
                      //pointColorMapper: (Data data, _) => data.color
                  )
                ]
            ),
            SizedBox(height: 50,),
          ],
        )
      );
    }
    if(num == 3){
      return SafeArea(
          child: Column(
            children: [
              SfCartesianChart(
                title: ChartTitle(text: 'Avg time per mission',textStyle: TextStyle(color: Colors.blueAccent,fontSize: 20,)),
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    ColumnSeries<WorkerData, String>(
                      dataSource: _chartJobsPerWorker,
                      xValueMapper: (WorkerData data, _) => data.name,
                      yValueMapper: (WorkerData data, _) => data.workTime/data.jobs,
                      // Map color for each data points from the data source
                      //pointColorMapper: (Data data, _) => data.color
                    )
                  ]
              ),
              SizedBox(height: 50,),
            ],
          )
      );
    }
    if(num == 4){
      return SafeArea(
          child: Column(
            children: [
              SfCartesianChart(
                title: ChartTitle(text: 'tolerance per product',textStyle: TextStyle(color: Colors.blueAccent,fontSize: 20,)),
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    ColumnSeries<WorkerData, String>(
                      dataSource: _chartJobsPerProduct,
                      xValueMapper: (WorkerData data, _) => data.name,
                      yValueMapper: (WorkerData data, _) => data.workTime,
                      // Map color for each data points from the data source
                      //pointColorMapper: (Data data, _) => data.color
                    )
                  ]
              ),
              SizedBox(height: 50,),
            ],
          )
      );
    }
    if(num == 5){
      if(!_barWorkerPerProduct.isEmpty){
        return SafeArea(
            child: SfCartesianChart(
                title: ChartTitle(text: '  Top Workers   ',textStyle: TextStyle(color: Colors.blueAccent,fontSize: 20,)),
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  // Renders bar chart
                  BarSeries<WorkerData, String>(
                    //sortingOrder: SortingOrder.descending,
                    dataSource: _barWorkerPerProduct,
                    xValueMapper: (WorkerData data, _) => data.name,
                    yValueMapper: (WorkerData data, _) => data.workTime/data.jobs,
                  )
                ]
            )
        );  
      }else{
        return Center(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Text(' select product from '),
              Text('Top Workers',style: TextStyle(color: Colors.blue,fontSize: 20),)
            ],
          ),
        );
      }
    }
    return Container();

  }
  Future<void> chooseProduct(){
    Product _currentProduct =  Product(id: '', name: '', unit: '', pack: '');
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('pick product'),
            content: StreamProvider<List<Product>?>.value(
              value: DatabaseService().product,
              initialData: [],
              child: Container(
                height: 100,
                child: Column(
                  children: [
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
                    updateWorkers(_currentProduct.name);
                    Navigator.pop(context);
                  });
                },
              ),

            ],
          );
        });
  }
}
class WorkerData{
  String name;
  int jobs;
  double workTime;
  WorkerData(this.name,this.jobs,this.workTime);
}




