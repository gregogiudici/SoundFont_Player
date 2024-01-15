# Soundfont Player

This mobile application is designed for both Android and iOS platforms and serves as a versatile SoundFont player with multiple user interfaces, including a Sequencer, Drumpad, and Keyboard. Whether you're a music enthusiast, a producer, or simply someone who enjoys experimenting with sounds, this app provides a rich and interactive experience.

## Features:
**Sequencer**: Create intricate musical sequences with a user-friendly sequencer interface. Arrange and play your favorite SoundFont files in a sequenced manner, unleashing your creativity and save your favorite sequences.
<p float="right">
  <img src="assets\img\sequencer_light.png" width="200" />
  <img src="assets\img\sequencer_3_dark.png" width="200" /> 
  <img src="assets\img\sequencer_2_dark.png" width="200" /> 
</p>

**Drumpad**: Have fun exploring various drum sounds with the Drumpad interface. Tap and experiment with different percussion elements to compose unique beats and rhythms.
<p float="right">
  <img src="assets\img\drumpad_light.png" width="200" />
  <img src="assets\img\drumpad_2_dark.png" width="200" />
</p>

**Keyboard**: Play melodies and chords using the Keyboard interface. The app supports a wide range of SoundFont instruments, allowing you to express yourself through diverse musical tones.
<p float="right">
  <img src="assets\img\keyboard_light.png" width="200" />
  <img src="assets\img\keyboard_dark.png" width="400" />
</p>

**Cross-Platform Compatibility**: Built using Flutter, this app ensures a consistent and smooth experience across both Android and iOS devices.

## Getting Started
### Prerequisites and Installation
1) Ensure you have [Flutter](https://flutter.dev/) installed on your machine. (**NOTE:** this app was made with Flutter 3.7.12, so there may be incompatibilities with other versions of Flutter)
2) Clone this repository:
```bash
git clone git@github.com:gregogiudici/SoundFont_Player.git
cd SoundFont_Player
```
### Running the App
1. Open a terminal in the project directory and run:
```bash
flutter pub get
```
2. Connect you Android/iOS device or launch an emulator
3. Run the app:
```bash
flutter run
```


# Acknowledgements and Credits
The development of this App was part of our Master's degree in Electronic Engineering
- Sequencer Widget was inspired by [flutternome](https://github.com/danpanaite/flutternome) and [Creating Music with Flutter](https://medium.com/flutter-community/creating-music-with-flutter-e6b5216a466b)
- Drumpad Widget was inspired by [flutter-drum-machine-demo](https://github.com/kenreilly/flutter-drum-machine-demo)
