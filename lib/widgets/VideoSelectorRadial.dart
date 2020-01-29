import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

class VideoSelectorRadial extends StatefulWidget {
  VideoSelectorRadial({Key key, @required this.selectedVideo})
      : super(key: key);
  final ValueChanged<String> selectedVideo;

  @override
  State<StatefulWidget> createState() {
    return _VideoSelectorRadialState();
  }
}

class _VideoSelectorRadialState extends State<VideoSelectorRadial>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 900), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return RadialAnimation(
      controller: controller,
      selectedVideo: widget.selectedVideo,
    );
  }
}

class RadialAnimation extends StatefulWidget {
  RadialAnimation({Key key, this.controller, @required this.selectedVideo})
      : scale = Tween<double>(begin: 1, end: 0.0).animate(
          (CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn)),
        ),
        translation = Tween<double>(begin: 0.0, end: 100.0).animate(
          CurvedAnimation(parent: controller, curve: Curves.elasticOut),
        ),
        rotation = Tween<double>(begin: 0.0, end: 360.0).animate(
            CurvedAnimation(
                parent: controller,
                curve: Interval(0.0, 0.7, curve: Curves.decelerate))),
        super(key: key);
  final Animation<double> rotation;
  final Animation<double> scale;
  final Animation<double> translation;
  final AnimationController controller;
  final ValueChanged<String> selectedVideo;

  @override
  _RadialAnimationState createState() => _RadialAnimationState();
}

class _RadialAnimationState extends State<RadialAnimation> {
  bool _isShowText = true;
  String _label = 'Select video option';

  build(context) {
    return AnimatedBuilder(
        animation: widget.controller,
        builder: (context, builder) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment(0, -.5),
                child: _isShowText ? Text(_label) : null,
              ),
              Container(
                height: 300,
                width: 300,
                child: Transform.rotate(
                    angle: VectorMath.radians(widget.rotation.value),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        _buildButton(270,
                            color: Colors.red,
                            icon: Icons.video_library,
                            source: 'gallery'),
                        _buildButton(150,
                            color: Colors.blue,
                            icon: Icons.videocam,
                            source: 'camera'),
                        _buildButton(
                          30,
                          color: Colors.yellow,
                          icon: FontAwesomeIcons.youtube,
                          source: 'camera',
                        ),
                        Transform.scale(
                            scale: widget.scale.value - 1,
                            child: Transform.rotate(
                              angle: VectorMath.radians(180),
                              child: FloatingActionButton(
                                child: Icon(Icons.cancel),
                                onPressed: _close,
                                backgroundColor: Colors.red,
                              ),
                            )),
                        Transform.scale(
                          scale: widget.scale.value,
                          child: FloatingActionButton(
                            child: Icon(Icons.add_circle),
                            onPressed: _open,
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      ],
                    )),
              )
            ],
          );
        });
  }

  Widget _buildButton(double angle,
      {Color color, IconData icon, String source}) {
    final double rad = VectorMath.radians(angle);
    return Container(
      child: Transform(
        transform: Matrix4.identity()
          ..translate((widget.translation.value) * cos(rad),
              (widget.translation.value) * sin(rad)),
        child: FloatingActionButton(
            child: Icon(icon),
            backgroundColor: color,
            onPressed: () {
              _pickVideo(source);
            }),
      ),
    );
  }

  void _close() {
    _isShowText = true;
    widget.controller.reverse();
  }

  void _open() {
    _isShowText = false;
    widget.controller.forward();
  }

  void _pickVideo(String source) async {
    _close();
    File video = source == 'gallery'
        ? await ImagePicker.pickVideo(source: ImageSource.gallery)
        : await ImagePicker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      widget.selectedVideo(video.path);
    }
  }
}
