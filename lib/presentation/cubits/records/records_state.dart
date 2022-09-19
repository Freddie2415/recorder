part of 'records_cubit.dart';

abstract class RecordsState {}

class RecordsInitial extends RecordsState {}

class RecordsError extends RecordsState {
  final String message;

  RecordsError(this.message);
}

class RecordsLoading extends RecordsState {}

class RecordsEmpty extends RecordsState {}

class RecordsLoaded extends RecordsState {
  final List<RecordEntity> records;

  RecordsLoaded({required this.records});
}
