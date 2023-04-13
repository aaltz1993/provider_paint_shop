import 'package:flutter/foundation.dart';
import 'package:paint_shop/model/catalog.dart';

class Cart extends ChangeNotifier {
  late Catalog _catalog;

  set catalog(Catalog catalog) {
    _catalog = catalog;

    notifyListeners();
  }

  Catalog get catalog => _catalog;

  final List<int> _itemIds = [];

  List<Item> get items => _itemIds.map((id) => _catalog.getById(id)).toList();

  int get totalPrice =>
      items.fold(0, (total, current) => total + current.price);

  void add(Item item) {
    _itemIds.add(item.id);

    notifyListeners();
  }

  void remove(Item item) {
    _itemIds.remove(item.id);

    notifyListeners();
  }
}
