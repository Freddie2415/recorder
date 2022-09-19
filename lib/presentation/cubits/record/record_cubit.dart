import 'package:bloc/bloc.dart';

import '../../../data/service/record_service.dart';

part 'record_state.dart';

class RecordCubit extends Cubit<RecordState> {
  final RecordService service;

  RecordCubit({
    required this.service,
  }) : super(RecordInitial());

  startRecording() {
    try {
      service.startRecording();
    } catch (error) {
      emit(RecordError(error: error.toString()));
    }
  }

  stopRecording({
    required Function(String) onStop,
  }) {
    try {
      service.stopRecording(onStop: (path) => onStop(path));
    } catch (error) {
      emit(RecordError(error: error.toString()));
    }
  }

  isRecording() async {
    service.isRecording();
  }
}
