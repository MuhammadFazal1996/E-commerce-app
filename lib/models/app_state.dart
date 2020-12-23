import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/models/product.dart';
import 'package:flutter_ecommerce/models/user.dart';

@immutable
class AppState {
  final User user;
  final List<Product> products;

  AppState({@required this.user, @required this.products});

  factory AppState.initial() {
    return AppState(user: null, products: []);
  }
}
