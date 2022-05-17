import 'package:flutter/material.dart';
import 'package:medtrack/screens/addInv.dart';
import 'package:medtrack/utils/dataBasehelper.dart';
import 'package:medtrack/utils/invModel.dart';

class InvCard extends StatelessWidget {
  final InvModel item;

  const InvCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddInv(arg: item),
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
            height: 80,
            child: Row(
              children: [
                const Icon(
                  Icons.circle_outlined,
                ),
                const SizedBox(width: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        item.name.length > 10
                            ? "${item.name.substring(0, 9)}..."
                            : item.name,
                        textScaleFactor: 1.2,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.purple[800],
                        )),
                    const SizedBox(height: 8),
                    Text(item.doseAvailable.toString() +
                        " does left in inventory"),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () {
                            DataBaseHelper.instance.delete(item.id, 1);
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
            )),
      ),
    );
  }
}
