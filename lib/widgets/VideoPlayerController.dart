import 'dart:async';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'VideoSlider.dart';

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VideoPlayerScreen();
  }
}

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  File _video;
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

// This funcion will helps you to pick a Video File
  _pickVideo(String source) async {
    File video = source == 'gallery'
        ? await ImagePicker.pickVideo(source: ImageSource.gallery)
        : await ImagePicker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      setState(() {
        _video = video;
        setVideo('file', _video.path);
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Use a FutureBuilder to display a loading spinner while waiting for the
        // VideoPlayerController to finish initializing.
        body: Container(
          constraints: BoxConstraints(
              maxHeight: deviceHeight(), maxWidth: deviceWidth()),
          child: Row(
            children: <Widget>[
              Expanded(
                child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the VideoPlayerController has finished initialization, use
                      // the data it provides to limit the aspect ratio of the video.
                      return Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: AlignmentDirectional.topCenter,
                              child: Stack(
                                alignment: AlignmentDirectional.bottomCenter,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _visible = !_visible;
                                      });
                                    },
                                    child: AspectRatio(
                                      aspectRatio:
                                          _controller.value.aspectRatio,
                                      // Use the VideoPlayer widget to display the video.
                                      child: VideoPlayer(_controller),
                                    ),
                                  ),
                                  VideoSlider(
                                    onChanged: updatePosition,
                                    position: getPosition(),
                                    duration: getDuration(),
                                    visible: _visible,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      // If the VideoPlayerController is still initializing, show a
                      // loading spinner.
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            ],
          ),
        ),

        floatingActionButton: SpeedDial(
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
        ),
      ),
      title: 'Video Player Demo',
    );
  }
}
