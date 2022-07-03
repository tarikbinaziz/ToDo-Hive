import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _addTodoController = TextEditingController();
  TextEditingController _updateTodoController = TextEditingController();

  Box? todoBox;

  @override
  void initState() {
    todoBox = Hive.box('todoBox_list');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getting the size of the window
    var size, height, width;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('ToDo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: height / 15,
              child: TextField(
                controller: _addTodoController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter your day ToDo',
                  hintStyle: TextStyle(color: Colors.green),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {},
            //  child: Text('Add Todos'),
            //   style: ElevatedButton.styleFrom(
            //       primary: Colors.green,
            //       shape: StadiumBorder(),
            //       elevation: 3,
            //       minimumSize: Size(100,80)),
            // )
            SizedBox(
              height: 10,
            ),
            Container(
              width: width / 2,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  onPressed: () async {
                    final _userInput = _addTodoController.text;
                    await todoBox?.add(_userInput);
                    Fluttertoast.showToast(msg: 'Add new ToDo');
                    _addTodoController.clear();
                  },
                  child: Text("Add Todo", textAlign: TextAlign.center),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: StadiumBorder(),
                    elevation: 3,
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ValueListenableBuilder(
                builder: (_, box, Widget) {
                  return ListView.builder(
                      itemCount: todoBox!.keys.toList().length,
                      itemBuilder: (_, index) {
                        return Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text(todoBox!.getAt(index)),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        final input = _addTodoController.text;

                                        
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return AlertDialog(
                                                backgroundColor: Colors.grey,
                                                title: Text(
                                                  'updated this todo',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                content: Column(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          _updateTodoController..text=todoBox!.getAt(index),
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        hintText:
                                                            'Enter your update ToDo',
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.green),
                                                        border: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            40))),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          final _userInput =
                                                              _updateTodoController
                                                                  .text;
                                                          await todoBox?.putAt(
                                                              index,
                                                              _userInput);
                                                          Navigator.pop(
                                                              context);
                                                          Fluttertoast.showToast(
                                                              msg: 'Updated');
                                                        },
                                                        child: Text(
                                                            "Update Todo",
                                                            textAlign: TextAlign
                                                                .center),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors.green,
                                                          shape:
                                                              StadiumBorder(),
                                                          elevation: 3,
                                                        )),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      )),
                                  //SizedBox(width: 40,),
                                  IconButton(
                                      onPressed: () {
                                        todoBox?.deleteAt(index);
                                        Fluttertoast.showToast(msg: 'Deleted');
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                valueListenable: Hive.box('todoBox_list').listenable(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
