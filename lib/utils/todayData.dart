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
  // initState()  {
  //    loadDB();
  // }

  bool today_filter_0 = false;
  List today_data = [];

  Future<List> loadDB() async {
    today_data = [];
    TimeOfDay current_Time = TimeOfDay.now();
    for (int i = 0; i < widget.today_id.length; i++) {
      List<Map<String, dynamic>> nameData =
          await DataBaseHelper.instance.querryID(widget.today_id[i], 1);
      List<Map<String, dynamic>> timeData =
          await DataBaseHelper.instance.querryID(widget.today_id[i], 2);

      for (int j = 0; j < timeData.length; j++) {
        if (!(current_Time.hour > timeData[j][DataBaseHelper.doesTime_Hour] ||
            current_Time.hour == timeData[j][DataBaseHelper.doesTime_Hour] &&
                current_Time.minute >
                    timeData[j][DataBaseHelper.doesTime_Min])) {
          today_data.add([
            nameData[0][DataBaseHelper.inv_Name],
            TimeOfDay(
                hour: timeData[j][DataBaseHelper.doesTime_Hour],
                minute: timeData[j][DataBaseHelper.doesTime_Min])
          ]);
        }
      }
    }
    if (today_data.isEmpty) {
      today_filter_0 = true;
    }
    return today_data;
  }

  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: loadDB(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) =>
            snapshot.hasData
                ? snapshot.data!.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, index) {
                          return todayCard(today_data: snapshot.data![index]);
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "WOW doing great !!!",
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "all medicines for today completed",
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                : const Center(child: CircularProgressIndicator()),
      ),

      // ListView.builder(
      //   itemCount: today_data.length,
      //   itemBuilder: (BuildContext context, index) {
      //     // return Text(today_data[index][0]);
      //     return todayCard(today_data: today_data[index]);
      //   },
      // ),
    );
  }
}
