import 'package:flutter/foundation.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;
  OrderItem({
    @required this.amount,
    @required this.datetime,
    @required this.id,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        amount: total,
        datetime: DateTime.now(),
        id: DateTime.now().toString(),
        products: cartProducts,
      ),
    );
    notifyListeners(); 
  }
}
