import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../data/entity/record_entity.dart';

class RecordCardWidget extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  final RecordEntity record;

  const RecordCardWidget({
    Key? key,
    required this.active,
    required this.onTap,
    required this.record,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        color: Colors.white,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: active
              ? _RecordCardActiveWidget(record: record)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          record.createdAt,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          record.duration.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 0),
                  ],
                ),
        ),
      ),
    );
  }
}

class _RecordCardActiveWidget extends StatefulWidget {
  final RecordEntity record;

  const _RecordCardActiveWidget({
    Key? key,
    required this.record,
  }) : super(key: key);

  @override
  State<_RecordCardActiveWidget> createState() =>
      _RecordCardActiveWidgetState();
}

class _RecordCardActiveWidgetState extends State<_RecordCardActiveWidget> {
  final AudioPlayer player = AudioPlayer();

  bool isPlaying = false;
  Duration position = const Duration();

  @override
  void initState() {
    listenPlayer();
    super.initState();
  }

  listenPlayer() {
    player.playerStateStream.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          isPlaying = state.playing;
        });
      }
    });
    player.positionStream.listen((Duration position) {
      if (mounted) {
        setState(() {
          this.position = position;
          if (position == widget.record.duration) {
            isPlaying = false;
            player.stop();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "widget.record.title",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          widget.record.createdAt,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 5,
                thumbShape: const RoundSliderThumbShape(
                  elevation: 0,
                  enabledThumbRadius: 7,
                  disabledThumbRadius: 7,
                  pressedElevation: 0,
                ),
              ),
              child: Slider(
                value: position.inMilliseconds.toDouble(),
                min: 0,
                max: widget.record.duration.inMilliseconds.toDouble(),
                onChanged: (value) {
                  player.seek(Duration(milliseconds: value.toInt()));
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  position.toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  widget.record.duration.toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.ios_share, color: Colors.blue),
              iconSize: 30,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    player.seek(Duration(
                        milliseconds: position.inMilliseconds - 10000));
                  },
                  icon: const Icon(Icons.replay_10),
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: isPlaying ? _onPause : _onPlay,
                  icon: Icon(!isPlaying ? Icons.play_arrow : Icons.pause),
                  iconSize: 40,
                ),
                IconButton(
                  onPressed: () {
                    player.seek(Duration(
                        milliseconds: position.inMilliseconds + 10000));
                  },
                  icon: const Icon(Icons.forward_10),
                  iconSize: 30,
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete, color: Colors.blue),
              iconSize: 30,
            ),
          ],
        ),
        const Divider(height: 0),
      ],
    );
  }

  void _onPause() async {
    await player.pause();
  }

  void _onPlay() async {
    if (player.playerState.processingState == ProcessingState.idle) {
      final Duration? duration = await player.setUrl(widget.record.path);
      await player.setVolume(1);
      player.play();
    } else {
      player.play();
    }
  }
}
