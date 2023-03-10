import 'package:survival_list_api/survival_list_api.dart';

/// {@template survival_list_repository}
/// A repository that handles Survival List requests.
/// {@endtemplate}
class SurvivalListRepository {
  /// {@macro survival_list_repository}
  const SurvivalListRepository({required SurvivalListApi api}) : _api = api;

  final SurvivalListApi _api;

  /// Provides a [Stream] of all items.
  Stream<List<Item>> getItems() => _api.getItems();

  /// Creates an unchecked `item` with [title].
  Future<void> createItem(String title) => _api.createItem(title);

  /// Updates an [item]
  Future<void> updateItem(Item item) => _api.updateItem(item);

  /// Delete the `todo` with the given id.
  Future<void> deleteItem(int id) => _api.deleteItem(id);
}
