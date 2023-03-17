import 'package:rxdart/rxdart.dart';
import 'package:survival_list_api/survival_list_api.dart';

/// {@template survival_list_repository}
/// A repository that handles Survival List requests.
/// {@endtemplate}
class SurvivalListRepository {
  /// {@macro survival_list_repository}
  const SurvivalListRepository({required SurvivalListApi api}) : _api = api;

  final SurvivalListApi _api;

  /// Provides a [Stream] of all items.
  Stream<List<Item>> get items =>
      _api.items.map((items) => items.values.toList());

  /// Provides a [Stream] of loading states.
  Stream<bool> get isLoading =>
      ZipStream.zip2(_api.isCreating, _api.isFetching, (a, b) => a || b)
          .distinct();

  /// Creates an [item]
  Future<void> createItem(String title) => _api.createItem(title);

  /// Updates an [item]
  Future<void> updateItem(Item item) => _api.updateItem(item);

  /// Delete the `todo` with the given id.
  Future<void> deleteItem(int id) => _api.deleteItem(id);
}
