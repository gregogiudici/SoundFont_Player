import 'package:flutter/material.dart';
import 'package:soundfont_player/player_info.dart';

class Pad extends StatelessWidget {

  Pad({ this.height, this.width, this.value, @required this.onTapDown});

  final double height;
  final double width;
  final int value;

  final Function onTapDown;

  //DRUM_SAMPLE get _sample => DRUM_SAMPLE.values[value];
  String get _name => PlayerInfo.samples[value];
  Color get _color => PlayerInfo.colors[value];

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        height: height * .82,
        width: width * .88,
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: _color),
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: _color.withOpacity(0.12)
            ),
            child: SizedBox.expand(
                child: InkWell(
                  enableFeedback: false,
                  onTap: () => this.onTapDown(value),
                  child: Center(child: Text(_name)),
                )
            )
        )
    );
  }
}
