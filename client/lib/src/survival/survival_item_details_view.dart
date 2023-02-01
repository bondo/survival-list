import 'package:flutter/material.dart';

/// Displays detailed information about a SurvivalItem.
class SurvivalItemDetailsView extends StatelessWidget {
  const SurvivalItemDetailsView({super.key});

  static const routeName = '/survival_item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
