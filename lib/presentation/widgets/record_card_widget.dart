import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../data/entity/record_entity.dart';
import '../utils/date_formatter.dart';
import '../utils/duration_formatter.dart';

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
          // curve: Curves.linear,
          duration: const Duration(milliseconds: 300),
          child: active
              ? _RecordCardActiveWidget(record: record)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                          DateFormatter.format(record.createdAt),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          DurationFormatter.format(record.duration),
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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.record.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          DateFormatter.format(widget.record.createdAt),
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
                  DurationFormatter.format(position),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  DurationFormatter.format(widget.record.duration),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
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
                    final Duration targetPosition =
                        position - const Duration(seconds: 5) <
                                const Duration(seconds: 0)
                            ? const Duration(seconds: 0)
                            : position - const Duration(seconds: 5);
                    player.seek(
                      targetPosition,
                    );
                  },
                  icon: const Icon(Icons.replay_5_rounded),
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: isPlaying ? _onPause : _onPlay,
                  icon: Icon(
                    !isPlaying ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  ),
                  iconSize: 40,
                ),
                IconButton(
                  onPressed: () {
                    final Duration targetPosition =
                        position + const Duration(seconds: 5) >
                                widget.record.duration
                            ? widget.record.duration
                            : position + const Duration(seconds: 5);
                    player.seek(
                      targetPosition,
                    );
                  },
                  icon: const Icon(Icons.forward_5_outlined),
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
      await player.setUrl(widget.record.path);
      await player.setVolume(1);
      player.play();
    } else {
      player.play();
    }
  }
}
