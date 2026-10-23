// NEGATIVE CONTROL — every block below must trigger its rule.
// Do NOT fix. Do NOT include in melos analyze.
import 'package:flutter/material.dart';

class Probe extends StatelessWidget {
  const Probe({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF000000), // no_hardcoded_colors
      decoration: BoxDecoration(color: Colors.red), // no_hardcoded_colors
      padding: const EdgeInsets.all(16), // no_numeric_spacing
      child: Column(
        children: [
          const Text('hard-coded', style: TextStyle(fontSize: 14)), // two rules
          const SizedBox(height: 8), // no_numeric_spacing
          const Icon(Icons.add), // no_material_icons
          Text('weight', style: const TextStyle().copyWith(), // no_banned_text_style-ish
              textAlign: TextAlign.left), // (script net)
        ],
      ),
    );
  }
}
