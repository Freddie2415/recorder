import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';

class TestPlayerScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const TestPlayerScreen());

  const TestPlayerScreen({Key? key}) : super(key: key);

  @override
  State<TestPlayerScreen> createState() => _TestPlayerScreenState();
}

class _TestPlayerScreenState extends State<TestPlayerScreen> {
  Duration value = const Duration();

  final record = Record();
  final player = AudioPlayer();

  @override
  void initState() {
    listenController();
    super.initState();
  }

  listenController() {
    player.positionStream.listen((Duration position) {
      if (mounted) {
        setState(() {
          value = position;
          if (position == player.duration) {
            player.stop();
          }
        });
      }
    });
  }

  void startRecording() async {
    if (await record.hasPermission()) {
      await record.start(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
      );
    }
  }

  void stopRecording() async {
    final String? path = await record.stop();

    if (path != null) {
      await player.setUrl(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlayerProgressWidget(
              progressValue: value.inMilliseconds.toDouble(),
              onStopRecord: () {
                stopRecording();
              },
              onStartRecord: () {
                startRecording();
              },
              onSeek: (targetValue) {
                player.seek(Duration(milliseconds: targetValue.toInt()));

                print(value.toString());
              },
              maxValue: player.duration != null
                  ? player.duration!.inMilliseconds.toDouble()
                  : 0.0,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await player.play();
              },
              child: const Text('play'),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerProgressWidget extends StatefulWidget {
  final double progressValue;
  final VoidCallback onStopRecord;
  final VoidCallback onStartRecord;
  final double maxValue;
  final Function(double) onSeek;

  const PlayerProgressWidget({
    Key? key,
    this.progressValue = 0,
    required this.onStopRecord,
    required this.onStartRecord,
    required this.onSeek,
    required this.maxValue,
  }) : super(key: key);

  @override
  State<PlayerProgressWidget> createState() => _PlayerProgressWidgetState();
}

class _PlayerProgressWidgetState extends State<PlayerProgressWidget> {
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.red.shade200,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
          ),
          child: GestureDetector(
            onTap: () async {
              if (isRecording) {
                setState(() => isRecording = false);
                widget.onStopRecord.call();
              } else {
                setState(() => isRecording = true);
                widget.onStartRecord.call();
              }
            },
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xffD4212F),
                    Color(0xffF33E3E),
                  ],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: CircleAvatar(
                  backgroundColor:
                      isRecording ? Colors.white : const Color(0xffFF5F5F),
                  radius: 7,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.red.shade200,
              inactiveTrackColor: const Color(0xffF5F3EC),
              thumbColor: Colors.cyan,
              thumbSelector: (
                textDirection,
                values,
                tapValue,
                thumbSize,
                trackSize,
                dx,
              ) =>
                  Thumb.start,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 0,
                elevation: 0.0,
              ),
              trackHeight: 52,
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
              trackShape: const RectangularSliderTrackShape(),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              child: Slider(
                value: widget.progressValue,
                min: 0,
                max: widget.maxValue,
                onChanged: (double value) {
                  widget.onSeek.call(value);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
