import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundfont_player/player_state.dart';

class SequencerSound extends StatefulWidget {
  const SequencerSound();

  @override
  State<SequencerSound> createState() => _SequencerSoundState();
}

class _SequencerSoundState extends State<SequencerSound> {
  String selected;

  @override
  Widget build(BuildContext context) {
    selected = Provider.of<PlayerState>(context, listen: false).sequencer;
    return CircleAvatar(
        radius: 20,
        backgroundColor: Colors.blue,
        child: PopupMenuButton<String>(
          icon: Icon(Icons.music_note, color: Colors.white),
          initialValue: selected,
          // Callback that sets the selected popup menu item.
          onSelected: (String sound) {
            if (Provider.of<PlayerState>(context, listen: false).isPlaying ==
                false) {
              setState(() {
                selected = sound;
              });
              Provider.of<PlayerState>(context, listen: false)
                  .setSequencer("assets/" + selected + ".sf2");
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("To change sound the sequencer must not be running."),
              ));
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: "ElectronicDrumKit",
              child: Text('Electronic Drum'),
            ),
            const PopupMenuItem<String>(
              value: "StandardDrumKit",
              child: Text('Standard Drum'),
            ),
            const PopupMenuItem<String>(
              value: "Piano",
              child: Text('Piano'),
            ),
            const PopupMenuItem<String>(
              value: "Synth",
              child: Text('Synth'),
            ),
            const PopupMenuItem<String>(
              value: "Pulse",
              child: Text('Pulse'),
            ),
            const PopupMenuItem<String>(
              value: "Rhodes",
              child: Text('Rhodes'),
            ),
            const PopupMenuItem<String>(
              value: "Saw",
              child: Text('Saw'),
            ),
            const PopupMenuItem<String>(
              value: "Square",
              child: Text('Square'),
            ),
          ],
        ));
  }
}
