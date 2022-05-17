import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medtrack/utils/dataBaseHelper.dart';
import 'package:medtrack/utils/medModel.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sqflite/sqflite.dart';

class AddMed extends StatefulWidget {
  final MedModel arg;
  final Map<int, String> item_Id_Name;
  const AddMed({Key? key, required this.arg, required this.item_Id_Name})
      : super(key: key);

  @override
  State<AddMed> createState() => _AddMedState();
}

class _AddMedState extends State<AddMed> {
  @override
  initState() {
    getSearchData();

    item = widget.arg;
    if (item.id != 4004) {
      selectedCurrID = item.id;
      seachTextController.text = widget.item_Id_Name[item.id] ?? "";
      updating = true;
      selectedDate = [
        DateTime(item.startDateY, item.startDateM, item.startDateD),
        DateTime(item.endDateY, item.endDateM, item.endDateD)
      ];
      freqDropDownValue = item.freqDay < 2 ? item.freqDay : 2;
      afterXDays = item.freqDay > 2 ? item.freqDay : 2;
      unitValue = item.unit;
      instructionController.text = item.instructions;
      medIdList.remove(item.id);

      selectedTime = [];
      getTimeData();
    }

    super.initState();
  }

  getTimeData() async {
    List<Map<String, dynamic>> timeData =
        await DataBaseHelper.instance.querryID(item.id, 2);

    print(timeData);
    for (int ind = 0; ind < timeData.length; ind++) {
      selectedTime.add(TimeOfDay(
          hour: timeData[ind][DataBaseHelper.doesTime_Hour],
          minute: timeData[ind][DataBaseHelper.doesTime_Min]));
    }

    setState(() {});
  }

  bool updating = false;
  MedModel item = MedModel();

  Future<void> selectDateFun(index) async {
    DateTime? picked = await showDatePicker(
        firstDate: DateTime.now(),
        context: context,
        initialDate: selectedDate[index],
        lastDate: DateTime(2100));

    if (picked != null) {
      // && picked != selectedDate[index]
      setState(() {
        selectedDate[index] = picked;
      });
    }
  }

  List<DateTime> picked = [];
  late List<DateTime> selectedDate = [DateTime.now(), DateTime.now()];

  search(String value) {
    setState(() {
      searching = true;
      selectedCurrID = 4004;
      value = value.trim();
      currSearch = [];

      for (var i = 0; i < searchData.length; i++) {
        if (searchData[i][1].toLowerCase().contains(value.toLowerCase())) {
          currSearch.add([searchData[i][0], searchData[i][1]]);
          // .where(
          //     (string) => string.toLowerCase().contains(value.toLowerCase()))
          // .toList();
        }
      }

      if (currSearch.isEmpty && value != "") {
        currSearch.add([4004, wrongSearch]);
      }
    });
  }

  getSearchData() async {
    List<Map<String, dynamic>> data = await DataBaseHelper.instance
        .querryAll(["id", DataBaseHelper.inv_Name], 1);

    searchData = List.generate(data.length, (index) {
      return [data[index]["id"], data[index][DataBaseHelper.inv_Name]];
    });

    data = await DataBaseHelper.instance.querryAll(["id"], 0);

    medIdList = List.generate(data.length, (index) {
      return data[index]["id"];
    });
    if (updating) {
      medIdList.remove(item.id);
    }
  }

  List<int> medIdList = [];
  List<List<dynamic>> currSearch = [];
  List<List<dynamic>> searchData = [];
  bool searching = true;
  int selectedCurrID = 4004;

  save() async {
    if (selectedDate[1].isBefore(selectedDate[0])) {
      Fluttertoast.showToast(
          msg: "Date Error Select Date carefully",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          fontSize: 16.0);
      return;
    }
    if (medIdList.contains(selectedCurrID)) {
      Fluttertoast.showToast(
          msg: "This medicine alredy added",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          fontSize: 16.0);
      return;
    }
    if (selectedCurrID == 4004) {
      Fluttertoast.showToast(
          msg: "Select Medicine",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          fontSize: 16.0);
      return;
    }
    if (updating) {
      await DataBaseHelper.instance.update({
        "id": selectedCurrID,
        DataBaseHelper.med_StartDateD: selectedDate[0].day,
        DataBaseHelper.med_StartDateM: selectedDate[0].month,
        DataBaseHelper.med_StartDateY: selectedDate[0].year,
        DataBaseHelper.med_EndDateD: selectedDate[1].day,
        DataBaseHelper.med_EndDateM: selectedDate[1].month,
        DataBaseHelper.med_EndDateY: selectedDate[1].year,
        DataBaseHelper.med_FreqDay:
            freqDropDownValue == 2 ? afterXDays : freqDropDownValue,
        DataBaseHelper.med_FreqTime: selectedTime.length,
        DataBaseHelper.med_Unit: unitValue,
        DataBaseHelper.med_Instructions: instructionController.text,
      }, 0);

      if (selectedTime.isEmpty) {
        selectedTime.add(const TimeOfDay(hour: 9, minute: 0));
      }

      await DataBaseHelper.instance.delete(item.id, 2);

      for (int ind = 0; ind < selectedTime.length; ind++) {
        await DataBaseHelper.instance.insert({
          "id": selectedCurrID,
          DataBaseHelper.doesTime_Hour: selectedTime[ind].hour,
          DataBaseHelper.doesTime_Min: selectedTime[ind].minute,
        }, 2);
      }
    } else {
      await DataBaseHelper.instance.insert({
        "id": selectedCurrID,
        DataBaseHelper.med_StartDateD: selectedDate[0].day,
        DataBaseHelper.med_StartDateM: selectedDate[0].month,
        DataBaseHelper.med_StartDateY: selectedDate[0].year,
        DataBaseHelper.med_EndDateD: selectedDate[1].day,
        DataBaseHelper.med_EndDateM: selectedDate[1].month,
        DataBaseHelper.med_EndDateY: selectedDate[1].year,
        DataBaseHelper.med_FreqDay:
            freqDropDownValue == 2 ? afterXDays : freqDropDownValue,
        DataBaseHelper.med_FreqTime: selectedTime.length,
        DataBaseHelper.med_Unit: unitValue,
        DataBaseHelper.med_Instructions: instructionController.text,
      }, 0);

      for (int ind = 0; ind < selectedTime.length; ind++) {
        await DataBaseHelper.instance.insert({
          "id": selectedCurrID,
          DataBaseHelper.doesTime_Hour: selectedTime[ind].hour,
          DataBaseHelper.doesTime_Min: selectedTime[ind].minute,
        }, 2);
      }
    }
    Navigator.pop(context);
  }

  addTime(int index, bool adding) async {
    if (adding) {
      // initTime =  TimeOfDay(hour: initTime.hour, minute: initTime.);
    }

    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: adding ? TimeOfDay(hour: 8, minute: 0) : selectedTime[index],
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (time != null && !selectedTime.contains(time)) {
      setState(() {
        if (adding) {
          selectedTime.add(time);
          // noOfTimes += 1;
        } else {
          selectedTime[index] = time;
        }
      });
    }
  }

  List<TimeOfDay> selectedTime = [const TimeOfDay(hour: 8, minute: 0)];
  // int noOfTimes = 1;

  TextEditingController seachTextController = TextEditingController();
  String wrongSearch = "no such medicine in inventory";

  List<String> freqDropDownItem = [
    "Daily",
    "After every 1 day",
    "After every x days"
  ];
  int freqDropDownValue = 0;
  int afterXDays = 2;

  List<String> unitItem = [
    "0.25",
    "0.50",
    "0.75",
    "1.00",
    "1.25",
    "1.50",
    "1.75",
    "2.00"
  ];
  int unitValue = 3;
  final instructionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Medicine"),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back))),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.search_outlined),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                      controller: seachTextController,
                      decoration: const InputDecoration(
                        labelText: "Enter Medicine Name",
                        border: UnderlineInputBorder(),
                      ),
                      onChanged: (value) {
                        search(value);
                      }),
                ),
              ],
            ),
            searching == false || seachTextController.text.isEmpty
                ? const SizedBox()
                : Column(
                    children: [
                      const SizedBox(height: 5),
                      Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 223, 223, 223),
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          height: currSearch.length * 60,
                          child: ListView.builder(
                            itemCount: currSearch.length,
                            itemBuilder: (BuildContext context, index) {
                              return ListTile(
                                onTap: () => currSearch[index][1] == wrongSearch
                                    ? {}
                                    : setState(() {
                                        seachTextController.text =
                                            currSearch[index][1];
                                        selectedCurrID = currSearch[index][0];
                                        searching = false;
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      }),
                                title: Text(currSearch[index][1]),
                              );
                            },
                          )),
                    ],
                  ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Expanded(
                    flex: 4, child: Text("Start date", textScaleFactor: 1.2)),
                Flexible(
                    flex: 5,
                    child: InkWell(
                      onTap: () {
                        selectDateFun(0);
                      },
                      child: Text(
                          ": ${selectedDate[0].day}-${selectedDate[0].month}-${selectedDate[0].year}",
                          textScaleFactor: 1.2),
                    )),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Expanded(
                    flex: 4, child: Text("End date", textScaleFactor: 1.2)),
                Flexible(
                    flex: 5,
                    child: InkWell(
                      onTap: () {
                        selectDateFun(1);
                      },
                      child: Text(
                          ": ${selectedDate[1].day}-${selectedDate[1].month}-${selectedDate[1].year}",
                          textScaleFactor: 1.2),
                    )),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                    flex: 4, child: Text("Frequency", textScaleFactor: 1.2)),
                Flexible(
                    flex: 5,
                    child: DropdownButton(
                        underline: const Text(""),
                        focusColor: Colors.white,
                        value: freqDropDownItem[freqDropDownValue],
                        items: freqDropDownItem.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items,
                              // textScaleFactor: 1.1,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            freqDropDownValue =
                                freqDropDownItem.indexOf(newValue!);
                          });
                        }))
              ],
            ),
            freqDropDownValue == 2
                ? Row(
                    children: [
                      const Expanded(
                          flex: 4,
                          child:
                              Text("After every x days", textScaleFactor: 1.2)),
                      Expanded(
                        flex: 5,
                        child: NumberPicker(
                          infiniteLoop: true,
                          axis: Axis.horizontal,
                          itemWidth: 60,
                          value: afterXDays,
                          minValue: 2,
                          maxValue: 10,
                          onChanged: (value) =>
                              setState(() => afterXDays = value),
                        ),
                      )
                    ],
                  )
                : const SizedBox(),
            const SizedBox(height: 15),
            Row(
              children: [
                const Expanded(
                    flex: 4,
                    child: Text("Notification Time", textScaleFactor: 1.2)),
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: selectedTime.length * 35.0, // noOfTimes * 30,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: selectedTime.length, // noOfTimes,
                      itemBuilder: (BuildContext context, index) {
                        return Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: InkWell(
                                  onTap: () {
                                    addTime(index, false);
                                  },
                                  child: Text(
                                    selectedTime[index]
                                        .format(context)
                                        .toString(),
                                    textScaleFactor: 1.2,
                                  ),
                                ),
                              ),
                              // const SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: InkWell(
                                    onTap: () {
                                      if (selectedTime.length > 1) {
                                        // noOfTimes -= 1;
                                        selectedTime.removeAt(index);
                                        setState(() {});
                                      }
                                    },
                                    child: const Icon(Icons.delete_outline)),
                              ),
                              // const SizedBox(width: 20),
                              index == selectedTime.length - 1 // noOfTimes - 1
                                  ? Expanded(
                                      flex: 4,
                                      child: InkWell(
                                        onTap: () {
                                          addTime(index, true);
                                        },
                                        child: const Text("Add More",
                                            textScaleFactor: 1.2,
                                            style: TextStyle(
                                                color: Colors.purple)),
                                      ),
                                    )

                                  // Icon(
                                  //     Icons.add,
                                  //     size: 25,
                                  //     color: Colors.purple,
                                  //   )

                                  // TextButton(
                                  //     style: TextButton.styleFrom(
                                  //       backgroundColor: Colors.purple,
                                  //       primary: Colors.white,
                                  //     ),
                                  //     onPressed: () {
                                  //       addTime(index, true);
                                  //     },
                                  //     child: const Icon(Icons.add),
                                  //   )
                                  : const Expanded(
                                      flex: 4,
                                      child: SizedBox(),
                                    )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Expanded(
                    flex: 4,
                    child: Text("Medicine unit", textScaleFactor: 1.2)),
                Flexible(
                    flex: 5,
                    child: DropdownButton(
                        underline: const Text(""),
                        focusColor: Colors.white,
                        value: unitItem[unitValue],
                        items: unitItem.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            unitValue = unitItem.indexOf(newValue!);
                          });
                        }))
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Expanded(
                    flex: 4, child: Text("Instructions", textScaleFactor: 1.2)),
                Expanded(
                    flex: 5,
                    child: TextFormField(
                      controller: instructionController,
                      maxLines: 5,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                    ))
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 40,
                  width: 100,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.purple)),
                      onPressed: save,
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 30)
          ]),
        ),
      ),
    );
  }
}
