import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundfont_player/player_state.dart';
import 'dart:async';

class SequencerControl extends StatefulWidget {
  @override
  _SequencerControlState createState() => _SequencerControlState();
}

class _SequencerControlState extends State<SequencerControl>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(milliseconds: 250),
    );
  }

  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerState>(builder: (context, player, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!player.isPlaying) {
                        if (player.bpm < 300) player.setBPM((player.bpm + 1));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "To change BPM the sequencer must not be running.")));
                      }
                    },
                    onLongPress: () {
                      _timer = Timer.periodic(const Duration(milliseconds: 100),
                          (timer) {
                        if (!player.isPlaying) {
                          if (player.bpm < 300) player.setBPM((player.bpm + 1));
                        }
                      });
                    },
                    onLongPressUp: () {
                      _timer.cancel();
                    },
                    child: Icon(Icons.arrow_circle_up,
                        color: Colors.blue, size: 50.0),
                  ),
                  Container(
                      color: Colors.blue,
                      padding: const EdgeInsets.all(10),
                      // Change button text when light changes state.
                      child: Text(
                        "BPM: " + (player.bpm).toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                  GestureDetector(
                    onTap: () {
                      if (!player.isPlaying) {
                        if (player.bpm > 50) player.setBPM((player.bpm - 1));
                      }else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "To change BPM the sequencer must not be running.")));
                      }
                    },
                    onLongPress: () {
                      _timer = Timer.periodic(const Duration(milliseconds: 100),
                          (timer) {
                        if (!player.isPlaying) {
                          if (player.bpm > 50) player.setBPM((player.bpm - 1));
                        }
                      });
                    },
                    onLongPressUp: () {
                      _timer.cancel();
                    },
                    child: Icon(Icons.arrow_circle_down,
                        color: Colors.blue, size: 50.0),
                  ),
                ]),
          ),
          CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: IconButton(
                  iconSize: 60.0,
                  color: Colors.white,
                  onPressed: () {
                    if (player.isPlaying) {
                      _animationController.reverse();
                      player.pause();
                    } else {
                      _animationController.forward();
                      player.start();
                    }
                  },
                  icon:
                      Icon(player.isPlaying ? Icons.pause : Icons.play_arrow))),
        ],
      );
    });
  }
}
