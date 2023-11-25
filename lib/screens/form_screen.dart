import 'package:flutter/material.dart';
import 'package:flutter_test1/model/Transactions.dart';
import 'package:flutter_test1/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final titleController = TextEditingController();
  String selectedType = 'อุปกรณ์ไอที'; // ตั้งค่าเริ่มต้น
  String selectedGender = '';
  final amountController = TextEditingController();
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> types = ['อุปกรณ์ไอที', 'เสื้อผ้า', 'อาหาร', 'เครื่องใช้'];

    return Scaffold(
      appBar: AppBar(
        title: Text("แบบฟอร์มบันทึกข้อมูล"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: titleController,
              decoration: new InputDecoration(labelText: "ชื่อรายการ"),
              autofocus: true,
            ),
            DropdownButton<String>(
              value: selectedType,
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
              items: types.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile(
                  title: Text("รายจ่าย"),
                  value: "รายจ่าย",
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: Text("รายรับ"),
                  value: "รายรับ",
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: Text("อื่นๆ"),
                  value: "อื่นๆ",
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value.toString();
                    });
                  },
                ),
              ],
            ),
            TextFormField(
              controller: amountController,
              decoration: new InputDecoration(labelText: "จำนวนเงิน"),
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: textEditingController,
                maxLines: 2, // กำหนดให้ Text Area สามารถขยายความสูงได้
                decoration: InputDecoration(
                  labelText: "กรอกรายละเอียด",
                  border: OutlineInputBorder(), // กรอบของ Text Area
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                var title = titleController.text;
                var amount = amountController.text;
                var textEditing = textEditingController.text;

                // ตรวจสอบค่าที่ถูกเลือกใน Dropdown
                if (selectedType.isEmpty) {
                  // ในกรณีที่ไม่มีค่าที่ถูกเลือกใน Dropdown
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("ค่าประเภทไม่ถูกเลือก"),
                        content: Text("โปรดเลือกประเภทก่อนบันทึก"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("ปิด"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // ในกรณีที่ค่าถูกเลือกใน Dropdown และค่าเริ่มต้นไม่ว่างเปล่า
                  Transactions statement = Transactions(
                    title: title,
                    type: selectedType,
                    gender: selectedGender,
                    amount: double.parse(amount),
                    textEditing: textEditing,
                    date: DateTime.now(),
                  );

                  // Get the provider and add the transaction
                  var provider =
                      Provider.of<TransactionProvider>(context, listen: false);
                  provider.addTransaction(statement);

                  Navigator.pop(context);
                }
              },
              child: Text('เพิ่มข้อมูล'),
            )
          ],
        ),
      ),
    );
  }
}
