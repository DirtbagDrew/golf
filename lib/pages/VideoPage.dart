import 'dart:async';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../widgets/VideoSlider.dart';
import '../widgets/VideoSelector.dart';
import '../widgets/VideoPlayerScreen.dart';

class VideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VideoPageContent();
  }
}

class VideoPageContent extends StatefulWidget {
  VideoPageContent({Key key}) : super(key: key);

  @override
  _VideoPageScreenState createState() => _VideoPageScreenState();
}

class _VideoPageScreenState extends State<VideoPageContent> {
  String _videoString = 'assets/tiger.mp4';
  String _videoType = 'asset';

  double _deviceHeight() {
    return MediaQuery.of(context).size.height;
  }

  double _deviceWidth() {
    return MediaQuery.of(context).size.width;
  }

  void _pickVideo(String videoPath) {
    setState(() {
      _videoString = videoPath;
      _videoType = 'file';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          constraints: BoxConstraints(
              maxHeight: _deviceHeight(), maxWidth: _deviceWidth()),
          child: Row(
            children: <Widget>[
              Expanded(
                child: VideoPlayerScreen(
                  videoString: _videoString,
                  videoType: _videoType,
                ),
              )
            ],
          ),
        ),
        floatingActionButton: VideoSelector(
          selectedVideo: _pickVideo,
        ));
  }
}
