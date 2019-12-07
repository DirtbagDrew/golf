import 'dart:io';
import 'package:video_player/video_player.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class VideoSelector extends StatefulWidget {
  @override
  _VideoSelectorState createState() => _VideoSelectorState();
}

class _VideoSelectorState extends State<VideoSelector> {
  File _image;
  VideoPlayerController _videoPlayerController;
  File _video;

// This funcion will helps you to pick a Video File
_pickVideoFromGallery() async {
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);
     _video = video; 
    _videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_) {
      setState(() { });
      _videoPlayerController.play();
    });
}

  VideoPlayerController _cameraVideoPlayerController;
  
// This funcion will helps you to pick and Image from Camera
_pickVideoFromCamera() async {
    File video = await  ImagePicker.pickVideo(source: ImageSource.camera);
     _video = video; 
    _cameraVideoPlayerController = VideoPlayerController.file(_video)..initialize().then((_) {
      setState(() { });
      _cameraVideoPlayerController.play();
    });
}

  void _select(String choice) {
    choice == 'gallery'?_pickVideoFromGallery():_pickVideoFromCamera()();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
    child: Column(
        children: <Widget>[
            if(_video != null) 
                    _cameraVideoPlayerController.value.initialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController),
                )
                : Container(),
        ]),
),
 floatingActionButton: PopupMenuButton(
          elevation: 10.0,
          child: Icon(Icons.add, color: Colors.black), 
          color: Colors.green,
          onSelected: _select,
          itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
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