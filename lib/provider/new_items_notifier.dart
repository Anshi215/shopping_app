import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shopping_app/model/item_model.dart';
import 'package:http/http.dart' as http;

class NewItemsNotifier extends Notifier<List<ItemModel>> {
  String? error;
  @override
  List<ItemModel> build() => [];

  void addNewItem(ItemModel item) {
    state = [...state, item];
  }

  Future<bool> removeItem(ItemModel item) async {
    final previousState = state;
    final url = Uri.https(
      'shopping-app-fd160-default-rtdb.firebaseio.com',
      'shopping-list/${item.id}.json',
    );
    try {
      final response = await http.delete(url);
      state = state.where((ItemModel i) => i.id != item.id).toList();
      if (response.statusCode >= 400) {
        state = previousState;
        return false;
      }
    } catch (e) {
      print(e);
      state = previousState;
      return false;
    }
    return true;
  }

  void fetchData(List<ItemModel> listData) {
    state = listData;
  }
}

final newItemsProvider = NotifierProvider<NewItemsNotifier, List<ItemModel>>(
  () {
    return NewItemsNotifier();
  },
);
