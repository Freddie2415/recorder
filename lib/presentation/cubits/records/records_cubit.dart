import 'package:bloc/bloc.dart';

import '../../../data/entity/record_entity.dart';
import '../../../data/service/records_service.dart';

part 'records_state.dart';

class RecordsCubit extends Cubit<RecordsState> {
  final RecordsService service;

  RecordsCubit({
    required this.service,
  }) : super(RecordsInitial());

  getAllRecords() async {
    emit(RecordsLoading());

    try {
      final records = await service.getAllRecords();

      emit(RecordsLoaded(records: records));
    } catch (error) {
      emit(RecordsError(error.toString()));
    }
  }

  addNewRecord({
    required Duration duration,
    required String path,
  }) {
    try {
      service.addNewRecords(
        duration: duration,
        path: path,
      );

      getAllRecords();
    } catch (error) {
      emit(RecordsError(error.toString()));
    }
  }

  deleteAllRecords() {
    try {
      service.deleteAll();
      getAllRecords();
    } catch (error) {
      emit(RecordsError(error.toString()));
    }
  }

  removeRecords({
    required int index,
  }) async {
    try {
      await service.removeRecords(
        index: index,
      );

      getAllRecords();
    } catch (error) {
      emit(RecordsError(error.toString()));
    }
  }
}
