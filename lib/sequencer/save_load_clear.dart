import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundfont_player/player_info.dart';
import 'package:soundfont_player/player_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SaveLoadClear extends StatefulWidget {
  @override
  _SaveLoadClearState createState() => _SaveLoadClearState();
}

class _SaveLoadClearState extends State<SaveLoadClear> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerState>(builder: (context, player, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: ElevatedButton(
                  child: Text(
                    "SAVE",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                  onPressed: () {
                    String valueText;
                    final TextEditingController _textFieldController = TextEditingController();
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('TextField in Dialog'),
                              content: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    valueText = value;
                                  });
                                },
                                controller: _textFieldController,
                                decoration:
                                const InputDecoration(hintText: "Text Field in Dialog"),
                              ),
                              actions: <Widget>[
                                MaterialButton(
                                  color: Colors.red,
                                  textColor: Colors.white,
                                  child: const Text('CANCEL'),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                                MaterialButton(
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  child: const Text('OK'),
                                  onPressed: () {
                                    setState(() {
                                      SaveSequence(context,valueText,PlayerState().bpm,PlayerState().sequencer);
                                      print("Save Pressed");
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                              ],
                            );
                          });
                  })),
          Padding(
              padding: const EdgeInsets.only(left: 6.0, right: 6.0),
              child: ElevatedButton(
                  child: Text(
                    "LOAD",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                  onPressed: () {
                    print("Load Pressed");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  LoadActivity()),
                    );
                  })),
          Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: ElevatedButton(
                  child: Text(
                    "CLEAR",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue)),
                  onPressed: () {
                    player.reset();
                  }))
        ],
      );
    });
  }
}

class LoadActivity extends StatelessWidget {
  //const LoadActivity({Key key});
  //final Future<List<Sequence>> list = LoadSharedPrefernces();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: FutureBuilder<List<Sequence>>(
          future: LoadSharedPrefernces(context),
          builder: (context,AsyncSnapshot<List<Sequence>> snapshot){
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    return Card(
                      child: Row(
                        children: [
                          Text(snapshot.data[index].name,textAlign: TextAlign.center,),
                          IconButton(
                            icon: const Icon(Icons.upload),
                            tooltip: 'Increase volume by 10',
                            onPressed: () {
                              LoadSequence(context,snapshot.data[index].seq);
                              Navigator.pop(context);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: 'Increase volume by 10',
                            onPressed: () {
                              DeleteSequence(context, snapshot.data[index].id);
                              Navigator.pop(context);
                              //PlayerState().notifyListeners();
                            },
                          )
                        ],

                      ),
                    );
                  }
              );
            } else {
              return CircularProgressIndicator();
            }
          }
        ),
        /**/
        ),
      );
  }
}

Future<List<Sequence>> LoadSharedPrefernces(context) async {
  final mem = await SharedPreferences.getInstance();
  if(!mem.containsKey("num")){
    mem.setInt("num", 0);
  }
  final num = mem.getInt("num");
  List<Sequence> list = [];
  for(int i=0;i<=num-1;i++){
    bool flag=true;
    int j=i+1;
    do{
      if(mem.containsKey(j.toString())){
        Sequence x = Sequence.fromMap(json.decode(mem.getString(j.toString())));
        list.add(x);
        flag=false;
      }
      if(j>num)
        flag=false;
      j++;
    }while(flag);
  }
  return Future.value(list);
}

void SaveSequence(context,String name,int bpm,String synth) async{
  SharedPreferences newSave = await SharedPreferences.getInstance();
  if(!newSave.containsKey('num'))
    newSave.setInt("num", 0); //se non è mai stata creata la key che conta quanti salvataggi ho fatto ,la inizializzo
  final int i = newSave.get("num"); //In questa key ci sta il numero di suoni

  int j=0;
  bool flag=true;
  do{ //decido con che nome salvare la nuova sequence
    if(!newSave.containsKey((j+1).toString()) || j>=i){
      newSave.setString((j+1).toString(), jsonEncode(Sequence(
        id: j+1,
        name: name,
        synth: synth,
        bpm: bpm,
        seq: parser(context)
      ).toMap()));
      flag=false;
    }
      j++;
  }while(flag);
  newSave.setInt("num", i+1);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Sequenza salvata"),
  ));
}

//Costruisco la stringa con i bottoni premuti
parser(context) {
  var x='';
  for(var columnIndex=1; columnIndex<=PlayerInfo.nSounds; columnIndex++){
    for(var rowIndex=1; rowIndex<=PlayerInfo.nButtons; rowIndex++){
      Provider.of<PlayerState>(context, listen: false).isButtonSelected(columnIndex, rowIndex)
          ? {
          x+='1'
      }
          : {
        x+='0'
      };
    }
  }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(x),
  ));
  return x;
}

void LoadSequence(BuildContext context,String seq) async{
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(seq),
  ));
  for(var columnIndex=1; columnIndex<=PlayerInfo.nSounds; columnIndex++){
    for(var rowIndex=1; rowIndex<=PlayerInfo.nButtons; rowIndex++){
      int index = (columnIndex-1)*PlayerInfo.nButtons+columnIndex;
      if(seq[index-1].hashCode==1)
        Provider.of<PlayerState>(context, listen: false).addButton(columnIndex-1, rowIndex-1);
      else
        Provider.of<PlayerState>(context, listen: false).removeButton(columnIndex-1, rowIndex-1);
    }
  }
}

void DeleteSequence(BuildContext context, int id) async{
  SharedPreferences mem = await SharedPreferences.getInstance();
  if(mem.containsKey(id.toString())) {
    mem.remove(id.toString());
    int num = mem.getInt("num");
    mem.setInt("num", num - 1);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Sequenza eliminata"),
    ));
  }
}

class Sequence {
  int id;
  String name;    //Nome con cui salvo la sequenza
  String synth;   //Il synth che devo caricare
  int bpm;        //Il bpm
  String seq;     //64 bit che mi dicono quali bottoni sono accesi/spenti

  Sequence({
    this.id,
    this.name,
    this.synth,
    this.bpm,
    this.seq
  });

  factory Sequence.fromMap(Map<String, dynamic> json) => Sequence(
    id: json["id"],
    name: json["name"],
    synth: json["synth"],
    bpm: json["bpm"],
    seq: json["seq"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "synth":synth,
    "bpm": bpm,
    "seq": seq
  };

  Sequence.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    synth = json['synth'];
    bpm = json['bpm'];
    seq = json['seq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['synth'] = this.synth;
    data['bpm'] = this.bpm;
    data['seq'] = this.seq;
    return data;
  }
}
