import '../data/entity/record_entity.dart';

class RecordsService {
  final List<RecordEntity> _recordList = [];

  addNewRecords({
    required Duration duration,
    required String path,
  }) {
    final index = _recordList.isEmpty
        ? _recordList.length + 1
        : _recordList.last.index + 1;

    _recordList.add(
      RecordEntity(
        index: index,
        title: "Record $index",
        createdAt: DateTime.now().toLocal(),
        duration: duration,
        path: path,
      ),
    );
  }

  removeRecords({
    required int index,
  }) {
    _recordList.removeWhere(
      (element) => element.index == index,
    );
  }

  List<RecordEntity> getAllRecords() {
    return _recordList;
  }
}
