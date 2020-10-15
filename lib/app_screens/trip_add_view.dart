import 'package:flutter/material.dart';
import 'package:planyourtrip/models/trip.dart';

class AddTripView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddTripViewState();
  }
}

class _AddTripViewState extends State<AddTripView> {
  DateTimeRange selectedDate =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  String destination;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return addTripToListView(context);
  }

  //Add new element to trip list
  Widget addTripToListView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Plan Your Next Trip", style: TextStyle(color: Colors.white)),
      ),
      body: Builder(
        builder: (BuildContext context){
          return Container(
            margin: EdgeInsets.all(20.0),
            height: double.maxFinite,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tell me your next trip destination',
                  ),
                  onChanged: (String userInput) {
                    destination = userInput;
                  },
                ),
                FlatButton.icon(
                  label: Icon(
                    Icons.calendar_today,
                    color: Colors.green,
                  ),
                  icon: Text(
                    "${selectedDate.start.toLocal()}".split(' ')[0] +
                        " - " +
                        "${selectedDate.end.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 15.0, color: Colors.green),
                  ),
                  onPressed: () {
                    _selectDate(context);
                  }, // Refer step 3
                ),
                Expanded(
                    child: Align(
//              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                      alignment: FractionalOffset.bottomCenter,
                      child: FlatButton(
//                  padding: EdgeInsets.all(0.0),
                          minWidth: MediaQuery.of(context).size.width,
                          color: Colors.lightGreen,
                          child: Text("Add Destination"),
                          onPressed: () {
                            if (destination == null) {
                              _showSnackBar(context, "Please name trip destination");
                            } else {
                              Navigator.pop(
                                  context, Trip.set(destination, selectedDate));
                            }
                          }),
                    )),
              ],
            ),
          );
        },
      )
    );
  }

  _selectDate(BuildContext context) async {
    final DateTimeRange picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
