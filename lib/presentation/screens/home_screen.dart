import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../data/entity/record_entity.dart';
import '../widgets/record_button_widget.dart';
import '../widgets/record_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = AudioPlayer();
  List<RecordEntity> records = [];
  RecordEntity? currentRecord;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: const Text("Recorder"), elevation: 0),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: records.map(
            (record) {
              return RecordCardWidget(
                active: currentRecord == record,
                onTap: () {
                  setState(() => currentRecord = record);
                },
                record: record,
              );
            },
          ).toList(),
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
                setState(() {
                  records.add(
                    RecordEntity(
                      title: "Record ${records.length + 1}",
                      createdAt: DateTime.now().toLocal(),
                      duration: duration ?? const Duration(),
                      path: path,
                    ),
                  );
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
