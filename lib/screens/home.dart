// import 'package:flutter/cupertino.dart';
// ignore_for_file: unrelated_type_equality_checks, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:medtrack/screens/addInv.dart';
import 'package:medtrack/screens/addMed.dart';
import 'package:medtrack/utils/dataBasehelper.dart';
import 'package:medtrack/utils/medModel.dart';
import 'package:medtrack/widgets/currDate.dart';
import 'package:medtrack/widgets/invCard.dart';
import 'package:medtrack/utils/invModel.dart';
import 'package:medtrack/utils/todayData.dart';
import '../widgets/medCard.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

@override
class _HomeState extends State<Home> {
  @override
  void initState() {
    invLoadDB();
    medLoadDB();
    super.initState();
  }

  int bottomNavIndex = 1;
  // final invItem = [];
  List<MedModel> medItem = [];
  Map<int, String> id_name = {};
  List todayItem = [];
  // InvModel item = InvModel();
  // List<Map<String, dynamic>> invDB = [];
  // List<Map<String, dynamic>> medDB = [];

  Future<List<InvModel>> invLoadDB() async {
    List<Map<String, dynamic>> invDB =
        await DataBaseHelper.instance.querryAll([], 1);

    // for (int ind = 0; ind < invDB.length; ind++) {
    //   id_name[invDB[ind]["id"]] = invDB[ind][DataBaseHelper.inv_Name];
    // }
    return List.generate(invDB.length, (index) {
      return InvModel(
        id: invDB[index]["id"],
        name: invDB[index][DataBaseHelper.inv_Name],
        doseAvailable: invDB[index][DataBaseHelper.inv_DoseAvailable],
        type: invDB[index][DataBaseHelper.inv_Type],
        remind: invDB[index][DataBaseHelper.inv_Remind],
      );
    });
  }

  Future<List<MedModel>> medLoadDB() async {
    List<Map<String, dynamic>> invDB =
        await DataBaseHelper.instance.querryAll([], 1);

    for (int ind = 0; ind < invDB.length; ind++) {
      id_name[invDB[ind]["id"]] = invDB[ind][DataBaseHelper.inv_Name];
    }
    List<Map<String, dynamic>> medDB =
        await DataBaseHelper.instance.querryAll([], 0);
    medItem = List.generate(medDB.length, (index) {
      return MedModel(
        id: medDB[index]["id"],
        startDateD: medDB[index][DataBaseHelper.med_StartDateD],
        startDateM: medDB[index][DataBaseHelper.med_StartDateM],
        startDateY: medDB[index][DataBaseHelper.med_StartDateY],
        endDateD: medDB[index][DataBaseHelper.med_EndDateD],
        endDateM: medDB[index][DataBaseHelper.med_EndDateM],
        endDateY: medDB[index][DataBaseHelper.med_EndDateY],
        freqDay: medDB[index][DataBaseHelper.med_FreqDay],
        freqTime: medDB[index][DataBaseHelper.med_FreqTime],
        unit: medDB[index][DataBaseHelper.med_Unit],
        instructions: medDB[index][DataBaseHelper.med_Instructions],
      );
    });
    await todayData();
    return medItem;
  }

  List today_med_id = [];
  todayData() {
    today_med_id = [];
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);

    for (int i = 0; i < medItem.length; i++) {
      DateTime st_date = DateTime(
          medItem[i].startDateY, medItem[i].startDateM, medItem[i].startDateD);
      DateTime ed_date = DateTime(
          medItem[i].endDateY, medItem[i].endDateM, medItem[i].endDateD);
      if ((today.isAfter(st_date) || today.isAtSameMomentAs(st_date)) &&
          (today.isBefore(ed_date) || today.isAtSameMomentAs(ed_date))) {
        double diff = (today.difference(st_date).inHours / 24);
        //   //  % medItem[i].freqDay);
        double med_today = medItem[i].freqDay == 0
            ? 0
            : diff < medItem[i].freqDay
                ? 0
                : diff % medItem[i].freqDay;

        if (med_today == 0) {
          today_med_id.add(medItem[i].id);
        }
      }
    }
    // setState(() {});
  }

  // Future<List<InvModel>> invLoadDB() async {
  //   List<Map<String, dynamic>> invDB =
  //       await DataBaseHelper.instance.querryAll([], 1);

  //   for (int ind = 0; ind < invDB.length; ind++) {
  //     id_name[invDB[ind]["id"]] = invDB[ind][DataBaseHelper.inv_Name];
  //   }

  //   return List.generate(invDB.length, (index) {
  //     return InvModel(
  //       id: invDB[index]["id"],
  //       name: invDB[index][DataBaseHelper.inv_Name],
  //       doseAvailable: invDB[index][DataBaseHelper.inv_DoseAvailable],
  //       type: invDB[index][DataBaseHelper.inv_Type],
  //       remind: invDB[index][DataBaseHelper.inv_Remind],
  //     );
  //   });
  // }

  // Future<List<MedModel>> medLoadDB() async {
  //   List<Map<String, dynamic>> medDB =
  //       await DataBaseHelper.instance.querryAll([], 0);

  //   medItem = List.generate(medDB.length, (index) {
  //     return MedModel(
  //       id: medDB[index]["id"],
  //       startDateD: medDB[index][DataBaseHelper.med_StartDateD],
  //       startDateM: medDB[index][DataBaseHelper.med_StartDateM],
  //       startDateY: medDB[index][DataBaseHelper.med_StartDateY],
  //       endDateD: medDB[index][DataBaseHelper.med_EndDateD],
  //       endDateM: medDB[index][DataBaseHelper.med_EndDateM],
  //       endDateY: medDB[index][DataBaseHelper.med_EndDateY],
  //       freqDay: medDB[index][DataBaseHelper.med_FreqDay],
  //       freqTime: medDB[index][DataBaseHelper.med_FreqTime],
  //       unit: medDB[index][DataBaseHelper.med_Unit],
  //       instructions: medDB[index][DataBaseHelper.med_Instructions],
  //     );
  //   });

  //   return medItem;
  // }

  Future<void> onRefresh() async {
    setState(() {});
    return Future.delayed(const Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.medical_services_outlined),
          title: const Text("Medicine Tracker"),
          elevation: 2,
          actions: [
            PopupMenuButton(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                onSelected: (value) {},
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text("Settings"),
                        value: 1,
                      ),
                      const PopupMenuItem(
                        child: Text("Share App"),
                        value: 2,
                      ),
                    ]),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () {
            // return Future.delayed(  const Duration(seconds: 0));
            return onRefresh();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: bottomNavIndex == 0
                ?

                //here
                FutureBuilder(
                    future: medLoadDB(),
                    builder: (BuildContext context,
                            AsyncSnapshot<List> snapshot) =>
                        snapshot.hasData
                            ? snapshot.data!.isNotEmpty
                                ? ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return MedCard(
                                        item: snapshot.data![index],
                                        item_Id_Name: id_name,
                                      );
                                    },
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "No medicines are scheduled",
                                          style: TextStyle(
                                              color: Colors.purple,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                            "Click on add button to Schedule medicine ",
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  )
                            : const Center(child: CircularProgressIndicator()))

                // medItem.isEmpty
                // ? Center(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: const [
                //         Text(
                //           "No medicines are scheduled",
                //           style: TextStyle(
                //               color: Colors.purple,
                //               fontSize: 20,
                //               fontWeight: FontWeight.bold),
                //         ),
                //         SizedBox(height: 10),
                //         Text("Click on add button to Schedule medicine ",
                //             style: TextStyle(
                //                 color: Colors.purple,
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.bold))
                //       ],
                //     ),
                //   )
                //     : ListView.builder(
                //         itemCount: medItem.length,
                //         itemBuilder: (BuildContext context, index) {
                //           return MedCard(item: medItem[index]);
                //         },
                //       )
                : bottomNavIndex == 1
                    ? Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.purple, Colors.white]),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: CurrDate()),
                            Expanded(
                                flex: 10,
                                child: Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        )),
                                    child: today_med_id.isEmpty
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: const [
                                              Text(
                                                "WOW no medicines for today",
                                                style: TextStyle(
                                                    color: Colors.purple,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 10),
                                              Text("Doing great !!!",
                                                  style: TextStyle(
                                                      color: Colors.purple,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: TodayData(
                                                today_id: today_med_id),
                                          )
                                    // ListView.builder(
                                    //     itemCount: todayItem.length,
                                    //     itemBuilder:
                                    //         (BuildContext context, index) {
                                    //       return const TodayCard();
                                    //     },
                                    //   ),
                                    ))
                          ],
                        ),
                      )
                    : FutureBuilder(
                        future: invLoadDB(),
                        builder: (BuildContext context,
                                AsyncSnapshot<List> snapshot) =>
                            snapshot.hasData
                                ? snapshot.data!.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return InvCard(
                                              item: snapshot.data![index]);
                                        },
                                      )
                                    : Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Text(
                                              "Nothing there in inventory",
                                              style: TextStyle(
                                                  color: Colors.purple,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                                "Click on add button to add items",
                                                style: TextStyle(
                                                    color: Colors.purple,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                      )
                                : const Center(
                                    child: CircularProgressIndicator())),
          ),
        ),
        floatingActionButton: bottomNavIndex == 0 || bottomNavIndex == 2
            ? FloatingActionButton(
                backgroundColor: Colors.purpleAccent[800],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => bottomNavIndex == 0
                          ? AddMed(arg: MedModel(), item_Id_Name: id_name)
                          : AddInv(arg: InvModel()),
                    ),
                  ).then((_) => setState(() {}));
                },
                child: const Icon(Icons.add),
              )
            : const SizedBox(),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.grey[200],
          selectedItemColor: Colors.purple[800],
          unselectedItemColor: Colors.grey[500],
          currentIndex: bottomNavIndex,
          onTap: (value) {
            setState(() {
              bottomNavIndex = value;
              // BY pass
              if (value == 1) {
                medLoadDB();
              }
              // ( need to check )
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.tablet), label: "Treatment"),
            BottomNavigationBarItem(
                icon: Icon(Icons.checklist), label: "Today"),
            BottomNavigationBarItem(
                icon: Icon(Icons.medical_services_outlined), label: "Inventory")
          ],
        ));
  }
}
