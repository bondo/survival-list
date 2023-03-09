import 'package:survival_list_api/survival_list_api.dart';

/// {@template survival_list_api}
/// The interface and models for an API providing access to
/// the Survival List server.
/// {@endtemplate}
abstract class SurvivalListApi {
  /// {@macro survival_list_api}
  const SurvivalListApi();

  /// Provides a [Stream] of all items.
  Stream<List<Item>> getItems();

  Future<void> createItem(Item item);

  Future<void> updateItem(Item item);

  Future<void> deleteItem(Item item);
}

class ItemNotFoundException implements Exception {}
