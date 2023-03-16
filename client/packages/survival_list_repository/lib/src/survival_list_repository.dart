import 'package:survival_list_api/survival_list_api.dart';

/// {@template survival_list_repository}
/// A repository that handles Survival List requests.
/// {@endtemplate}
class SurvivalListRepository {
  /// {@macro survival_list_repository}
  const SurvivalListRepository({required SurvivalListApi api}) : _api = api;

  final SurvivalListApi _api;

  /// Provides a [Stream] of all items.
  Stream<List<Item>> get items => _api.items;

  /// Provides a [Stream] of fetching states.
  Stream<bool> get isFetching => _api.isFetching;

  /// Saves an [item]
  Future<void> saveItem(Item item) {
    if (item.id == null) {
      return _api.createItem(item.title);
    } else {
      return _api.updateItem(item);
    }
  }

  /// Delete the `todo` with the given id.
  Future<void> deleteItem(int id) => _api.deleteItem(id);
}
