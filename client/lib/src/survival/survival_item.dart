import 'package:flutter/material.dart';
import 'package:survival_list/src/api/client.dart';

class SurvivalItem {
  SurvivalItem({required this.id, required this.title, required this.checked});

  final int id;
  final String title;
  bool checked;
}

class SurvivalItemListRefetchContainer extends ChangeNotifier {
  Future<List<SurvivalItem>> future;

  SurvivalItemListRefetchContainer() : future = Client.getTasks();

  Future<List<SurvivalItem>> refetch() {
    future = Client.getTasks();
    notifyListeners();
    return future;
  }
}
