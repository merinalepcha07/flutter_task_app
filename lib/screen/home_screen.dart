import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> list = [];
  var value = "";
  var deleteIndex = -1;
  @override
  void initState() {
    load();
  }

  void load() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      list = prefs.getStringList('items')!;
    });
   }


  void addTask() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      list.add(value);
    });
    await prefs.setStringList('items', list); 
  }

  void deleteTask() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      list.removeAt(deleteIndex);
    });
    await prefs.setStringList('items', list); 
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            height: 500,
            child: Card(
              elevation: 10,
              child: Column(
                children: [
                  //textField
                  Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    margin: EdgeInsets.only(top: 10),
                    child: TextField(
                      onChanged: (text) {
                        value = text;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 50,
                        ),
                        hintText: 'Enter your task',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  //button
                  Container(
                    width: 250,
                    height: 50,
                    margin: EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(250, 50), // button size
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'Add Task',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  //task
                  SizedBox(
                    width: 250,
                    height: 350,
                    child: ListView(
                      children: [
                        for (int i = 0; i < list.length; i++) ...[
                          Container(
                            width: 250,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            margin: EdgeInsets.only(top: 10),
                            child: ListTile(
                              trailing: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    deleteIndex = i;
                                    deleteTask();
                                  },
                                  child: Icon(Icons.delete, color: Colors.red),
                                ),
                              ),
                              title: Text(
                                list[i],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
