import 'package:record/record.dart';

class RecordService {
  final record = Record();

  void startRecording() async {
    if (await record.hasPermission()) {
      await record.start(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
      );
    }
  }

  void stopRecording({
    required Function(String) onStop,
  }) async {
    final String? path = await record.stop();

    if (path != null) {
      onStop(path);
    }
  }

  Future<bool> isRecording() async {
    return await record.isRecording();
  }
}
