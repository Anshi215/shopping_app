import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'grocery_list_tile.dart';
import '../provider/new_items_notifier.dart';

class GroceriesList extends ConsumerWidget {
  const GroceriesList({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final itemList = ref.watch(newItemsProvider);
    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        return GroceryListTile(newItem: itemList[index]);
      },
    );
  }
}
