//import 'dart:html';

import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:aid_scale/pages/services/database.dart';
import 'package:aid_scale/models/product.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';



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
    var list2 = DatabaseService().jobsPerWorker(_fromDate,_toDate);
    var list1 = DatabaseService().jobsPerProducts(_fromDate,_toDate);
    showDialog(context: context, barrierDismissible: false,builder: (context) {
      return Container(
        child: SpinKitChasingDots(

          color: Colors.blue,
          size: 50.0,
        ),
      );
    });
    _barWorkerPerProduct.clear();
    await list2.then((value) async => await (_chartJobsPerWorker = value));
    await list1.then((value) async => await (_chartJobsPerProduct = value));
    Navigator.pop(context);
    Navigator.pop(context);
    setState(() {
      // print(list);
      //_selectedIndex = index;
      list2.then((value) => (_chartJobsPerWorker = _chartJobsPerWorker));
      //print(await _chartData);
    });
    if(_chartJobsPerWorker.isEmpty){
      showDialog(context: context, builder: (BuildContext context){return AlertDialog(
        title: const Text('No Jobs'),
        content: const Text('there is no jobs in the period you selected.\n'
            'please select another dates\n'),
        actions: [TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ],
      );
      });
    }
    //sendMailAndAttachment();
  }
  void updateWorkers(String product) async {
    String date = (selectedDate.day < 10 ? "0":"") + selectedDate.day.toString() +
        (selectedDate.month < 10 ? ".0":".") + selectedDate.month.toString() +
        "." + selectedDate.year.toString();
    print(date);


    var list1 = DatabaseService().workerPerProduct(_fromDate,_toDate,product,avg);
    showDialog(context: context,barrierDismissible: false, builder: (context) {
      return Container(
        child: SpinKitChasingDots(

          color: Colors.blue,
          size: 50.0,
        ),
      );
    });

    await list1.then((value) async => await (_barWorkerPerProduct = value));

    setState(() {
      list1.then((value) => (_barWorkerPerProduct = _barWorkerPerProduct));
    });
    Navigator.pop(context);
    if(_barWorkerPerProduct.isEmpty){
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Product is not found'),
          content: const Text(
              'the product you selected is not found in the selected dates.\n'
                  'please select another product\n'
                  'or select another dates'),
          actions: [TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme
                  .of(context)
                  .textTheme
                  .labelLarge,
            ),
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ],
        );
      });
    }
  }

  PrimitiveWrapper avg = new PrimitiveWrapper(0);
  DateTime selectedDate = DateTime.now();
  /*Future<void> _selectDate(BuildContext context) async {
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
  }*/

  void _selectDate(){
    String currentProcess;
    bool isProcessing = false;
    DateTime time = DateTime.now().subtract(const Duration(days: 1));
    _fromDate = (time.day < 10 ? "0":"") + time.day.toString() +
        (time.month < 10 ? ".0":".") + time.month.toString() +
        "." + time.year.toString();
    time = DateTime.now().subtract(const Duration(days: 0));
    _toDate = (time.day < 10 ? "0":"") + time.day.toString() +
        (time.month < 10 ? ".0":".") + time.month.toString() +
        "." + time.year.toString();
    print('from: $_fromDate to: $_toDate @statistics l114');

    showModalBottomSheet(context: context,isScrollControlled: true, builder: (context) {
      return Scaffold(
        body: Column(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 20,),
              Text('Selected range: $_range'),
              SizedBox(height: 50,),
              SfDateRangePicker(
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 1)),
                    DateTime.now().add(const Duration(days: 0))),
              ),
              SizedBox(height: 50,),
              TextButton(
                  child: Text("send email"),
                  onPressed: () async {
                    // if (_formkey.currentState.validate()) {
                    try {
                      final result =
                      await InternetAddress.lookup('google.com');
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        await getCsv().then((v) {
                          setState(() {
                            currentProcess =
                            "Compiling and sending mail";
                          });
                          sendMailAndAttachment().whenComplete(() {
                            setState(() {
                              isProcessing = false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Data Sent"),
                            ));
                          });
                        });
                      }
                    } on SocketException catch (_) {

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Connect your device to the internet, and try again"),
                      ));
                    }

                  }
              ),
        ]
        ),
        floatingActionButton: Row(mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: //updateData,
                  () {
                //updateData();
                Navigator.pop(context);
              },
              backgroundColor: Colors.blue,
              icon: Icon(Icons.cancel),
              label: Text('Cancel'),
            ),
            SizedBox(width: 20,),
            FloatingActionButton.extended(
              onPressed: //updateData,
                  () {
                updateData();
                //Navigator.pop(context);
              },
              backgroundColor: Colors.blue,
              icon: Icon(Icons.bar_chart),
              label: Text('Calculate'),
            ),
          ],
        ),
      );
    });
  }

  bool _isChanged = false;
  String _selectedDate = '';
  String _range = '';
  String _fromDate = '';
  String _toDate = '';
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd.MM.yyyy').format(args.value.startDate)} -'
        // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd.MM.yyyy').format(args.value.endDate ?? args.value.startDate)}';
        _fromDate = DateFormat('dd.MM.yyyy').format(args.value.startDate).toString();
        _toDate = DateFormat('dd.MM.yyyy').format(args.value.endDate ?? args.value.startDate);
        _isChanged = true;
      }
      // else if (args.value is DateTime) {
      //   //_selectedDate = args.value.toString();
      // } else if (args.value is List<DateTime>) {
      //   _dateCount = args.value.length.toString();
      // } else {
      //   _rangeCount = args.value.length.toString();
      // }
    });
  }

  @override
  Widget build(BuildContext context) {

    // final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


    return Scaffold(
        //backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            viewChart(1),
            viewChart(2),
            viewChart(3),
            viewChart(4),
            viewChart(5),
            viewChart(6),

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
            () => _selectDate(),
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
    }else if(_chartJobsPerProduct.isEmpty && num != 6) return Container();
    if(num == -1){
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
    if(num == 1){
      return SafeArea(
        child: Column(
          children: [
            SfCartesianChart(
                title: ChartTitle(text: 'num of jobs per worker',textStyle: TextStyle(color: Colors.blueAccent,fontSize: 20,)),
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
    if(num == 2){
      return SafeArea(
          child: Column(
            children: [
              SfCartesianChart(
                  title: ChartTitle(text: 'Avg job duration include downtime [m]',textStyle: TextStyle(color: Colors.blueAccent,fontSize: 20,)),
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    ColumnSeries<WorkerData, String>(
                      dataSource: _chartJobsPerWorker,
                      xValueMapper: (WorkerData data, _) => data.name,
                      yValueMapper: (WorkerData data, _) =>  data.totalTime/(data.workDays*data.jobs*60),
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
                title: ChartTitle(text: 'Avg job duration [m]',textStyle: TextStyle(color: Colors.blueAccent,fontSize: 20,)),
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    ColumnSeries<WorkerData, String>(
                      dataSource: _chartJobsPerWorker,
                      xValueMapper: (WorkerData data, _) => data.name,
                      yValueMapper: (WorkerData data, _) => data.workTime/(data.jobs*60),
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
                title: ChartTitle(text: 'tolerance per product [%]',textStyle: TextStyle(color: Colors.blueAccent,fontSize: 20,)),
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    ColumnSeries<WorkerData, String>(
                      dataSource: _chartJobsPerProduct,
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
    if(num == 5){
      return SafeArea(
          child: Column(
            children: [
              SfCartesianChart(
                  title: ChartTitle(text: 'tolerance per worker [%]',textStyle: TextStyle(color: Colors.blueAccent,fontSize: 20,)),
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    ColumnSeries<WorkerData, String>(
                      dataSource: _chartJobsPerWorker,
                      xValueMapper: (WorkerData data, _) => data.name,
                      yValueMapper: (WorkerData data, _) => data.tolerance/data.jobs,
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
    if(num == 6){
      if(!_barWorkerPerProduct.isEmpty){
        return SafeArea(
            child: Column(
              children: [
                SfCartesianChart(
                    title: ChartTitle(text: 'Avg job duration [m]',textStyle: TextStyle(color: Colors.blueAccent,fontSize: 20,)),
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries>[
                      // Renders bar chart
                      BarSeries<WorkerData, String>(
                        //sortingOrder: SortingOrder.descending,
                        dataSource: _barWorkerPerProduct,
                        xValueMapper: (WorkerData data, _) => data.name,
                        yValueMapper: (WorkerData data, _) => data.workTime/(data.jobs*60),
                      )
                    ]
                ),
                SfCartesianChart(
                    title: ChartTitle(text: '  Avg Tolerance absolute [%]',textStyle: TextStyle(color: Colors.blueAccent,fontSize: 20,)),
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries>[
                      // Renders bar chart
                      BarSeries<WorkerData, String>(
                        //sortingOrder: SortingOrder.descending,
                        dataSource: _barWorkerPerProduct,
                        xValueMapper: (WorkerData data, _) => data.name,
                        yValueMapper: (WorkerData data, _) => data.totalTime/(data.jobs),
                      )
                    ]
                ),
              ],
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
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    updateWorkers(_currentProduct.name);

                  });
                },
              ),

            ],
          );
        });
  }

  getCsv() async {

    var rows = DatabaseService().getRawData(_fromDate,_toDate);

    showDialog(context: context, barrierDismissible: false,builder: (context) {
      return Container(
        child: SpinKitChasingDots(

          color: Colors.blue,
          size: 50.0,
        ),
      );
    });
    List<List<dynamic>> list = <List<dynamic>>[];
    await rows.then((value) {list = value; });
    Navigator.pop(context);
    File f = await _localFile;

    String csv = const ListToCsvConverter().convert(list);
    f.writeAsString(csv);
  }

  sendMailAndAttachment() async {
    final Email email = Email(
      body:
          'there is the raw data from $_fromDate to $_toDate',
      subject: 'Aid scale statistics',
      recipients: ['shmuelk@migdalor.org.il'],
      isHTML: true,
      attachmentPaths: [filePath],
    );

    await FlutterEmailSender.send(email);
  }

  String filePath="";

  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.absolute.path;
  }


  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/data.csv';
    return File('$path/data.csv').create();
  }

}
class WorkerData{
  String name;
  int jobs;
  double workTime;
  double startTime;
  double endTime;
  double totalTime;
  double workDays;
  double tolerance;
  WorkerData(this.name,this.jobs,this.workTime,this.startTime,
      this.endTime,this.totalTime,this.workDays,this.tolerance);
}
class PrimitiveWrapper {
  double value;
  PrimitiveWrapper(this.value);
}



