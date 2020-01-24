import 'dart:async';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'VideoSlider.dart';
import 'VideoSelector.dart';
import 'VideoPlayerScreen.dart';

class VideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VideoPageContent();
  }
}

class VideoPageContent extends StatefulWidget {
  VideoPageContent({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPageContent> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool _visible = true;

  setVideo(String type, String videoString) {
    if (_controller != null) {
      _controller.pause();
    }

    if (type == 'file') {
      _controller = VideoPlayerController.file(new File(videoString));
    } else if (type == 'asset') {
      _controller = VideoPlayerController.asset(videoString);
    } else {
      _controller = VideoPlayerController.network(videoString);
    }

    _controller
      ..addListener(() {
        setState(() {});
      });

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();
    // _controller.

    // Use the controller to loop the video.
    _controller.setLooping(true);
    _controller.play();
  }

  double deviceWidth() {
    return MediaQuery.of(context).size.width;
  }

  double deviceHeight() {
    return MediaQuery.of(context).size.height;
  }

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    setVideo('asset', 'assets/tiger.mp4');
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  getDuration() {
    Duration duration = _controller.value.duration;
    return duration.inMilliseconds.toDouble();
  }

  getPosition() {
    Duration position = _controller.value.position;
    double positionMilliseconds = position.inMilliseconds.toDouble();
    var duration = getDuration();
    return positionMilliseconds > duration ? duration : positionMilliseconds;
  }

  newTime(Offset o) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var position = o.dx;
    var relativePostition = position / deviceWidth;
    var duration = getDuration();
    var timeInDouble = duration * relativePostition;
    return timeInDouble.round();
  }

  updatePosition(double position) {
    setState(() {
      _controller.seekTo(new Duration(milliseconds: position.toInt()));
    });
  }

  _pickVideo(String videoPath) {
    setVideo('file', videoPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Use a FutureBuilder to display a loading spinner while waiting for the
        // VideoPlayerController to finish initializing.
        body: Container(
          constraints: BoxConstraints(
              maxHeight: deviceHeight(), maxWidth: deviceWidth()),
          child: Row(
            children: <Widget>[
              Expanded(
                child:VideoPlayerScreen(),
              )
            ],
          ),
        ),
        floatingActionButton: VideoSelector(
          selectedVideo: _pickVideo,
        ));
  }
}
