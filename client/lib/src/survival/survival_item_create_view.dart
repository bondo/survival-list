import 'package:flutter/material.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list/src/survival/survival_item_create_form.dart';

/// Displays detailed information about a SurvivalItem.
class SurvivalItemCreateView extends StatelessWidget {
  const SurvivalItemCreateView({super.key});

  static const routeName = '/new';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pageItemCreateTitle),
      ),
      body: const SurvivalItemCreateForm(),
    );
  }
}
