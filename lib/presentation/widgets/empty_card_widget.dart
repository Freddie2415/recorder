import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../cubits/records/records_cubit.dart';
import '../utils/assets.dart';

class EmptyCardWidget extends StatelessWidget {
  const EmptyCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              Assets.lottieEmpty,
            ),
            const Text(
              "Empty",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "no records found",
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<RecordsCubit>(context).getAllRecords();
              },
              child: const Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }
}
