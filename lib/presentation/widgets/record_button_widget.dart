import 'package:flutter/material.dart';
import 'package:record/record.dart';

class RecordButtonWidget extends StatefulWidget {
  final void Function(String path) onStop;

  const RecordButtonWidget({
    Key? key,
    required this.onStop,
  }) : super(key: key);

  @override
  State<RecordButtonWidget> createState() => _RecordButtonWidgetState();
}

class _RecordButtonWidgetState extends State<RecordButtonWidget> {
  bool isRecording = false;
  final record = Record();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: const Color(0xff908F94),
          width: 3,
          // /Applications/Android Studio.app/Contents/plugins/gradle
        ),
      ),
      child: Center(
        child: GestureDetector(
          onTap: isRecording ? _onStop : _onRecording,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isRecording ? 30 : 57,
            width: isRecording ? 30 : 57,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(isRecording ? 8 : 50),
            ),
          ),
        ),
      ),
    );
  }

  void _onStop() async {
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
    if (await record.hasPermission()) {
      await record.start(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
      );
    }

    // Get the state of the recorder
    isRecording = await record.isRecording();
    setState(() {
      isRecording;
    });
  }
}
