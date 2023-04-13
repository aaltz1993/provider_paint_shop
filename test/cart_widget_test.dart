import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paint_shop/model/cart.dart';
import 'package:paint_shop/model/catalog.dart';
import 'package:paint_shop/ui/cart.dart';
import 'package:provider/provider.dart';

Catalog? catalogStub;
Cart? cartStub;

Widget createCartScreen() => MultiProvider(
      providers: [
        Provider(create: (context) => Catalog()),
        ChangeNotifierProxyProvider<Catalog, Cart>(
            create: (context) => Cart(),
            update: (context, catalog, cart) {
              catalogStub = catalog;
              cartStub = cart;
              cart!.catalog = catalog;
              return cart;
            })
      ],
      child: const MaterialApp(
        home: CartScreen(),
      ),
    );

void main() {
  group('Cart Screen Widget Tests', () {
    testWidgets('Tap BUY Button Displays SnackBar', (tester) async {
      await tester.pumpWidget(createCartScreen());

      expect(find.byType(SnackBar), findsNothing);

      await tester.tap(find.text('BUY'));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Test Cart Contains Items', (tester) async {
      await tester.pumpWidget(createCartScreen());

      for (int i = 0; i < 5; i++) {
        Item item = catalogStub!.getByPosition(i);

        cartStub!.add(item);

        await tester.pumpAndSettle();

        expect(find.text(item.name), findsOneWidget);
      }

      expect(find.byIcon(Icons.done), findsNWidgets(5));
      // price
      expect(find.text('\$${42 * 5}'), findsOneWidget);
    });
  });
}
