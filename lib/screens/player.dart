import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast/screens/bottomNavigation.dart';

class PodcastPlayer extends StatefulWidget {
  final String? title;
  final String? image;
  final String? audio;
  final String? artist;

  const PodcastPlayer(
      {Key? key, this.title, this.artist, this.audio, this.image})
      : super(key: key);

  @override
  State<PodcastPlayer> createState() => _PodcastPlayerState();
}

class _PodcastPlayerState extends State<PodcastPlayer> {
  late final PageManager _pageManager;
  @override
  void initState() {
    String url = '${widget.audio}';
    _pageManager = PageManager(url);
    _pageManager._init(url);
    super.initState();
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.clear,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const BottomNavigationWidget(),
                  ),
                  (route) => false);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // const Spacer(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 300,
                    width: 300,
                    child: Image.network('${widget.image}'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(55, 10, 0, 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ListTile(
                    title: Text(
                      '${widget.title}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        '${widget.artist}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder<ProgressBarState>(
                valueListenable: _pageManager.progressNotifier,
                builder: (_, value, __) {
                  return ProgressBar(
                    progress: value.current,
                    buffered: value.buffered,
                    total: value.total,
                    onSeek: _pageManager.seek,
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ValueListenableBuilder<RepeatState>(
                    valueListenable: _pageManager.repeatButtonNotifier,
                    builder: (context, value, child) {
                      Icon icon;
                      switch (value) {
                        case RepeatState.off:
                          icon = Icon(Icons.repeat, color: Colors.grey);
                          break;
                        case RepeatState.repeatSong:
                          icon = Icon(Icons.repeat_one);
                          break;
                      }
                      return IconButton(
                        icon: icon,
                        onPressed: _pageManager.onRepeatButtonPressed,
                      );
                    },
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  ValueListenableBuilder<ButtonState>(
                    valueListenable: _pageManager.buttonNotifier,
                    builder: (_, value, __) {
                      switch (value) {
                        case ButtonState.loading:
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            width: 32.0,
                            height: 32.0,
                            child: const CircularProgressIndicator(),
                          );
                        case ButtonState.paused:
                          return IconButton(
                            icon: const Icon(Icons.play_arrow),
                            iconSize: 32.0,
                            onPressed: _pageManager.play,
                          );
                        case ButtonState.playing:
                          return IconButton(
                            icon: const Icon(Icons.pause),
                            iconSize: 32.0,
                            onPressed: _pageManager.pause,
                          );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  //   return SafeArea(
  //     child: Scaffold(
  //       appBar: AppBar(
  //         leading: IconButton(
  //           icon: const Icon(
  //             Icons.keyboard_arrow_down_outlined,
  //             size: 40,
  //           ),
  //           onPressed: () {},
  //         ),
  //         backgroundColor: Colors.transparent,
  //         elevation: 0.0,
  //         iconTheme: const IconThemeData(
  //           color: Colors.black,
  //         ),
  //       ),
  //       body: Column(
  //         children: [
  //           Center(
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Container(
  //                 height: 300,
  //                 width: 300,
  //                 child: Image.network('${widget.image}'),
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(55, 10, 0, 10),
  //             child: Align(
  //               alignment: Alignment.topLeft,
  //               child: ListTile(
  //                 title: Text(
  //                   '${widget.title}',
  //                   style: const TextStyle(fontSize: 20),
  //                 ),
  //                 subtitle: Padding(
  //                   padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
  //                   child: Text(
  //                     '${widget.artist}',
  //                     style: const TextStyle(fontSize: 15),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Center(
  //               child: Column(
  //             children: [
  //               Icon(Icons.play_arrow),
  //             ],
  //           )),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class PageManager {
  final repeatButtonNotifier = RepeatButtonNotifier();
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  // static const url =
  //     'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';

  late AudioPlayer _audioPlayer;

  String? url;
  PageManager(url) {
    _init(url);
  }

  void _init(url) async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setUrl(url);
    play();
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  void onRepeatButtonPressed() {
    repeatButtonNotifier.nextState();
    switch (repeatButtonNotifier.value) {
      case RepeatState.off:
        _audioPlayer.setLoopMode(LoopMode.off);
        break;
      case RepeatState.repeatSong:
        _audioPlayer.setLoopMode(LoopMode.one);
        break;
    }
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }

class RepeatButtonNotifier extends ValueNotifier<RepeatState> {
  RepeatButtonNotifier() : super(_initialValue);
  static const _initialValue = RepeatState.off;

  void nextState() {
    final next = (value.index + 1) % RepeatState.values.length;
    value = RepeatState.values[next];
  }
}

enum RepeatState {
  off,
  repeatSong,
}
