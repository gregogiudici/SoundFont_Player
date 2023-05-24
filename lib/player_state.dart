import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundfont_player/player_info.dart';

class PlayerState extends ChangeNotifier {
  int nTracks;
  int nButtons;
  int bpm;
  int _playSpeed;

  String _drum = "assets/StandardDrumKit.sf2";

  String get drum => _drum.replaceAll('assets/', '').replaceAll(".sf2", "");
  String _piano = "assets/Piano.sf2";

  String get piano => _piano.replaceAll('assets/', '').replaceAll(".sf2", "");
  String _sequencer = "assets/ElectronicDrumKit.sf2";

  String get sequencer =>
      _sequencer.replaceAll('assets/', '').replaceAll(".sf2", "");

  final _fluttermidi = FlutterMidi();
  StreamSubscription _subscription;

  List<int> get _midiNotes =>
      (sequencer == "StandardDrumKit" || sequencer == "ElectronicDrumKit")
          ? PlayerInfo.drumNotes
          : PlayerInfo.pianoNotes;

  var _selectedColumn = 9;
  var _selectedButtons = new Map<int, Map<int, bool>>();

  PlayerState({this.nTracks = 1, this.nButtons = 6, this.bpm = 240}) {
    this._playSpeed = 60000 ~/ bpm;
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
  void playNote(int midi) {
    _fluttermidi.playMidiNote(midi: midi);
    Timer(Duration(milliseconds: 200), () {
      _fluttermidi.stopMidiNote(midi: midi);
    });
  }

  // SEQUENCER
  bool get isPlaying => _subscription != null && !_subscription.isPaused;

  void setBPM(int value) {
    bpm = value;
    _playSpeed = 60000 ~/ bpm ~/ 2;
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
    print(_selectedButtons);
    print(_selectedButtons[column]);
    print(_selectedButtons[column][row]);
    print([column, row]);
    notifyListeners();
  }

  void removeButton(int column, int row) {
    _selectedButtons[column][row] = false;
    notifyListeners();
  }

  void clear() {
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
    ).listen((value) => playSamples());
  }

  void playSamples() {
    _selectedColumn = (_selectedColumn + 1) % nButtons;

    _selectedButtons[_selectedColumn]?.forEach((row, isSelected) {
      if (isSelected) {
        _fluttermidi.playMidiNote(midi: _midiNotes[row]);
        Timer(Duration(milliseconds: _playSpeed ~/ 2), () {
          _fluttermidi.stopMidiNote(midi: _midiNotes[row]);
        });
      }
    });

    notifyListeners();
  }

  // Salvataggio e caricamento Sequencer
  Future<List<SequencerState>> LoadSharedPreferences(context) async {
    final mem = await SharedPreferences.getInstance();
    if (!mem.containsKey("num")) {
      mem.setInt("num", 0);
    }
    if (!mem.containsKey("sequences")) {
      mem.setStringList("sequences", []);
    }
    final num = mem.getInt("num");
    final saved = mem.getStringList("sequences");
    List<SequencerState> list = [];
    for (int i = 0; i < num; i++) {
      SequencerState x = SequencerState.fromMap(json.decode(saved[i]));
      list.add(x);
    }
    return Future.value(list);
  }

  void SaveSequencer(context, String name) async {
    SharedPreferences mem = await SharedPreferences.getInstance();
    if (!mem.containsKey('num'))
      mem.setInt("num",
          0); //se non è mai stata creata la key che conta quanti salvataggi ho fatto ,la inizializzo
    if (!mem.containsKey('sequences')) mem.setStringList("sequences", []);
    final int num = mem.getInt("num"); //In questa key ci sta il numero di suoni
    final List<String> saved = mem.getStringList("sequences");
    String json = jsonEncode(SequencerState(
            id: num + 1,
            name: name,
            sound: _sequencer,
            bpm: bpm,
            seq: parser(context))
        .toJson());
    // Aggiungo l'ultimo salvataggio
    saved.add(json);

    mem.setStringList("sequences", saved);
    mem.setInt("num", num + 1);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Sequencer State Saved"),
    ));
    notifyListeners();
  }

//Costruisco la stringa con i bottoni premuti
  String parser(context) {
    var x = '';
    for (var column = 0; column < PlayerInfo.nSounds; column++) {
      for (var row = 0; row < PlayerInfo.nButtons; row++) {
        isButtonSelected(row, column) ? {x += '1'} : {x += '0'};
      }
    }
    print("Parser: $x");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(x),
    ));
    return x;
  }

  void LoadSequencer(BuildContext context, int id) async {
    SharedPreferences mem = await SharedPreferences.getInstance();
    List<String> saved_list = mem.getStringList("sequences");
    SequencerState sequence =
        SequencerState.fromJson(jsonDecode(saved_list[id]));
    clear();
    // Caricamento di tutte le variabili
    for (var column = 0; column < PlayerInfo.nSounds; column++) {
      for (var row = 0; row < PlayerInfo.nButtons; row++) {
        int index = (row) * PlayerInfo.nButtons + column;
        if (sequence.seq[index] == '1') if (!isButtonSelected(column, row))
          addButton(column, row);
      }
    }
    setSequencer(sequence.sound);
    setBPM(sequence.bpm);

    notifyListeners();
  }

  void DeleteSequence(BuildContext context, int index) async {
    SharedPreferences mem = await SharedPreferences.getInstance();
    if (mem.containsKey("sequences")) {
      List<String> saved_list = mem.getStringList("sequences");
      saved_list.removeAt(index);
      mem.setStringList("sequences", saved_list);
      int num = mem.getInt("num");
      mem.setInt("num", num - 1);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sequencer State Deleted"),
      ));
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class SequencerState {
  int id;
  String name; //Nome con cui salvo la sequenza
  String sound; //Il synth che devo caricare
  int bpm; //Il bpm
  String seq; //64 bit che mi dicono quali bottoni sono accesi/spenti

  SequencerState(
      {this.id = 999,
      this.name = " ",
      this.sound = "assets/StandardDrumKit.sf2",
      this.bpm = 240,
      this.seq});

  factory SequencerState.fromMap(Map<String, dynamic> json) => SequencerState(
        id: json["id"],
        name: json["name"],
        sound: json["sound"],
        bpm: json["bpm"],
        seq: json["seq"],
      );

  Map<String, dynamic> toMap() =>
      {"id": id, "name": name, "sound": sound, "bpm": bpm, "seq": seq};

  SequencerState.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sound = json['sound'];
    bpm = json['bpm'];
    seq = json['seq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sound'] = this.sound;
    data['bpm'] = this.bpm;
    data['seq'] = this.seq;
    return data;
  }
}
