import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundfont_player/player_state.dart';

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
                    // Io ci metterei dei ShowDialog: su Save compare solo da inserire il nome,
                    print("Save Pressed");
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
                    // Io ci metterei dei ShowDialog: su Load compare semplicemente una lista di beat salvati,
                    print("Load Pressed");
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
                    player.reset();
                  }))
        ],
      );
    });
  }
}
