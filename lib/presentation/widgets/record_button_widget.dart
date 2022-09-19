import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../cubits/record/record_cubit.dart';
import '../utils/assets.dart';

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
  final player = AudioPlayer();
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isRecording) {
          await player.setAsset(Assets.audioRemoveRecord);
          await player.play();
          setState(() => isRecording = false);
          if (mounted) {
            BlocProvider.of<RecordCubit>(context)
                .stopRecording(onStop: widget.onStop);
          }
        } else {
          await player.setAsset(Assets.audioRecord);
          await player.play();
          setState(() => isRecording = true);
          if (mounted) {
            BlocProvider.of<RecordCubit>(context).startRecording();
          }
        }
      },
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: const Color(0xff908F94),
            width: 3,
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 250),
            height: isRecording ? 30 : 57,
            width: isRecording ? 30 : 57,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade400,
              borderRadius: BorderRadius.circular(isRecording ? 8 : 50),
            ),
          ),
        ),
      ),
    );
  }
}
