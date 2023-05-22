import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:piano/piano.dart';
import 'package:soundfont_player/drumpad/drumpad_sound.dart';
import 'package:soundfont_player/keyboard/keyboard_control.dart';
import 'package:soundfont_player/sequencer/save_load_clear.dart';
import 'package:provider/provider.dart';

import 'package:soundfont_player/player_state.dart';
import 'package:soundfont_player/sequencer/sequencer_control.dart';
import 'package:soundfont_player/sequencer/sequencer.dart';
import 'package:soundfont_player/player_info.dart';
import 'package:soundfont_player/drumpad/drumpad.dart';
import 'package:soundfont_player/sequencer/sequencer_sound.dart';
import 'package:soundfont_player/color.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PlayerState(
          nTracks: PlayerInfo.nSounds, nButtons: PlayerInfo.nButtons),
      child: SequencerApp(),
    ),
  );
}

class SequencerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Sequencer',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Sequencer"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SaveLoadClear(),
                  SequencerSound(),
                ],
              ),
            ),
            Sequencer(
              nTracks: PlayerInfo.nSounds,
              nButtons: PlayerInfo.nButtons,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: SequencerControl(),
            ),
          ],
        )),
        drawer: MyDrawer(),
      ),
    );
  }
}

class DrumPadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'DrumPad',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title: Text("DrumPad"),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: DrumPadSound()),
          ],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 18.0), child: DrumPad())
            ]),
        drawer: MyDrawer(),
      ),
    );
  }
}

class KeyboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Keyboard',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(title: Text("Keyboard")),
        body: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              KeyboardControl(),
              SizedBox(
                height: isPortrait ? size.height/3 : size.height/2.2, //300 : 100,
                child: InteractivePiano(
                  //hideScrollbar: true,
                  keyWidth: isPortrait ? 45 : 80,
                  highlightedNotes: [],
                  naturalColor: Colors.white,
                  accidentalColor: Colors.black,
                  //noteRange: NoteRange(NotePosition(note: Note.C, octave: 4),
                  //  NotePosition(note: Note.C, octave: 5)),
                  noteRange: NoteRange.forClefs([
                    Clef.Treble,
                  ]),
                  onNotePositionTapped: (position) {
                    Provider.of<PlayerState>(context, listen: false)
                        .playNote(position.pitch);
                  },
                ),
              )
            ]),
        drawer: MyDrawer(),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(
      children: <Widget>[
        DrawerHeader(
            child: Container(
          width: 300,
          height: 300,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(" SoundFont \n Player "),
          ),
        )),
        ListTile(
          leading: Icon(Icons.blur_linear),
          title: Text('Sequencer'),
          onTap: () {
            Provider.of<PlayerState>(context, listen: false)
                .setSoundPlayer("sequencer");
            Navigator.pop(context);
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new SequencerApp()));
          },
        ),
        ListTile(
          leading: Icon(Icons.grid_on),
          title: Text('Drumpad'),
          onTap: () {
            if (Provider.of<PlayerState>(context, listen: false).isPlaying) {
              Provider.of<PlayerState>(context, listen: false).pause();
            }
            Provider.of<PlayerState>(context, listen: false)
                .setSoundPlayer("drumpad");
            Navigator.pop(context);
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new DrumPadApp()));
          },
        ),
        ListTile(
          leading: Icon(Icons.piano),
          title: Text('Keyboard'),
          onTap: () {
            if (Provider.of<PlayerState>(context, listen: false).isPlaying) {
              Provider.of<PlayerState>(context, listen: false).pause();
            }
            Provider.of<PlayerState>(context, listen: false)
                .setSoundPlayer("piano");
            Navigator.pop(context);
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new KeyboardApp()));
          },
        ),
        Divider(),
        AboutListTile(
          // <-- SEE HERE
          icon: Icon(
            Icons.info,
          ),
          child: Text('About us'),
          applicationIcon: Icon(
            Icons.person,
          ),
          applicationName: 'SoundFont Player',
          //applicationVersion: '1.0.0',
          aboutBoxChildren: [
            Text("Filippo Ceciliani\nGregorio Andrea Giudici\nSilvio Osimi"),
          ],
        ),
      ],
    ));
  }
}
