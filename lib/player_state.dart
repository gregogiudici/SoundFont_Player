import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:soundfont_player/player_info.dart';

// C Major pentatonic scale
final scale = [48, 50, 52, 55, 57];

class PlayerState extends ChangeNotifier {
  int nTracks;
  int nButtons;
  int bpm;
  int _playSpeed;

  String _drum = "assets/StandardDrumKit.sf2";
  String get drum => _drum.replaceAll('assets/', '').replaceAll(".sf2", "");
  String _piano = "assets/Player_Piano.sf2";
  String get piano => _piano.replaceAll('assets/', '').replaceAll(".sf2", "");
  String _sequencer = "assets/ElectronicDrumKit.sf2";
  String get sequencer => _sequencer.replaceAll('assets/', '').replaceAll(".sf2", "");

  final _fluttermidi = FlutterMidi();
  StreamSubscription _subscription;
  List<int> get _midiNotes => (sequencer == "StandardDrumKit" || sequencer == "ElectronicDrumKit") ? PlayerInfo.drumNotes : _pianoNotes;
  List<int> _pianoNotes;

  var _selectedColumn = 9;
  var _selectedButtons = new Map<int, Map<int, bool>>();

  PlayerState({this.nTracks = 1, this.nButtons = 6, this.bpm = 240}) {
    this._playSpeed = 60000 ~/ bpm;
    _pianoNotes = List.generate(nTracks, (row) {
      return scale[row % 5] + 12 * (row / 5).floor();
    });
    load(_sequencer);
  }

  void load(String asset) async {
    ByteData _byte = await rootBundle.load(asset);
    _fluttermidi.prepare(sf2: _byte, name: asset.replaceAll('assets/', ''));
  }

  void setDrum(String asset) {
    _drum = asset;
    load(_drum);
    notifyListeners();
  }

  void setSequencer(String asset) {
    _sequencer = asset;
    load(_sequencer);
    notifyListeners();
  }

  void setPiano(String asset) {
    _piano = asset;
    load(_piano);
    notifyListeners();
  }

  void setSoundPlayer(String screen) {
    switch (screen) {
      case "piano":
        load(_piano);
        break;
      case "drumpad":
        load(_drum);
        break;
      case "sequencer":
        load(_sequencer);
        break;
    }
  }
  // DRUMPAD & PIANO
  void playNote(int midi){
    _fluttermidi.playMidiNote(midi: midi);
    Timer(Duration(milliseconds: 200), () {
      _fluttermidi.stopMidiNote(midi: midi);
    });
  }

  // SEQUENCER
  bool get isPlaying => _subscription != null && !_subscription.isPaused;

  void setBPM(int value){
    bpm = value;
    _playSpeed = 60000~/bpm~/2;
    notifyListeners();
  }

  bool isButtonTriggered(int column, int row) {
    return isButtonSelected(column, row) && column == _selectedColumn;
  }

  bool isButtonSelected(int column, int row) {
    if (!_selectedButtons.containsKey(column) ||
        !_selectedButtons[column].containsKey(row)) {
      return false;
    }

    return _selectedButtons[column][row];
  }

  void addButton(int column, int row) {
    if (!_selectedButtons.containsKey(column)) {
      _selectedButtons[column] = new Map<int, bool>();
    }

    _selectedButtons[column][row] = true;
    notifyListeners();
  }

  void removeButton(int column, int row) {
    _selectedButtons[column][row] = false;
    notifyListeners();
  }

  void reset() {
    //_subscription?.pause();
    _selectedButtons = new Map<int, Map<int, bool>>();
    _selectedColumn = 9;
    notifyListeners();
  }

  void pause() {
    _selectedColumn = 9;
    _subscription.pause();
    notifyListeners();
  }

  void start() {
    _selectedColumn = 7;
    _subscription?.cancel();

    _subscription = Stream.periodic(
      Duration(milliseconds: _playSpeed),
    ).listen((value) => playSample());
  }

  void playSample() {
    _selectedColumn = (_selectedColumn + 1) % nButtons;

    _selectedButtons[_selectedColumn]?.forEach((row, isSelected) {
      if (isSelected) {
        _fluttermidi.playMidiNote(midi: _midiNotes[row]);
        Timer(Duration(milliseconds: _playSpeed~/2), () {
          _fluttermidi.stopMidiNote(midi: _midiNotes[row]);
        });
      }
    });

    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
