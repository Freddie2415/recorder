import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recorder/presentation/cubits/record/record_cubit.dart';

import '../presentation/cubits/records/records_cubit.dart';
import '../presentation/screens/home_screen.dart';
import '../service/record_service.dart';
import '../service/records_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Service
    final RecordsService recordsService = RecordsService();
    final RecordService recordService = RecordService();

    // Cubits

    final RecordCubit recordCubit = RecordCubit(service: recordService);
    final RecordsCubit recordsCubit = RecordsCubit(service: recordsService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => recordCubit),
        BlocProvider(create: (_) => recordsCubit),
      ],
      child: MaterialApp(
        title: 'Recorder',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
