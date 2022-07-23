import 'package:flutter/material.dart';
import 'package:go_fit_now/widgets/appbarwidget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class testdatepicker extends StatefulWidget {
  const testdatepicker({Key? key}) : super(key: key);

  @override
  _testdatepickerState createState() => _testdatepickerState();
}

class _testdatepickerState extends State<testdatepicker> {
  String _dateCount="";
  String _range="";
  String difference="";
  final birthday = DateTime(1967, 10, 12);
  final date2 = DateTime.now();



  otpDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Select Date'),
            actions: [ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Submit"))],
            content: Container(
              height: MediaQuery.of(context).size.height/2.5,
                color: Colors.white,
                child:Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: SfDateRangePicker(
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.range,
                        initialDisplayDate: DateTime.now(),
                        minDate: DateTime.now(),
                        maxDate: DateTime.now().add(const Duration(days: 6)),

                        // initialSelectedRange: PickerDateRange(
                        //     DateTime.now().subtract(const Duration(days: 4)),
                        //     DateTime.now().add(const Duration(days: 3))),

                      ),
                    )
                  ],
                )
            ),
            contentPadding: EdgeInsets.all(10.0),


          );
        });
  }





  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {

      if (args.value is PickerDateRange) {


          // difference = "${args.value.endDate ?? args.value.startDate
          //     .difference(args.value.startDate)
          //     .inDays}";
          // // Duration difference = args.value.startDate.difference(args.value.startDate);
          // print("fffffffffffffffffffff${args.value.endDate ?? args.value.startDate.difference(DateFormat('dd/MM/yyyy').format(args.value.startDate)).inDays}");

        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();

      } else if (args.value is DateTime) {
      } else if (args.value is List<DateTime>) {

        _dateCount = args.value.length.toString();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarwidget(),
      body: Container(
        color: Colors.white,
        child:Column(
          children: [
            Text("date range is $_range and date count is $_dateCount"),
            // Text("$difference"),
            ElevatedButton(
              onPressed: (){otpDialogBox(context);},
              child: Text("show date picker"),
            ),
          ],
        )
      ),
    );
  }
}
