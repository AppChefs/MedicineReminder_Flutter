import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class calender extends StatefulWidget {
  const calender({Key? key}) : super(key: key);

  @override
  State<calender> createState() => _calenderState();
}

class _calenderState extends State<calender> {
  List<DateTime> mySelectedDates = [];
  DateTime selectedCalDate = DateTime.now();
  // Map<DateTime, List> listEvents = {};

  // eventLoder(day) {
  //   return listEvents[day];
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2000, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            focusedDay: selectedCalDate,

            // eventLoader: eventLoder(selectedCalDate),

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedCalDate = selectedDay;

                if (mySelectedDates.contains(selectedCalDate)) {
                  mySelectedDates.remove(selectedCalDate);
                  // listEvents.remove(selectedCalDate);
                } else {
                  mySelectedDates.add(selectedCalDate);
                  // listEvents[selectedCalDate] = ["Event"];
                }
              });
            },
            // calendarStyle: const CalendarStyle(
            //   selectedDecoration: BoxDecoration(
            //     color: Color.fromARGB(219, 162, 255, 205),
            //     shape: BoxShape.circle,
            //   ),
            // ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: mySelectedDates.length,
              itemBuilder: (BuildContext context, index) {
                return Container(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    mySelectedDates[mySelectedDates.length - 1 - index]
                        .toString(),
                    textScaleFactor: 1.5,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
