import 'package:flutter/material.dart';
import '../widgets/VideoPlayerScreen.dart';
import 'package:golf_project/widgets/VideoSelectorRadial.dart';

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
  String _videoString = '';
  String _videoType = '';
  bool isErase = false;

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

  void _onEraseConfirmed(bool b) {
    setState(() {
      isErase = b;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                  height: 300,
                  child: DrawerHeader(
                    child: VideoSelectorRadial(
                      selectedVideo: _pickVideo,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                  )),
            ],
          ),
        ),
        body: new Builder(builder: (context) {
          return new Stack(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                    maxHeight: _deviceHeight(), maxWidth: _deviceWidth()),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: VideoPlayerScreen(
                        videoString: _videoString,
                        videoType: _videoType,
                        isErase: isErase,
                        eraseConfirmed: _onEraseConfirmed,
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                left: 20,
                top: 20,
                child: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              Positioned(
                  right: 20,
                  bottom: 20,
                  child: Column(
                    children: <Widget>[
                      Text('Erase'),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            isErase = true;
                          });
                        },
                      ),
                    ],
                  )),
            ],
          );
        }));
  }
}
