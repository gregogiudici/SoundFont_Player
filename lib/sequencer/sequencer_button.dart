import 'package:flutter/material.dart';
import 'package:soundfont_player/player_info.dart';
import 'package:provider/provider.dart';
import 'package:soundfont_player/player_state.dart';

class SequencerButton extends StatelessWidget {

  final int row;
  final int column;
  final buttoncolor;

  final Function onTapDown;
  final Function onPanUpdate;

  const SequencerButton(this.row, this.column,this.buttoncolor, {key, this.onTapDown, this.onPanUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerState>(
      builder: (context, player, child) {

        final isTriggered = player.isButtonTriggered(column, row);

        final color = isTriggered
            ? buttoncolor.withOpacity(0.5)
            : player.isButtonSelected(column, row)
                ? buttoncolor
                : Colors.white;

        return GestureDetector(
          onTapDown: this.onTapDown,
          onPanUpdate: this.onPanUpdate,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 125),
            width: PlayerInfo.buttonWidth,
            height: PlayerInfo.buttonHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: !isTriggered
                  ? Border.all(width: 2.0, color: buttoncolor)
                  : null,
              boxShadow: isTriggered
                  ? [
                      BoxShadow(
                        blurRadius: 12.0,
                        spreadRadius: 2.0,
                        color: Colors.white,
                      ),
                    ]
                  : [],
              color: color,
            ),
          ),
        );
      },
    );
  }
}
