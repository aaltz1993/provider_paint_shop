import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paint_shop/common/theme.dart';
import 'package:paint_shop/model/cart.dart';
import 'package:paint_shop/model/catalog.dart';
import 'package:paint_shop/ui/cart.dart';
import 'package:paint_shop/ui/catalog.dart';
import 'package:paint_shop/ui/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

GoRouter router() {
  return GoRouter(initialLocation: '/login', routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
        path: '/catalog',
        builder: (context, state) => const CatalogScreen(),
        routes: [
          GoRoute(path: 'cart', builder: (context, state) => const CartScreen())
        ]),
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => Catalog()),
        ChangeNotifierProxyProvider<Catalog, Cart>(
            create: (context) => Cart(),
            update: (context, catalog, cart) {
              if (cart == null) throw ArgumentError.notNull('cart');
              cart.catalog = catalog;
              return cart;
            })
      ],
      child: MaterialApp.router(
        title: 'Paint Shop',
        theme: appTheme,
        routerConfig: router(),
      ),
    );
  }
}
