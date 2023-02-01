import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'survival_item_create_form.dart';

/// Displays detailed information about a SurvivalItem.
class SurvivalItemCreateView extends StatelessWidget {
  const SurvivalItemCreateView({super.key});

  static const routeName = '/new';

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pageItemCreateTitle),
      ),
      body: const SurvivalItemCreateForm(),
    );
  }
}
