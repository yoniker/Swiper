import 'package:betabeta/constants/color_constants.dart';
import 'package:betabeta/services/aws_networking.dart';
import 'package:betabeta/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_timer/simple_timer.dart';
import 'package:tuple/tuple.dart';
import 'package:video_player/video_player.dart';

enum MorphingStatus { morphing, error, ready }

class ViewMorphScreen extends StatefulWidget {
  ViewMorphScreen({Key? key}) : super(key: key);
  final String celebImageUrl = Get
      .arguments['celeb_image_url']; //celeb_image/Diego Boneta/wiki_image.jpeg
  final String userFaceUrl = Get.arguments[
      'face_image_url']; //https://services.voilaserver.com/analyze-user-fr/fr_face_image/2BHZXM59SIb7vEfheLMIxY55zbN2/1656467868.7814832_2BHZXM59SIb7vEfheLMIxY55zbN2_96336.jpg/0
  @override
  State<ViewMorphScreen> createState() => _ViewMorphScreenState();
  static const String routeName = '/view_morphing_faces';
}

class _ViewMorphScreenState extends State<ViewMorphScreen> {
  MorphingStatus statusOfMorphing = MorphingStatus.morphing;
  String videoUrl = '';
  VideoPlayerController? _VideoPlayerController;
  @override
  void initState() {
    performMorphFaces();
    super.initState();
  }

  Future<void> performMorphFaces() async {
    Tuple2<ServerResponse, String?> resultOfMorphing = await AWSServer.instance
        .morphFaces(
            celebUrl: widget.celebImageUrl, userUrl: widget.userFaceUrl);
    var serverResponse = resultOfMorphing.item1;
    if (serverResponse == ServerResponse.Error) {
      setState(() {
        statusOfMorphing = MorphingStatus.error;
      });
      return;
    }

    videoUrl = resultOfMorphing.item2!;
    _VideoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          statusOfMorphing = MorphingStatus.ready;
        });
        _VideoPlayerController?.setLooping(true);
        _VideoPlayerController?.play();
      });
  }

  Widget _buildMorphinStatusWidget() {
    if (statusOfMorphing == MorphingStatus.morphing) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SimpleTimer(
          duration: Duration(milliseconds: 8500),
          status: TimerStatus.start,
          displayProgressText: false,
        ),
      );
    }

    if (statusOfMorphing == MorphingStatus.error) {
      return Text(
        'An error has occured at server,sorry!',
        style: TextStyle(color: Colors.red),
      );
    }

    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundThemeColor,
      appBar: CustomAppBar(
        elevation: 0,
        hasTopPadding: true,
        title: 'Morphing screen',
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(child: Center(child: _buildMorphinStatusWidget())),
                (_VideoPlayerController != null &&
                        _VideoPlayerController!.value.isInitialized)
                    ? AspectRatio(
                        aspectRatio: _VideoPlayerController!.value.aspectRatio,
                        child: VideoPlayer(_VideoPlayerController!))
                    : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
