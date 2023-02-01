import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../settings/settings_view.dart';
import 'survival_item.dart';
import 'survival_item_create_view.dart';
import 'survival_item_list_tile.dart';

/// Displays a list of SurvivalItems.
class SurvivalItemListView extends StatelessWidget {
  const SurvivalItemListView({super.key, required this.items});

  static const routeName = '/';

  final List<SurvivalItem> items;

  @override
  Widget build(BuildContext context) {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pageSurvivalTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.restorablePushNamed(
                context, SurvivalItemCreateView.routeName);
          },
          child: const Icon(Icons.add)),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'survivalItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return SurvivalItemListTile(
            item: items[index],
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(Icons.check_box),
              label: l10n.bottomNavigationIconLabelSurvival),
          BottomNavigationBarItem(
              icon: const Icon(Icons.list),
              label: l10n.bottomNavigationIconLabelTodo),
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: l10n.bottomNavigationIconLabelSchedule),
        ],
        currentIndex: 0,
        onTap: (int index) {},
      ),
    );
  }
}
