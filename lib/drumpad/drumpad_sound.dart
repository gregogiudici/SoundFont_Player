import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundfont_player/player_state.dart';

class DrumPadSound extends StatefulWidget {
  const DrumPadSound();

  @override
  State<DrumPadSound> createState() => _DrumPadSoundState();
}

class _DrumPadSoundState extends State<DrumPadSound> {
  String _selected;

  @override
  Widget build(BuildContext context) {
    _selected = Provider.of<PlayerState>(context, listen: false).drum;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(10)),
        // dropdown below..
        child: DropdownButton<String>(
          icon: Icon(Icons.music_note, color: Colors.blue,),
          style: TextStyle(color: Colors.blue),
          value: _selected,
          items: const [
            DropdownMenuItem(
              value: 'StandardDrumKit',
              child: Text('Standard Drum'),
            ),
            DropdownMenuItem(
              value: 'ElectronicDrumKit',
              child: Text('Electronic Drum'),
            ),
          ],
          onChanged: (String value) {
            setState(() {
              _selected = value;
            });
            Provider.of<PlayerState>(context, listen: false)
                .setDrum("assets/" + _selected + ".sf2");
          },
        ));
  }
}
