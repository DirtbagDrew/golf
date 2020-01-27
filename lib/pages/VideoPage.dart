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
      appBar: AppBar(title: Text('sup')),
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
                    color: Colors.blue,
                  ),
                )),
            ListTile(
              title: Text('hi'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Container(
            constraints: BoxConstraints(
                maxHeight: _deviceHeight(), maxWidth: _deviceWidth()),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: VideoPlayerScreen(
                    videoString: _videoString,
                    videoType: _videoType,
                    orientation: orientation,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
