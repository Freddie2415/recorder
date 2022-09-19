import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';

import '../../service/record_service.dart';
import '../cubits/record/record_cubit.dart';

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
  void initState() {
    listenRecorder();
    super.initState();
  }

  listenRecorder() async {
    isRecording = await RecordService().isRecording();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isRecording) {
          setState(() {
            isRecording = false;
          });
          BlocProvider.of<RecordCubit>(context)
              .stopRecording(onStop: widget.onStop);
        } else {
          setState(() {
            isRecording = true;
          });
          BlocProvider.of<RecordCubit>(context).startRecording();
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
            duration: const Duration(milliseconds: 300),
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
