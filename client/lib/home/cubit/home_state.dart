part of 'home_cubit.dart';

enum HomeTab { survival, todo, overview }

class HomeState extends Equatable {
  const HomeState({
    this.tab = HomeTab.survival,
  });

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}
