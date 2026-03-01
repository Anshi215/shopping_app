import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/model/category_model.dart';
import 'package:shopping_app/model/item_model.dart';
import '../data/categories.dart';
import '../provider/new_items_notifier.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewItem extends ConsumerStatefulWidget {
  const NewItem({super.key});

  @override
  ConsumerState<NewItem> createState() => _NewItem();
}

class _NewItem extends ConsumerState<NewItem> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  int? _quantity;
  Category? _category = Category.fruit;
  var _isSending = false;

  void saveState(NewItemsNotifier passItem) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      final url = Uri.https(
        'shopping-app-fd160-default-rtdb.firebaseio.com',
        'shopping-list.json',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          ItemModel(
            id: DateTime.now().toString(),
            category: _category!,
            title: _title!,
            quantity: _quantity!,
          ),
        ),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        passItem.addNewItem(
          ItemModel(
            id: DateTime.now().toString(),
            category: _category!,
            title: _title!,
            quantity: _quantity!,
          ),
        );
      }
      if (!mounted) return;
      else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add a new item')),
      body: Padding(
        padding: EdgeInsetsGeometry.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(label: const Text('Name')),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      value.length < 2) {
                    return 'Invalid title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value;
                },
              ),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(label: Text('Quantity')),
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Invalid Quantity';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _quantity = int.parse(value!);
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      initialValue: Category.fruit,
                      items: [
                        //entries converts your map into a list
                        for (final category in category.entries)
                          DropdownMenuItem(
                            value: category.key,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        _category = value;
                      },
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: _isSending
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _isSending
                        ? null
                        : () {
                            final NewItemsNotifier passItem = ref.read(
                              newItemsProvider.notifier,
                            );
                            saveState(passItem);
                          },
                    child: _isSending
                        ? SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : Text('Save'),
                  ),
                ],
              ),
              //instead of textfiled widget
            ],
          ),
        ),
      ),
    );
  }
}
