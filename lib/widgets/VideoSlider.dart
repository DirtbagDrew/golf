import 'package:flutter/material.dart';

class VideoSlider extends StatefulWidget {
  VideoSlider({
    Key key,
    @required this.onChanged,
    this.duration: 0,
    this.position: 0,
    this.visible: false,
  }) : super(key: key);

  final bool visible;
  final double duration;
  final double position;
  final ValueChanged<double> onChanged;

  _VideoSliderState createState() => _VideoSliderState();
}

class _VideoSliderState extends State<VideoSlider> {
  void updatePosition(double position) {
    widget.onChanged(position);
  }

  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: AnimatedOpacity(
        opacity: widget.visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: Container(
            color: Colors.black.withOpacity(.4),
            child: Slider(
                min: 0,
                max: widget.duration,
                value: widget.position,
                onChanged: (position) {
                  setState(() => updatePosition(position));
                })),
      ),
    );
  }
}
