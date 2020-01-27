import 'dart:async';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'DrawingBoard.dart';
import 'VideoSlider.dart';

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen(
      {Key key,
      @required this.videoString,
      @required this.videoType,
      @required this.orientation})
      : super(key: key);

  final String videoString;
  final String videoType;
  final Orientation orientation;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool _visible = true;
  Future<void> _initializeVideoPlayerFuture;
  VideoPlayerController _controller;

  @override
  void initState() {
    setVideo(widget.videoType, widget.videoString);
    super.initState();
  }

  @override
  void didUpdateWidget(VideoPlayerScreen oldWidget) {
    if (oldWidget.videoString != widget.videoString ||
        oldWidget.videoType != widget.videoType) {
      setVideo(widget.videoType, widget.videoString);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  double deviceWidth() {
    return MediaQuery.of(context).size.width;
  }

  double getDuration() {
    Duration duration = _controller.value.duration;
    return duration.inMilliseconds.toDouble();
  }

  double getPosition() {
    Duration position = _controller.value.position;
    double positionMilliseconds = position.inMilliseconds.toDouble();
    var duration = getDuration();
    return positionMilliseconds > duration ? duration : positionMilliseconds;
  }

  void setVideo(String type, String videoString) {
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

    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);
    _controller.play();
  }

  void updatePosition(double position) {
    setState(() {
      _controller.seekTo(new Duration(milliseconds: position.toInt()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: AlignmentDirectional.center,
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
                          aspectRatio: _controller.value.aspectRatio,
                          // Use the VideoPlayer widget to display the video.
                          child: DrawingBoard(
                              child: VideoPlayer(_controller),
                              orientation: widget.orientation),
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
    );
  }
}
