import 'package:flutter/widgets.dart';

class todayCard extends StatelessWidget {
  final today_data;
  todayCard({Key? key, required this.today_data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            Text(today_data[0]),
            Text(" at "),
            Text(today_data[1].hour.toString())
          ],
        )
      ],
    ));
  }
}
