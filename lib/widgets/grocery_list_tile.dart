import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/model/item_model.dart';
import 'package:shopping_app/provider/new_items_notifier.dart';
import '../data/categories.dart';

class GroceryListTile extends ConsumerWidget {
  final ItemModel newItem;
  const GroceryListTile({super.key, required this.newItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groceryList = ref.read(newItemsProvider.notifier);
    return Dismissible(
      key: ValueKey(newItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent,
        alignment: AlignmentGeometry.center,
        child: Icon(Icons.delete, color: Colors.white),
      ),

      onDismissed: (direction) async {
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(
          SnackBar(
            content: Text('Item removed'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                groceryList.addNewItem(newItem);
              },
            ),
          ),
        );
        final removeItemStatus = await ref
            .read(newItemsProvider.notifier)
            .removeItem(newItem);
        if (!removeItemStatus) {
          messenger.showSnackBar(
            SnackBar(
              content: Text('Failed to remove item'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },

      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 20,
                color: category[newItem.category]!.color,
              ),

              Text(newItem.title),

              Text('${newItem.quantity}'),
            ],
          ),
        ),
      ),
    );
  }
}
