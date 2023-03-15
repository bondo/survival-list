import 'package:flutter/material.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list/settings/settings_view.dart';
import 'package:survival_list/src/survival/survival_item.dart';
import 'package:survival_list/src/survival/survival_item_create_view.dart';
import 'package:survival_list/src/survival/survival_item_list_tile.dart';

class SurvivalItemListView extends StatelessWidget {
  const SurvivalItemListView({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // final itemsContainer =
    //     Provider.of<SurvivalItemListRefetchContainer>(context);
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
            context,
            SurvivalItemCreateView.routeName,
          );
        },
        child: const Icon(Icons.add),
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: FutureBuilder<List<SurvivalItem>>(
        future: Future.value(const []), // itemsContainer.future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              // itemsContainer.refetch()
            },
            child: ListView.builder(
              // Providing a restorationId allows the ListView to restore the
              // scroll position when a user leaves and returns to the app after
              // it has been killed while running in the background.
              restorationId: 'survivalItemListView',
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return SurvivalItemListTile(
                  item: items[index],
                );
              },
            ),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.check_box),
            label: l10n.bottomNavigationIconLabelSurvival,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: l10n.bottomNavigationIconLabelTodo,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.bottomNavigationIconLabelSchedule,
          ),
        ],
        onTap: (int index) {},
      ),
    );
  }
}
