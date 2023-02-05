import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class todayCard extends StatelessWidget {
  final today_data;
  todayCard({Key? key, required this.today_data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          height: 90,
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        today_data[0].length > 10
                            ? "${today_data[0].substring(0, 9)}..."
                            : today_data[0],
                        textScaleFactor: 1.2,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.purple[800],
                        )),
                    const SizedBox(height: 5),
                    Text(
                        "Today at : ${today_data[1].hour}:${today_data[1].minute} ")
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    children: const [
                      Icon(Icons.done_all),
                      Text("Already"),
                      Text("Taken")
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Column(
                    children: const [
                      Icon(Icons.cancel),
                      Text("Skip"),
                      Text("This")
                    ],
                  ))
            ],
          )),
    );
  }
}
