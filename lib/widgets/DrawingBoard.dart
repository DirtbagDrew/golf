import 'package:flutter/material.dart';
import 'package:golf_project/widgets/DrawingBoardPainter.dart';

class DrawingBoard extends StatefulWidget {
  DrawingBoard({Key key, @required this.child, @required this.orientation})
      : super(key: key);
  Widget child;
  Orientation orientation;
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  var _offsets = <Offset>[];
  var _boardPortraitWidth = 0.0;
  var _boardPortraitHeight = 0.0;
  var _boardLandscapeWidth = 0.0;
  var _boardLandscapeHeight = 0.0;
  var _currentOrientation;

  bool _isValidOffset(Offset offset, Size size) {
    return offset.dx >= 0 &&
        offset.dx <= size.width &&
        offset.dy >= 0 &&
        offset.dy <= size.height;
  }

  _orientationChangePortrait(BoxConstraints boxConstraints) {
    _boardPortraitWidth = boxConstraints.maxWidth;
    _boardPortraitHeight = boxConstraints.maxHeight;
    if (_boardLandscapeWidth != 0.0 &&
        _boardLandscapeHeight != 0.0 &&
        _offsets.length != 0) {
      _offsets = _offsets.map((offset) {
        if (offset != null) {
          var dx = offset.dx * _boardPortraitWidth / _boardLandscapeWidth;
          var dy = offset.dy * _boardPortraitHeight / _boardLandscapeHeight;
          return Offset(dx, dy);
        }
        return null;
      }).toList();
    }
  }

  _orientationChangeLandscape(BoxConstraints boxConstraints) {
    if (_boardLandscapeWidth == 0.0 && _boardLandscapeHeight == 0.0) {
      _boardLandscapeWidth = boxConstraints.maxWidth;
      _boardLandscapeHeight = boxConstraints.maxHeight;
    }
    if (_boardPortraitWidth != 0.0 &&
        _boardPortraitHeight != 0.0 &&
        _offsets.length != 0) {
      _offsets = _offsets.map((offset) {
        if (offset != null) {
          var dx = offset.dx * _boardLandscapeWidth / _boardPortraitWidth;
          var dy = offset.dy * _boardLandscapeHeight / _boardPortraitHeight;
          return Offset(dx, dy);
        }
        return null;
      }).toList();
    }
  }

  _handleOrientationChange(BoxConstraints boxConstraints) {
    if (widget.orientation != _currentOrientation) {
      _currentOrientation = widget.orientation;
      if (widget.orientation == Orientation.portrait) {
        _orientationChangePortrait(boxConstraints);
      } else {
        _orientationChangeLandscape(boxConstraints);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (buildContext, context) {
        _handleOrientationChange(context);
        return GestureDetector(
            onPanDown: (details) {
              setState(() {
                final renderBox = buildContext.findRenderObject() as RenderBox;
                final localPosition =
                    renderBox.globalToLocal(details.globalPosition);
                if (_isValidOffset(localPosition, renderBox.size))
                  _offsets.add(localPosition);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                final renderBox = buildContext.findRenderObject() as RenderBox;
                final localPosition =
                    renderBox.globalToLocal(details.globalPosition);
                if (_isValidOffset(localPosition, renderBox.size)) {
                  _offsets.add(localPosition);
                }
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
      },
    );
  }
}
