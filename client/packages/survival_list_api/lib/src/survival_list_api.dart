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

  /// Creates an unchecked `item` with [title].
  Future<void> createItem(String title);

  /// Updates an [item]
  Future<void> updateItem(Item item);

  /// Delete the `todo` with the given id.
  Future<void> deleteItem(int id);
}

class ItemNotFoundException implements Exception {}
