import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paint_shop/model/cart.dart';
import 'package:paint_shop/model/catalog.dart';
import 'package:paint_shop/ui/catalog.dart';
import 'package:provider/provider.dart';

Widget createCatalogScreen() => MultiProvider(
      providers: [
        Provider(create: (context) => Catalog()),
        ChangeNotifierProxyProvider<Catalog, Cart>(
            create: (context) => Cart(),
            update: (context, catalog, cart) {
              cart!.catalog = catalog;
              return cart;
            })
      ],
      child: const MaterialApp(
        home: CatalogScreen(),
      ),
    );

void main() {
  final itemNames = Catalog.itemNames.sublist(0, 3);

  group('Catalog Screen Widget Tests', () {
    testWidgets('Test Items', (tester) async {
      await tester.pumpWidget(createCatalogScreen());

      for (String itemName in itemNames) {
        expect(find.text(itemName), findsWidgets);
      }
    });

    testWidgets('Test ADD Button and Check After Clicking', (tester) async {
      await tester.pumpWidget(createCatalogScreen());

      expect(find.text('ADD'), findsWidgets);

      await tester.tap(find.widgetWithText(TextButton, 'ADD').first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
