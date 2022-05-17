import 'package:flutter/material.dart';
import 'package:medtrack/utils/dataBaseHelper.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medtrack/utils/invModel.dart';

class AddInv extends StatefulWidget {
  final InvModel arg;
  const AddInv({Key? key, required this.arg}) : super(key: key);

  @override
  State<AddInv> createState() => _AddInvState();
}

class _AddInvState extends State<AddInv> {
  @override
  void initState() {
    getInvList();
    item = widget.arg;

    if (item.id != 4004) {}

    doseAvailController = item.id == 4004
        ? TextEditingController()
        : TextEditingController(text: item.doseAvailable.toString());

    nameFieldController = item.id == 4004
        ? TextEditingController()
        : TextEditingController(text: item.name);
    notifyToggleValue = item.id == 4004 ? 1 : item.remind;

    super.initState();
  }

  getInvList() async {
    List<Map<String, dynamic>> data = await DataBaseHelper.instance
        .querryAll([DataBaseHelper.inv_Name, "id"], 1);
    invList = List.generate(data.length, (index) {
      return data[index][DataBaseHelper.inv_Name];
    });
  }

  List<String> invList = [];
  InvModel item = InvModel();

  int notifyToggleValue = 1;
  var nameFieldController; // = TextEditingController();
  // TextEditingController(text: item.name);
  var doseAvailController; // = TextEditingController();
  // TextEditingController(text: item.doseAvailable.toString());

  void disposeController() {
    nameFieldController.dispose();
    doseAvailController.dispose();
    super.dispose();
  }

  notifyToggel(bool value) {
    if (notifyToggleValue == 1) {
      setState(() {
        notifyToggleValue = 0;
      });
    } else {
      setState(() {
        notifyToggleValue = 1;
      });
    }
  }

  save() async {
    nameFieldController.text = nameFieldController.text.trim();
    doseAvailController.text = doseAvailController.text.trim();

    if (doseAvailController.text.length > 10) {
      {
        Fluttertoast.showToast(
            msg: "Available does can't be greater than 10 digits ",
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey,
            fontSize: 16.0);
      }
      return;
    }

    if (nameFieldController.text.isNotEmpty &&
        doseAvailController.text.isNotEmpty) {
      if (invList.contains(nameFieldController.text)) {
        Fluttertoast.showToast(
            msg: "Medicine already there in Inventory",
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey,
            fontSize: 16.0);
      } else {
        item.id != 4004
            ? await DataBaseHelper.instance.update({
                "id": item.id,
                DataBaseHelper.inv_Name: nameFieldController.text,
                DataBaseHelper.inv_Remind: notifyToggleValue,
                DataBaseHelper.inv_DoseAvailable: doseAvailController.text,
                DataBaseHelper.inv_Type: 4,
              }, 1)
            : await DataBaseHelper.instance.insert({
                DataBaseHelper.inv_Name: nameFieldController.text,
                DataBaseHelper.inv_Remind: notifyToggleValue,
                DataBaseHelper.inv_DoseAvailable: doseAvailController.text,
                DataBaseHelper.inv_Type: 4,
              }, 1);
        // disposeController();
        Navigator.pop(context);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Enter Required Fiels",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Inventory"),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back))),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
                controller: nameFieldController,
                decoration: const InputDecoration(
                    labelText: "Enter Medicine Name",
                    border: UnderlineInputBorder())),
            const SizedBox(height: 5),
            TextFormField(
                controller: doseAvailController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Total Dose available",
                    border: UnderlineInputBorder())),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  "Notify if less",
                  textScaleFactor: 1.2,
                ),
                Switch(
                    value: notifyToggleValue == 1 ? true : false,
                    onChanged: notifyToggel)
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
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 157, 71, 173))),
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
            )
          ],
        ),
      ),
    );
  }
}
