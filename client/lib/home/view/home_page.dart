import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/create_item/create_item.dart';
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
        children: HomeTab.values.map(
          (tab) {
            switch (tab) {
              case HomeTab.survival:
                return const SchedulePage(
                  variant: ScheduleViewVariant.survival,
                );
              case HomeTab.todo:
                return const SchedulePage(
                  variant: ScheduleViewVariant.todo,
                );
              case HomeTab.overview:
                return const SchedulePage(
                  variant: ScheduleViewVariant.overview,
                );
            }
          },
        ).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('homeView_addItem_floatingActionButton'),
        onPressed: () => Navigator.of(context).push(CreateItemPage.route()),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: HomeNavigationBar(
        onNavigate: context.read<HomeCubit>().setTab,
        selectedTab: selectedTab,
      ),
    );
  }
}
