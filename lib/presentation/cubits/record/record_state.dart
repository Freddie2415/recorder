part of 'record_cubit.dart';

abstract class RecordState {}

class RecordInitial extends RecordState {}

class RecordSaved extends RecordState {}

class RecordError extends RecordState {
  final String error;

  RecordError({required this.error});
}
