import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../data/entity/record_entity.dart';

import '../cubits/records/records_cubit.dart';
import '../storage/records_storage.dart';
import '../widgets/empty_card_widget.dart';
import '../widgets/record_button_widget.dart';
import '../widgets/record_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = AudioPlayer();
  RecordEntity? currentRecord;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        excludeHeaderSemantics: true,
        backgroundColor: const Color(0xffF2F1F6),
        title: const Text("Recorder"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              RecordsStorage().deleteAll();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<RecordsCubit>(context).getAllRecords();
        },
        child: BlocBuilder<RecordsCubit, RecordsState>(
          builder: (context, state) {
            if (state is RecordsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is RecordsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.refresh_outlined),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            } else if (state is RecordsLoaded) {
              if (state.records.isEmpty) {
                return const EmptyCardWidget();
              }
              final record = state.records;

              return ListView.builder(
                itemCount: record.length,
                itemBuilder: (context, index) {
                  return RecordCardWidget(
                    active: currentRecord == record[index],
                    record: record[index],
                    onTap: () {
                      setState(() => currentRecord = record[index]);
                    },
                    onRemove: (removeIndex) {
                      BlocProvider.of<RecordsCubit>(context).removeRecords(
                        index: removeIndex,
                      );
                    },
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 130,
        decoration: BoxDecoration(color: const Color(0xffF2F1F6), boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, 1),
          ),
        ]),
        child: Center(
          child: SafeArea(
            child: RecordButtonWidget(
              onStop: (String path) async {
                final Duration? duration = await player.setUrl(path);

                if (mounted) {
                  BlocProvider.of<RecordsCubit>(context).addNewRecord(
                    duration: duration!,
                    path: path,
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
