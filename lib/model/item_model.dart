import 'category_model.dart';

class ItemModel {
  final String id;
  final int quantity;
  final String title;
  final Category category;

  ItemModel({
    required this.id,
    required this.title,
    required this.quantity,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'quantity': quantity,
      'category' : category.name,
    };
  }
}
