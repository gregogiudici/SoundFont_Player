import 'package:flutter/material.dart';
import 'package:soundfont_player/keyboard/keyboard_button.dart';

class KeyboardControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    Size size = MediaQuery.of(context).size;
    var isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return Container(
        color: (isDarkmode) ? Theme.of(context).colorScheme.surface : Colors.white,
        width: size.width, //isPortrait ? 200 : 600,
        height: isPortrait
            ? size.height / 1.9
            : size.height / 3.1, //isPortrait? 400 : 200,
        child: FittedBox(
            fit: BoxFit.contain,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Widget>.generate(
                    isPortrait ? 3 : 1,
                    (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List<Widget>.generate(
                                isPortrait ? 2 : 6,
                                (j) => Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: KeyboardButton(2 * i + j)))))))));
  }
}
