import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:reels_video_player_example/content_screen.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Reels(),
      // home: Reels(),
    );
  }
}

class Reels extends StatefulWidget {
  const Reels({Key? key}) : super(key: key);

  @override
  _ReelsState createState() => _ReelsState();
}

class _ReelsState extends State<Reels> {
  final List videos = [
    'https://leverageedunew.s3.amazonaws.com/leverageapp/brand-advocates/Vedhant%20Rusty.mp4',
    'https://leverageedunew.s3.amazonaws.com/leverageapp/brand-advocates/Sana%20Grover.mp4',
    'https://leverageedunew.s3.amazonaws.com/leverageapp/brand-advocates/Nitish%20Rajpute.mp4',
    'https://leverageedunew.s3.amazonaws.com/leverageapp/brand-advocates/Casslyn.mp4',
    'https://leverageedunew.s3.amazonaws.com/leverageapp/brand-advocates/Avanti%20Nagrai.mp4',
    'https://leverageedunew.s3.amazonaws.com/leverageapp/brand-advocates/Varun%20Sood.mp4'
  ];

  bool selectedLike = true;
  bool centreLike=false;




  // late VideoPlayerController videoPlayerController;
  // ChewieController? chewieController;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   initializePlayer();
  // }
  //
  // Future initializePlayer() async {
  //   videoPlayerController = VideoPlayerController.network(
  //       'https://leverageedunew.s3.amazonaws.com/leverageapp/brand-advocates/Sana%20Grover.mp4');
  //   await Future.wait([videoPlayerController.initialize()]);
  //
  //   chewieController = ChewieController(
  //     videoPlayerController: videoPlayerController,
  //     autoPlay: true,
  //     showControls: false,
  //     looping: true,
  //       allowFullScreen: true,
  //       // aspectRatio: 0.512,
  //       aspectRatio: 0.5,
  //
  //     // fullScreenByDefault: true,
  //     allowMuting: true
  //   );
  //   setState(() {});
  // }
  //
  // @override
  // void dispose() {
  //   videoPlayerController.dispose();
  //   chewieController!.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Container(
          // color: Colors.red,
          //padding: const EdgeInsets.only(top: 50.0),
          child: Stack(
            children: [
              Swiper(
                scrollDirection: Axis.vertical,
                itemCount: videos.length,
                // itemHeight:  MediaQuery.of(context).size.height,
                itemBuilder: (BuildContext context, int index) {
                  // return Container(
                  //     height: MediaQuery.of(context).size.height,
                  //     child: Stack(
                  //       // fit: StackFit.expand,
                  //       children: [
                  //         chewieController != null &&
                  //             chewieController!
                  //                 .videoPlayerController.value.isInitialized
                  //             ? GestureDetector(
                  //             onDoubleTap: () {
                  //               setState(() {
                  //                 centreLike = !centreLike;
                  //               });
                  //             },
                  //
                  //             child: Container(
                  //               height: MediaQuery.of(context).size.height,
                  //                 color: Colors.red,
                  //                 child: Chewie(controller: chewieController!)
                  //             )
                  //         )
                  //             : Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             CircularProgressIndicator(),
                  //             SizedBox(height: 10),
                  //             Text('Loading...')
                  //           ],
                  //         ),
                  //         Positioned(
                  //           bottom: 10,
                  //           child: Container(
                  //             width: MediaQuery.of(context).size.width,
                  //             margin: EdgeInsets.symmetric(horizontal: 16),
                  //             child: Row(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Row(
                  //                   children: [
                  //                     Container(
                  //                       height: 48,
                  //                       width: 48,
                  //                       decoration: BoxDecoration(
                  //                         borderRadius: BorderRadius.circular(24.0),
                  //                         color: Colors.blue,
                  //                       ),
                  //                     ),
                  //                     SizedBox(
                  //                       width: 16,
                  //                     ),
                  //                     Column(
                  //                       children: [
                  //                         Text(
                  //                           "shilpa_tyagi",
                  //                           style: TextStyle(
                  //                             fontWeight: FontWeight.w600,
                  //                             fontSize: 16,
                  //                             color: Colors.white,
                  //                           ),
                  //                         ),
                  //                         SizedBox(
                  //                           height: 5,
                  //                         ),
                  //                         Text(
                  //                           "112k Views",
                  //                           style: TextStyle(
                  //                             fontWeight: FontWeight.w400,
                  //                             fontSize: 12,
                  //                             color: Colors.white,
                  //                           ),
                  //                         ),
                  //
                  //                       ],
                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 Padding(
                  //                   padding: const EdgeInsets.only(right: 30.0),
                  //                   child: Icon(Icons.more_vert_rounded, color: Colors.white,),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //         Positioned(
                  //           right: 15,
                  //           bottom: 60,
                  //           child: Column(
                  //             children: [
                  //               Icon(
                  //                 Icons.favorite_outline_rounded,
                  //                 color: Colors.white,
                  //               ),
                  //               Text(
                  //                 "21.4k",
                  //                 style: TextStyle(
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 height: 18,
                  //               ),
                  //               Icon(
                  //                 Icons.message_outlined,
                  //                 color: Colors.white,
                  //               ),
                  //               Text(
                  //                 "200",
                  //                 style: TextStyle(
                  //                   color: Colors.white,
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 height: 18,
                  //               ),
                  //               Icon(
                  //                 Icons.share_rounded,
                  //                 color: Colors.white,
                  //               ),
                  //               SizedBox(
                  //                 height: 24,
                  //               ),
                  //             ],
                  //           ),
                  //         )
                  //       ],
                  //     ));
                  return ContentScreen(srcLink: videos[index],);
                },
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12),
                child: Icon(Icons.arrow_back_rounded, color: Colors.white,),
              )
            ],
          ),
        ),
      ),
    );
  }
}


/*
class HomeWidget extends StatefulWidget {
  const HomeWidget({
    required this.colors,
  });

  final List<String> colors;

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    videoPlayerController = VideoPlayerController.network(
        'https://leverageedunew.s3.amazonaws.com/leverageapp/brand-advocates/Sana%20Grover.mp4');
    await Future.wait([videoPlayerController.initialize()]);

    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        showControls: false,
        looping: true,
        allowFullScreen: true,
        // aspectRatio: 0.512,
        aspectRatio: 0.49,

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
    return Scaffold(
      body: SafeArea(
        child: TikTokStyleFullPageScroller(
          contentSize: widget.colors.length,
          swipePositionThreshold: 0.2,
          // ^ the fraction of the screen needed to scroll
          swipeVelocityThreshold: 2000,
          // ^ the velocity threshold for smaller scrolls
          animationDuration: const Duration(milliseconds: 300),
          // ^ how long the animation will take
          onScrollEvent: _handleCallbackEvent,
          // ^ registering our own function to listen to page changes
          builder: (BuildContext context, int index) {
            return Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  // fit: StackFit.expand,
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
                            width: MediaQuery.of(context).size.width,
                            // color: Colors.red,
                            child: Chewie(controller: chewieController!)
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
          },
        ),
      ),
    );
  }

  void _handleCallbackEvent(ScrollEventType type, {int? currentIndex}) {
    print(
        "Scroll callback received with data: {type: $type, and index: ${currentIndex ?? 'not given'}}");
  }
}*/
