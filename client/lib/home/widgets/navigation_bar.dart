import 'package:flutter/material.dart';
import 'package:survival_list/home/home.dart';
import 'package:survival_list/l10n/l10n.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({
    required this.onNavigate,
    required this.selectedTab,
    super.key,
  });

  final ValueChanged<HomeTab> onNavigate;
  final HomeTab selectedTab;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BottomNavigationBar(
      items: HomeTab.values.map(
        (tab) {
          switch (tab) {
            case HomeTab.survival:
              return BottomNavigationBarItem(
                icon: const Icon(Icons.check_box),
                label: l10n.bottomNavigationIconLabelSurvival,
              );
            case HomeTab.todo:
              return BottomNavigationBarItem(
                icon: const Icon(Icons.list),
                label: l10n.bottomNavigationIconLabelTodo,
              );
            case HomeTab.schedule:
              return BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: l10n.bottomNavigationIconLabelSchedule,
              );
          }
        },
      ).toList(),
      onTap: (int index) => onNavigate(HomeTab.values[index]),
      currentIndex: selectedTab.index,
    );
  }
}
