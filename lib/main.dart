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
  bool centreLike=false;
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
    // setState(() {});
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

//gaurav
  void _previousVideo() {
    print('PREVIOUS');
    if (_lock || indexx == 0) {
      return;
    }
     //_lock = true;


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
    // _lock = true;

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
        print('Position');
        print(_position);
        _buffer = buf / dur;
        print('Buffer');
        print(_buffer);
      });
      // if (dur - pos < 1) {
      //   if (index < _urls.length - 1) {
      //     _nextVideo();
      //   }
      // }
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
          // color: Colors.red,
          //padding: const EdgeInsets.only(top: 50.0),
          child: Stack(
            children: [
              Swiper(
                scrollDirection: Axis.vertical,
                itemCount: videos.length,
                loop: false,
                index: indexx,
                onIndexChanged: (i) {
                  if (i > 0 ) {
                    if (i < indexx) {
                      print("previous");
                      _previousVideo();
                    } else {
                      print("next");
                      _nextVideo();
                    }
                  } else if (i == 0) {
                    if (videos.length > 0) {
                      _initController(0).then((_) {
                        _playController(0);
                      });
                    }

                    if (videos.length > 1) {
                      _initController(1).whenComplete(() => _lock = false);
                    }
                  }else if(i==videos.length-1){
                    print("previous");
                    _previousVideo();
                  }
                },
                itemHeight:  MediaQuery.of(context).size.height,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        // fit: StackFit.expand,
                        children: [
                          /*chewieController != null &&
                              chewieController!
                                  .videoPlayerController.value.isInitialized
                              ?*/ GestureDetector(
                              onDoubleTap: () {
                                setState(() {
                                  centreLike = !centreLike;
                                });
                              },

                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                  color: Colors.red,
                                  // child: Chewie(controller: chewieController!)
                                child: VideoPlayer(_controller(index)! ),
                              )
                          ),
                          //     : Column(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     CircularProgressIndicator(),
                          //     SizedBox(height: 10),
                          //     Text('Loading...')
                          //   ],
                          // ),
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
                  // return ContentScreen(srcLink: videos[index],);
                  // return Container();
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

/*
class VideoPlayerDemo extends StatefulWidget {
  @override
  _VideoPlayerDemoState createState() => _VideoPlayerDemoState();
}

class _VideoPlayerDemoState extends State<VideoPlayerDemo> {
  int index = 0;
  double _position = 0;
  double _buffer = 0;
  bool _lock = true;
  Map<String, VideoPlayerController> _controllers = {};
  Map<int, VoidCallback> _listeners = {};
  Set<String> _urls = {
    'https://leverageedunew.s3.amazonaws.com/leverageapp/brand-advocates/Vedhant%20Rusty.mp4',
    'https://leverageedunew.s3.amazonaws.com/leverageapp/brand-advocates/Sana%20Grover.mp4',
    'https://leverageedunew.s3.amazonaws.com/leverageapp/brand-advocates/Nitish%20Rajpute.mp4',
    'https://leverageedunew.s3.amazonaws.com/leverageapp/brand-advocates/Casslyn.mp4',
    'https://leverageedunew.s3.amazonaws.com/leverageapp/brand-advocates/Avanti%20Nagrai.mp4',
    'https://leverageedunew.s3.amazonaws.com/leverageapp/brand-advocates/Varun%20Sood.mp4'
  };

  @override
  void initState() {
    super.initState();

    if (_urls.length > 0) {
      _initController(0).then((_) {
        _playController(0);
      });
    }

    if (_urls.length > 1) {
      _initController(1).whenComplete(() => _lock = false);
    }
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
        print('Position');
        print(_position);
        _buffer = buf / dur;
        print('Buffer');
        print(_buffer);
      });
      // if (dur - pos < 1) {
      //   if (index < _urls.length - 1) {
      //     _nextVideo();
      //   }
      // }
    };
  }

  VideoPlayerController? _controller(int index) {
    return _controllers[_urls.elementAt(index)];
  }

  Future<void> _initController(int index) async {
    var controller = VideoPlayerController.network(_urls.elementAt(index));
    _controllers[_urls.elementAt(index)] = controller;
    await controller.initialize();
  }

  void _removeController(int index) {
    _controller(index)!.dispose();
    _controllers.remove(_urls.elementAt(index));
    _listeners.remove(index);
  }

  void _stopController(int index) {
    _controller(index)!.removeListener(_listeners[index]!);
    _controller(index)!.pause();
    _controller(index)!.seekTo(Duration(milliseconds: 0));
  }

  void _playController(int index) async {
    if (!_listeners.keys.contains(index)) {
      _listeners[index] = _listenerSpawner(index);
    }
    _controller(index)!.addListener(_listeners[index]!);
    await _controller(index)!.play();
    // setState(() {});
  }



  void _previousVideo() {
    if (_lock || index == 0) {
      return;
    }
    _lock = true;

    _stopController(index);

    if (index + 1 < _urls.length) {
      _removeController(index + 1);
    }

    _playController(--index);

    if (index == 0) {
      _lock = false;
    } else {
      _initController(index - 1).whenComplete(() => _lock = false);
    }
  }

  void _nextVideo() async {
    if (_lock || index == _urls.length - 1) {
      return;
    }
    // _lock = true;

    _stopController(index);

    // if (index - 1 >= 0) {
    //   _removeController(index - 1);
    // }

    _playController(++index);

    if (index == _urls.length - 1) {
      _lock = false;
    } else {
      _initController(index + 1).whenComplete(() => _lock = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Playing ${index + 1} of ${_urls.length}"),
        actions: [IconButton(onPressed: (){
          showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              enableDrag: true,
              isDismissible: true,
              useRootNavigator: true,
              builder: (_) => Container(
                  height: 50,
                  color: Colors.white,
                  child: TextField()
              ));
        }, icon: Icon(Icons.keyboard_arrow_up_rounded))],
      ),
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onLongPressStart: (_) => _controller(index)!.pause(),
            onLongPressEnd: (_) => _controller(index)!.play(),
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller(index)!.value.aspectRatio,
                child: Center(child: VideoPlayer(_controller(index)! )),
              ),
            ),
          ),
          Positioned(
            child: Container(
              height: 10,
              width: MediaQuery.of(context).size.width * _buffer,
              color: Colors.grey,
            ),
          ),
          Positioned(
            child: Container(
              height: 10,
              width: MediaQuery.of(context).size.width * _position,
              color: Colors.greenAccent,
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(onPressed: _previousVideo, child: Icon(Icons.arrow_back)),
          SizedBox(width: 24),
          FloatingActionButton(onPressed: _nextVideo, child: Icon(Icons.arrow_forward)),
        ],
      ),
    );
  }
}*/
