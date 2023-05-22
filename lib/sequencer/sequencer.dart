import 'package:flutter/material.dart';
import 'package:soundfont_player/player_info.dart';
import 'package:provider/provider.dart';
import 'package:soundfont_player/player_state.dart';
import 'package:soundfont_player/sequencer/sequencer_button.dart';
import 'package:soundfont_player/color.dart';


class Sequencer extends StatelessWidget {

  final int nButtons;
  final int nTracks;

  const Sequencer({Key key, this.nTracks, this.nButtons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttons = List.generate(
      nButtons,
      (columnIndex) => List.generate(
        nTracks,
        (rowIndex) => SequencerButton(
          rowIndex,
          columnIndex,
          PlayerInfo.colors[rowIndex],
          onTapDown: (details) {
            Provider.of<PlayerState>(context, listen: false).isButtonSelected(columnIndex, rowIndex)
              ? Provider.of<PlayerState>(context, listen: false).removeButton(columnIndex, rowIndex)
              : Provider.of<PlayerState>(context, listen: false).addButton(columnIndex, rowIndex);
          },
          onPanUpdate: (details) {
            Provider.of<PlayerState>(context, listen: false).addButton(columnIndex, rowIndex);
          }
        ),
      ),
    );

    var buttonGrid = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons
          .map(
            (buttonColumn) => Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttonColumn,
            ),
          )
          .toList(),
    );

    return Container(
      width: PlayerInfo.width,
      height: PlayerInfo.height,
      decoration: BoxDecoration(
          color: Theme.of(context).focusColor,//Colors.grey[200],
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(width: 2.0, color: Color(0xFF3e3e3e))),
      child: buttonGrid,
    );
  }
}