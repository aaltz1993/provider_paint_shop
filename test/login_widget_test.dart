import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paint_shop/main.dart';
import 'package:paint_shop/model/cart.dart';
import 'package:paint_shop/model/catalog.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Login Screen Widget Test', (tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        Provider(create: (context) => Catalog()),
        ChangeNotifierProxyProvider<Catalog, Cart>(
            create: (context) => Cart(),
            update: (context, catalog, cart) {
              cart!.catalog = catalog;
              return cart;
            })
      ],
      child: MaterialApp.router(
        routerConfig: router(),
      ),
    ));

    await tester.tap(find.text('ENTER'));
    await tester.pumpAndSettle();

    expect(find.text('Catalog'), findsOneWidget);
  });
}
