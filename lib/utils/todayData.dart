import 'package:flutter/material.dart';
import 'package:medtrack/utils/dataBaseHelper.dart';
import 'package:medtrack/widgets/todayCard.dart';

class TodayData extends StatefulWidget {
  final List today_id;
  TodayData({Key? key, required this.today_id}) : super(key: key);

  @override
  State<TodayData> createState() => _TodayDataState();
}

class _TodayDataState extends State<TodayData> {
  @override
  initState() {
    loadDB();
  }

  List today_data = [];

  loadDB() async {
    today_data = [];
    for (int i = 0; i < widget.today_id.length; i++) {
      List<Map<String, dynamic>> nameData =
          await DataBaseHelper.instance.querryID(widget.today_id[i], 1);
      List<Map<String, dynamic>> timeData =
          await DataBaseHelper.instance.querryID(widget.today_id[i], 2);

      for (int j = 0; j < timeData.length; j++) {
        today_data.add([
          nameData[0][DataBaseHelper.inv_Name],
          TimeOfDay(
              hour: timeData[j][DataBaseHelper.doesTime_Hour],
              minute: timeData[j][DataBaseHelper.doesTime_Min])
        ]);
      }
    }
  }

  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: today_data.length,
        itemBuilder: (BuildContext context, index) {
          // return Text(today_data[index][0]);
          return todayCard(today_data: today_data[index]);
        },
      ),
    );
  }
}
