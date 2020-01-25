import 'package:flutter/material.dart';
import 'package:golf_project/widgets/DrawingBoardPainter.dart';

class DrawingBoard extends StatefulWidget {
  DrawingBoard({Key key, @required this.child}) : super(key: key);
  Widget child;
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  final _offsets = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanDown: (details) {
          setState(() {
            final renderBox = context.findRenderObject() as RenderBox;
            final localPosition =
                renderBox.globalToLocal(details.globalPosition);
            _offsets.add(localPosition);
          });
        },
        onPanUpdate: (details) {
          setState(() {
            final renderBox = context.findRenderObject() as RenderBox;
            final localPosition =
                renderBox.globalToLocal(details.globalPosition);
            _offsets.add(localPosition);
          });
        },
        onPanEnd: (details) {
          setState(() {
            _offsets.add(null);
          });
        },
        child: Stack(
          children: <Widget>[
            widget.child,
            CustomPaint(
              painter: DrawingBoardPainter(_offsets),
              child: Container(),
            ),
          ],
        ));
  }
}
