import 'dart:io';
import 'package:video_player/video_player.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideoSelector extends StatefulWidget {
  @override
  _VideoSelectorState createState() => _VideoSelectorState();
}

class _VideoSelectorState extends State<VideoSelector> {
  File _video;

// This funcion will helps you to pick a Video File
  _pickVideoFromGallery() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    _video = video;
  }

// This funcion will helps you to pick and Image from Camera
  _pickVideoFromCamera() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.camera);
    _video = video;
  }

  void _select(String choice) {
    choice == 'gallery' ? _pickVideoFromGallery() : _pickVideoFromCamera()();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: <Widget>[]),
      ),
      floatingActionButton: PopupMenuButton(
        elevation: 10.0,
        child: Icon(Icons.add, color: Colors.black),
        color: Colors.green,
        onSelected: _select,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'gallery',
            child: Icon(Icons.video_library),
          ),
          const PopupMenuItem<String>(
            value: 'camera',
            child: Icon(Icons.videocam),
          ),
        ],
      ),
    );
  }
}
