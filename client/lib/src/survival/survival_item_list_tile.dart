import 'package:flutter/material.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list/src/survival/survival_item.dart';
import 'package:survival_list/src/survival/survival_item_details_view.dart';

class SurvivalItemListTile extends StatefulWidget {
  const SurvivalItemListTile({required this.item, super.key});

  final SurvivalItem item;

  @override
  State<SurvivalItemListTile> createState() => _SurvivalItemListTileState();
}

class _SurvivalItemListTileState extends State<SurvivalItemListTile> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return CheckboxListTile(
      title: Text(l10n.pageSurvivalItemTitle(widget.item.id)),
      value: widget.item.checked,
      onChanged: (bool? value) {
        setState(() {
          widget.item.checked = value!;
        });
      },
      secondary: GestureDetector(
        child: const CircleAvatar(
          // Display the Flutter Logo image asset.
          foregroundImage: AssetImage('assets/images/flutter_logo.png'),
        ),
        onTap: () {
          // Navigate to the details page. If the user leaves and returns to
          // the app after it has been killed while running in the
          // background, the navigation stack is restored.
          Navigator.restorablePushNamed(
            context,
            SurvivalItemDetailsView.routeName,
          );
        },
      ),
    );
  }
}
