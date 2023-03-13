import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/edit_item/edit_item.dart';
import 'package:survival_list/home/home.dart';
import 'package:survival_list/schedule/schedule.dart';
// import 'package:survival_list/survival/survival.dart';
// import 'package:survival_list/todos/todos.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);

    return Scaffold(
      body: IndexedStack(
        index: selectedTab.index,
        // children: const [SurvivalPage(), TodoPage(), SchedulePage()],
        children: const [SchedulePage(), SchedulePage(), SchedulePage()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        key: const Key('homeView_addItem_floatingActionButton'),
        onPressed: () => Navigator.of(context).push(EditItemPage.route()),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.survival,
              icon: const Icon(Icons.check_box_rounded),
              // label: l10n.bottomNavigationIconLabelSurvival,
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.todo,
              icon: const Icon(Icons.list_rounded),
              // label: l10n.bottomNavigationIconLabelTodo,
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.schedule,
              icon: const Icon(Icons.home_rounded),
              // label: l10n.bottomNavigationIconLabelSchedule,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<HomeCubit>().setTab(value),
      iconSize: 32,
      color:
          groupValue != value ? null : Theme.of(context).colorScheme.secondary,
      icon: icon,
    );
  }
}
