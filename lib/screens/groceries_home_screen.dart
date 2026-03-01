import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/model/item_model.dart';
import 'package:shopping_app/provider/new_items_notifier.dart';
import '../widgets/groceries_list.dart';
import 'new_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/categories.dart';

class GroceriesHomeScreen extends ConsumerStatefulWidget {
  const GroceriesHomeScreen({super.key});

  @override
  ConsumerState<GroceriesHomeScreen> createState() =>
      _GroceriesHomeScreenState();
}

class _GroceriesHomeScreenState extends ConsumerState<GroceriesHomeScreen> {
  var _isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void getItem() {
    Navigator.of(
      context,
    ).push<ItemModel>(MaterialPageRoute(builder: (ctx) => NewItem()));
  }

  void _loadItems() async {
    final url = Uri.https(
      'shopping-app-fd160-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );
    try {
      final response = await http.get(url);

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        //response.body returns a string
        return;
      }

      final Map<String, dynamic>? loadedItemsList = json.decode(response.body);

      if (loadedItemsList == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final List<ItemModel> listData = [];

      for (final item in loadedItemsList.entries) {
        final itemCategory = category.entries
            .firstWhere(
              (catItem) =>
                  catItem.value.title.toLowerCase() == item.value['category'],
            )
            .key;
        listData.add(
          ItemModel(
            id: item.key,
            title: item.value['title'],
            quantity: item.value['quantity'],
            category: itemCategory,
          ),
        );
      }
      ref.read(newItemsProvider.notifier).fetchData(listData);
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget updateState(WidgetRef ref) {
    //change this to get a request from backend
    final groceryList = ref.watch(newItemsProvider);

    //1.
    if (_isLoading) {
      return CircularProgressIndicator();
    }

    if (error != null) {
      return Text('$error');
    }

    if (groceryList.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            iconSize: 200,
            color: Colors.grey,
            onPressed: getItem,
          ),
          Text(
            'Add a new item',
            style: TextStyle(color: Colors.grey, fontSize: 17),
          ),
        ],
      );
    } else {
      return GroceriesList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery Items'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,

        actions: [IconButton(onPressed: getItem, icon: Icon(Icons.add))],
      ),
      body: Center(child: updateState(ref)),
    );
  }
}
