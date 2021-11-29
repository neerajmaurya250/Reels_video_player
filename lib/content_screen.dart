import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ContentScreen extends StatefulWidget {
  final String? srcLink;
  const ContentScreen({Key? key, this.srcLink}) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.srcLink.toString());
    await Future.wait([videoPlayerController.initialize()]);
    videoPlayerController.setLooping(true);

    videoPlayerController.play();

    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        showControls: false,
        looping: true,
        allowFullScreen: true,
        // aspectRatio: 0.512,
        // aspectRatio: 0.5,

        // fullScreenByDefault: true,
        allowMuting: true
    );
    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            chewieController != null &&
                chewieController!
                    .videoPlayerController.value.isInitialized
                ? GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    // centreLike = !centreLike;
                  });
                },

                child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.red,
                    child: VideoPlayer(videoPlayerController)
                    // child: Chewie(controller: chewieController!)
                )
            )
              : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Loading...')
              ],
            ),
            Positioned(
              bottom: 10,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Column(
                          children: [
                            Text(
                              "shilpa_tyagi",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "112k Views",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),

                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: Icon(Icons.more_vert_rounded, color: Colors.white,),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              right: 15,
              bottom: 60,
              child: Column(
                children: [
                  Icon(
                    Icons.favorite_outline_rounded,
                    color: Colors.white,
                  ),
                  Text(
                    "21.4k",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Icon(
                    Icons.message_outlined,
                    color: Colors.white,
                  ),
                  Text(
                    "200",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Icon(
                    Icons.share_rounded,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
