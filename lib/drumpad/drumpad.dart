import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundfont_player/drumpad/pad.dart';
import 'package:soundfont_player/player_info.dart';
import 'package:soundfont_player/player_state.dart';

class DrumPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //double padBankHeight = (size.height / 3 );
    double padHeight = size.height / 9;
    double padWidth = size.width / 2;

    return Consumer<PlayerState>(builder: (context, player, child) {
      return Container(
          color: Colors.white, //Colors.black38,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List<Widget>.generate(
                  8,
                  (i) => Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List<Widget>.generate(
                              2,
                              (j) => Pad(
                                    height: padHeight,
                                    width: padWidth,
                                    value: 2 * i + j,
                                    onTapDown: (details) {
                                      player.playNote(PlayerInfo.drumNotes[2 * i + j]);
                                    },
                                  )
                          )
                      )
                  )
              )
          )
      );
    });
  }
}