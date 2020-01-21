import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
  String _currentPosition = "";
  String _totalTime = "";

  changeVideo(String type, String videoString) {
    _controller.pause();

    if (type == 'file') {
      _controller = VideoPlayerController.file(new File(videoString))
        ..addListener(() {
          setState(() {
            _currentPosition =
                _controller.value.position?.inMicroseconds.toString() ?? "";
            _totalTime =
                _controller.value.duration?.inMicroseconds.toString() ?? "";
          });
        });
    } else if (type == 'asset') {
      _controller = VideoPlayerController.asset(videoString)
        ..addListener(() {
          setState(() {
            _currentPosition =
                _controller.value.position?.inMicroseconds.toString() ?? "";
            _totalTime =
                _controller.value.duration?.inMicroseconds.toString() ?? "";
          });
        });
    } else {
      _controller = VideoPlayerController.network(videoString)
        ..addListener(() {
          setState(() {
            _currentPosition =
                _controller.value.position?.inMicroseconds.toString() ?? "";
            _totalTime =
                _controller.value.duration?.inMicroseconds.toString() ?? "";
          });
        });
    }

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
        changeVideo('file', _video.path);
      });
    }
  }

  _scrobblerPosition() {
    return (double.parse(_currentPosition != null ? _currentPosition : 0.0) /
            double.parse(_totalTime != null ? _totalTime : 0.0) *
            2) -
        1;
  }

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.asset(
      'assets/tiger.mp4',
    )..addListener(() {
        setState(() {
          _currentPosition =
              _controller.value.position?.inMicroseconds.toString() ?? "";
          _totalTime =
              _controller.value.duration?.inMicroseconds.toString() ?? "";
        });
      });

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
    _controller.play();

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  newTime(Offset o) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var position = o.dx;
    var relativePostition = position / deviceWidth;
    var duration = _controller.value.duration.inMicroseconds.toDouble();
    var timeInDouble = duration * relativePostition;
    return timeInDouble.round();
  }

  handleDragCanceled(Offset o) {
    setState(() {
      _controller.seekTo(new Duration(microseconds: newTime(o)));
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
                          Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                // Use the VideoPlayer widget to display the video.
                                child: VideoPlayer(_controller),
                              ),
                              Align(
                                  alignment:
                                      Alignment(_scrobblerPosition(), -1.0),
                                  child: Draggable(
                                    onDraggableCanceled: (v, o) {
                                      handleDragCanceled(o);
                                    },
                                    child: Icon(
                                      Icons.golf_course,
                                      color: Colors.green,
                                      size: 30.0,
                                    ),
                                    feedback: Icon(
                                      Icons.golf_course,
                                      color: Colors.red,
                                      size: 30.0,
                                    ),
                                    axis: Axis.horizontal,
                                  )),
                            ],
                          ),
                        ],
                      );
                    } else {
                      // If the VideoPlayerController is still initializing, show a
                      // loading spinner.
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ), //here,)
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
