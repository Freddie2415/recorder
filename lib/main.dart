import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recorder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class RecordItem {
  final String title;
  final String createdAt;
  final Duration duration;
  final String path;

  RecordItem({
    required this.title,
    required this.createdAt,
    required this.duration,
    required this.path,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final player = AudioPlayer();
  List<RecordItem> records = [];
  RecordItem? currentRecord;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: const Text("Recorder"), elevation: 0),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: records.map(
            (record) {
              return RecordPlayerItem(
                active: currentRecord == record,
                onTap: () {
                  setState(() => currentRecord = record);
                },
                record: record,
              );
            },
          ).toList(),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: RecordButton(
          onStop: (String path) async {
            final Duration? duration = await player.setUrl(path);
            // await player.setVolume(1);
            // await player.play();
            // await player.stop();

            setState(() {
              records.add(
                RecordItem(
                  title: "Record ${records.length + 1}",
                  createdAt: DateTime.now().toLocal().toString(),
                  duration: duration ?? const Duration(),
                  path: path,
                ),
              );
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}

class RecordPlayerItem extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  final RecordItem record;

  const RecordPlayerItem({
    Key? key,
    required this.active,
    required this.onTap,
    required this.record,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(15),
        color: Colors.white,
        child: active
            ? PlayerWidget(record: record)
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
    );
  }
}

class PlayerWidget extends StatefulWidget {
  final RecordItem record;

  const PlayerWidget({
    Key? key,
    required this.record,
  }) : super(key: key);

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  final AudioPlayer player = AudioPlayer();

  bool isPlaying = false;
  Duration position = const Duration();

  @override
  void initState() {
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

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    player.seek(Duration(milliseconds: position.inMilliseconds - 10000));
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
                    player.seek(Duration(milliseconds: position.inMilliseconds + 10000));
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

class RecordButton extends StatefulWidget {
  final void Function(String path) onStop;

  const RecordButton({
    Key? key,
    required this.onStop,
  }) : super(key: key);

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  bool isRecording = false;
  final record = Record();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isRecording ? _onStop : _onRecording,
      child: Container(
        color: Colors.grey.shade200,
        height: 150,
        child: Center(
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.grey,
                width: 3,
                // /Applications/Android Studio.app/Contents/plugins/gradle
              ),
            ),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isRecording ? 30 : 55,
                width: isRecording ? 30 : 55,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(isRecording ? 8 : 50),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onStop() async {
    // Stop recording
    final String? path = await record.stop();

    isRecording = await record.isRecording();

    setState(() {
      isRecording;
    });
    if (path != null) {
      widget.onStop(path);
    }
  }

  void _onRecording() async {
    // Check and request permission
    if (await record.hasPermission()) {
      // Start recording
      await record.start(
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
      );
    }

    // Get the state of the recorder
    isRecording = await record.isRecording();
    setState(() {
      isRecording;
    });
  }
}
