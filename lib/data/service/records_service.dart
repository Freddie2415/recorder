import '../../presentation/storage/records_storage.dart';

import '../entity/record_entity.dart';

class RecordsService {
  final RecordsStorage storage = RecordsStorage();
  final List<RecordEntity> _recordList = [];

  addNewRecords({
    required Duration duration,
    required String path,
  }) {
    final index =
        _recordList.isEmpty ? _recordList.length + 1 : _recordList.last.id + 1;

    final entity = RecordEntity(
      id: index,
      title: "Record $index",
      createdAt: DateTime.now(),
      duration: duration,
      path: path,
    );

    _recordList.add(entity);

    saveToStorage(entity);
  }

  saveToStorage(RecordEntity entity) async {
    await storage.put(entity);
  }

  removeRecords({
    required int index,
  }) async {
    await storage.delete(index);
  }

  Future<List<RecordEntity>> getAllRecords() async {
    final data = await storage.get();

    if (data.isNotEmpty) {
      _recordList.clear();
      for (var element in data) {
        if (!_recordList.contains(element)) {
          _recordList.add(element);
        }
      }
    }

    return _recordList;
  }
}
