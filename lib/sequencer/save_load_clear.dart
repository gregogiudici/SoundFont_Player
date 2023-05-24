import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundfont_player/player_info.dart';
import 'package:soundfont_player/player_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SaveLoadClear extends StatefulWidget {
  @override
  _SaveLoadClearState createState() => _SaveLoadClearState();
}

class _SaveLoadClearState extends State<SaveLoadClear> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerState>(builder: (context, player, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: ElevatedButton(
                  child: Text(
                    "SAVE",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                  onPressed: () {
                    String valueText = " ";
                    final TextEditingController _textFieldController =
                        TextEditingController();
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Save Sequencer State'),
                            content:
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  valueText = value;
                                });
                              },
                              controller: _textFieldController,
                              decoration:
                                  const InputDecoration(hintText: "Name"),
                            ),
                            actions: <Widget>[
                              MaterialButton(
                                color: Colors.red,
                                textColor: Colors.white,
                                child: const Text('CANCEL'),
                                onPressed: () {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                              MaterialButton(
                                color: Colors.green,
                                textColor: Colors.white,
                                child: const Text('OK'),
                                onPressed: () {
                                  setState(() {
                                    Provider.of<PlayerState>(context,
                                            listen: false)
                                        .SaveSequencer(context, valueText);
                                    print("Save Pressed");
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ],
                          );
                        });
                  })),
          Padding(
              padding: const EdgeInsets.only(left: 6.0, right: 6.0),
              child: ElevatedButton(
                  child: Text(
                    "LOAD",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                  onPressed: () {
                    print("Load Pressed");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoadApp()),
                    );
                  })),
          Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: ElevatedButton(
                  child: Text(
                    "CLEAR",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                  onPressed: () {
                    player.clear();
                  }))
        ],
      );
    });
  }
}

class LoadApp extends StatelessWidget {
  //const LoadActivity({Key key});
  //final Future<List<Sequence>> list = LoadSharedPrefernces();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Sequencer State'),
      ),
      body: Center(
        child: FutureBuilder<List<SequencerState>>(
            future: Provider.of<PlayerState>(context, listen: false)
                .LoadSharedPreferences(context),
            builder: (context, AsyncSnapshot<List<SequencerState>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      //var name = snapshot.data[index].name;
                      return Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  snapshot.data[index].name,
                                  textAlign: TextAlign.center,
                                )),
                            Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.download),
                                        tooltip: 'Load Sequence',
                                        onPressed: () {
                                          Provider.of<PlayerState>(context,
                                                  listen: false)
                                              .LoadSequencer(context, index);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        tooltip: 'Delete Sequence',
                                        onPressed: () {
                                          Provider.of<PlayerState>(context,
                                                  listen: false)
                                              .DeleteSequence(context, index);
                                          Navigator.pop(context);
                                          //PlayerState().notifyListeners();
                                        },
                                      )
                                    ]
                                )
                            )
                          ],
                        ),
                      );
                    });
              } else {
                return CircularProgressIndicator();
              }
            }),
        /**/
      ),
    );
  }
}
