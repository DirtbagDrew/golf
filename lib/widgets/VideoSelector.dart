import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';

class VideoSelector extends StatefulWidget {
  VideoSelector(
      {Key key,
      @required this.selectedVideo})
      : super(key: key);

  final ValueChanged<String> selectedVideo;

  _VideoPickerState createState() => _VideoPickerState();
}

class _VideoPickerState extends State<VideoSelector> {

// This funcion will helps you to pick a Video File
  void _pickVideo(String source) async {
    File video = source == 'gallery'
        ? await ImagePicker.pickVideo(source: ImageSource.gallery)
        : await ImagePicker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      setState(() {
        widget.selectedVideo(video.path);
      });
    }
  }

  Widget build(BuildContext context) {
    // This example adds a green border on tap down.
    // On tap up, the square changes to the opposite state.
    return SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          backgroundColor: Colors.white,
          child: Icon(Icons.add),
          children: [
            SpeedDialChild(
                child: Icon(Icons.video_library),
                backgroundColor: Colors.red,
                label: 'gallery',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () => _pickVideo('gallery')),
            SpeedDialChild(
              child: Icon(Icons.videocam),
              backgroundColor: Colors.blue,
              label: 'camera',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => _pickVideo('camera'),
            ),
          ],
          closeManually: false,
          curve: Curves.bounceIn,
          elevation: 8.0,
          foregroundColor: Colors.black,
          heroTag: 'speed-dial-hero-tag',
          marginBottom: 20,
          marginRight: 18,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          shape: CircleBorder(),
          tooltip: 'Speed Dial',
          visible: true,
        );
  }
}
