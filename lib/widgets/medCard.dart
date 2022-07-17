// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:medtrack/screens/addMed.dart';
import 'package:medtrack/utils/medModel.dart';

import 'package:medtrack/utils/dataBaseHelper.dart';
import 'package:medtrack/utils/todayData.dart';

class MedCard extends StatelessWidget {
  final MedModel item;
  final Map<int, String> item_Id_Name;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  int totalDays = 0;
  int completedDays = 0;
  String itemName = "";

  MedCard({Key? key, required this.item, required this.item_Id_Name})
      : super(key: key) {
    startDate = DateTime(item.startDateY, item.startDateM, item.startDateD);
    endDate = DateTime(item.endDateY, item.endDateM, item.endDateD);

    totalDays = endDate.difference(startDate).inDays + 1;
    completedDays = DateTime.now().difference(startDate).inDays + 1;
    itemName = item_Id_Name[item.id] ?? "Name E";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddMed(arg: item, item_Id_Name: item_Id_Name),
                  ))
              // .then((_) => setState(() {}))
              ;
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          height: 100,
          child: Row(
            children: [
              SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    value: (completedDays / totalDays),
                    strokeWidth: 7.0,
                    backgroundColor: const Color.fromARGB(255, 237, 142, 254),
                    color: const Color.fromARGB(255, 193, 64, 216),
                  )),
              const SizedBox(width: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      itemName.length > 10
                          ? "${itemName.substring(0, 9)}..."
                          : item_Id_Name[item.id] ?? "Name Error",
                      textScaleFactor: 1.2,
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.purple[800],
                      )),
                  const SizedBox(height: 5),
                  Text("No of times in a day : " + item.freqTime.toString()),
                  const SizedBox(height: 5),
                  Text(
                      "From ${item.startDateD}-${item.startDateM}-${item.startDateY} to ${item.endDateD}-${item.endDateM}-${item.endDateY}"),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          DataBaseHelper.instance.delete(item.id, 2);
                          DataBaseHelper.instance.delete(item.id, 0);
                        },
                        child: const Icon(
                          Icons.delete_forever_outlined,
                          size: 30,
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
