// EdgeInsets isolation probe.
import 'package:flutter/material.dart';

class Probe2 extends StatelessWidget {
  const Probe2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          margin: const EdgeInsets.only(left: 4),
          child: const Text('x'),
        ),
      ),
    );
  }
}
