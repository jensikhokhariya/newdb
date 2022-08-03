import 'package:flutter/material.dart';
import 'db_s.dart';

class Data_Screen extends StatefulWidget {
  const Data_Screen({Key? key}) : super(key: key);

  @override
  State<Data_Screen> createState() => _Data_ScreenState();
}

class _Data_ScreenState extends State<Data_Screen> {
  TextEditingController txname = TextEditingController();
  TextEditingController txprname = TextEditingController();
  TextEditingController txno = TextEditingController();
  TextEditingController txstd = TextEditingController();
  List<Map<String, dynamic>> l2 = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    DBHelper dbHelper = DBHelper();
    List<Map<String, dynamic>> l1 = await dbHelper.readData();
    setState(() {
      l2 = l1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  DBHelper db = DBHelper();
                  var res =
                  await db.insert("Jensi", "8678326489", "12", "Amitbhai");
                  getData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$res"),
                    ),
                  );
                },
                child: Text("Insert"),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: l2.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text("${l2[index]['id']}"),
                        title: Text("${l2[index]['name']}"),
                        subtitle:
                        Text("${l2[index]['parentname']},${l2[index]['no']},${l2[index]['std']}"),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  txname = TextEditingController(
                                      text: l2[index]['name']);
                                  txprname = TextEditingController(
                                      text: l2[index]['parentname']);
                                  txno= TextEditingController(
                                      text: l2[index]['no']);
                                  txstd = TextEditingController(
                                      text: l2[index]['std']);
                                  updateDB(l2[index]['id']);
                                  getData();
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green.shade900,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  DBHelper().delete(l2[index]['id']);
                                  getData();
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateDB(int id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              SizedBox(
                height: 300,
                child: Column(
                  children: [
                    TextField(
                      controller: txname,
                      decoration: InputDecoration(
                        hintText: "NAME",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: txprname,
                      decoration: InputDecoration(
                        hintText: "PARENTNAME",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: txno,
                      decoration: InputDecoration(
                        hintText: "NO",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: txstd,
                      decoration: InputDecoration(
                        hintText: "STD",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        DBHelper().update(id, txname.text, txno.text,
                            txstd.text, txprname.text);
                        getData();
                        Navigator.pop(context);
                      },
                      child: Text("UPDATE"),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
