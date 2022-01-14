import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
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
      // home: VideoPlayerDemo(),
      home: Reels(),
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
  bool centreLike = false;
  Map<String, VideoPlayerController> _controllers = {};
  Map<int, VoidCallback> _listeners = {};
  bool _lock = true;
  int indexx = 0;
  var current = 0;
  double _position = 0;
  double _buffer = 0;

  void _playController(int index) async {
    if (!_listeners.keys.contains(index)) {
      _listeners[index] = _listenerSpawner(index);
    }
    _controller(index)?.addListener(_listeners[index]!);
    await _controller(index)!.play();
    _controller(index)!.setLooping(true);
  }

  void _removeController(int index) {
    _controller(index)!.dispose();
    _controllers.remove(videos.elementAt(index));
    _listeners.remove(index);
  }

  void _stopController(int index) {
    _controller(index)!.removeListener(_listeners[index]!);
    _controller(index)!.pause();
    _controller(index)!.seekTo(Duration(milliseconds: 0));
  }

  void _previousVideo() {
    print('PREVIOUS');
    if (_lock || indexx == 0) {
      return;
    }
    _stopController(indexx);
    if (indexx + 1 < videos.length) {
      _removeController(indexx + 1);
    }
    _playController(--indexx);
    if (indexx == 0) {
      _lock = false;
    } else {
      _initController(indexx - 1).whenComplete(() => _lock = false);
    }
  }

  void _nextVideo() async {
    print('NEXT');
    if (_lock || indexx == videos.length - 1) {
      return;
    }
    _stopController(indexx);
    if (indexx - 1 >= 0) {
      _removeController(indexx - 1);
    }
    _playController(++indexx);
    if (indexx == videos.length - 1) {
      _lock = false;
    } else {
      _initController(indexx + 1);
    }
  }

  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    // initializePlayer(0);
    if (videos.length > 0) {
      _initController(0).then((_) {
        _playController(0);
      });
    }
    if (videos.length > 1) {
      _initController(1).whenComplete(() => _lock = false);
    }
  }
  VideoPlayerController? _controller(int index) {
    return _controllers[videos.elementAt(index)];
  }
  Future<void> _initController(int index) async {
    var controller = VideoPlayerController.network(videos.elementAt(index));
    _controllers[videos.elementAt(index)] = controller;
    await controller.initialize();
  }
  VoidCallback _listenerSpawner(index) {
    return () {
      int dur = _controller(index)!.value.duration.inMilliseconds;
      int pos = _controller(index)!.value.position.inMilliseconds;
      int buf = _controller(index)!.value.buffered.last.end.inMilliseconds;

      setState(() {
        if (dur <= pos) {
          _position = 0;
          return;
        }
        _position = pos / dur;
        print(_position);
        _buffer = buf / dur;
        print(_buffer);
      });
    };
  }
  // Future initializePlayer(int index) async {
  //   videoPlayerController = VideoPlayerController.network(videos.elementAt(index));
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
        child: Container(
          child: Stack(
            children: [
              Swiper(
                scrollDirection: Axis.vertical,
                itemCount: videos.length,
                loop: false,
                index: indexx,
                onIndexChanged: (i) {
                  if (i >= 0) {
                    if (i < indexx) {
                      print("previous");
                      _previousVideo();
                    } else {
                      print("next");
                      _nextVideo();
                    }
                  }  else if (i == videos.length - 1) {
                    print("previous");
                    _previousVideo();
                  }
                },
                itemHeight: MediaQuery.of(context).size.height,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: [
                          GestureDetector(
                              onDoubleTap: () {
                                setState(() {
                                  centreLike = !centreLike;
                                });
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                color: Colors.red,
                                // child: Chewie(controller: chewieController!)
                                child: VideoPlayer(_controller(index)!),
                              )),
                          Positioned(
                            bottom: 10,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 48,
                                        width: 48,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24.0),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 30.0),
                                    child: Icon(
                                      Icons.more_vert_rounded,
                                      color: Colors.white,
                                    ),
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
                  // return ContentScreen(srcLink: videos[index],);
                  // return Container();
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
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
