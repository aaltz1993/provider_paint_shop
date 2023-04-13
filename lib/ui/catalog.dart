import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paint_shop/model/cart.dart';
import 'package:paint_shop/model/catalog.dart';
import 'package:provider/provider.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _AppBar(),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 12,
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => _CatalogListItem(index)))
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        'Catalog',
        style: Theme.of(context).textTheme.displayLarge,
      ),
      floating: true,
      backgroundColor: Colors.yellow,
      actions: [
        IconButton(
          onPressed: () => context.go('/catalog/cart'),
          icon: const Icon(Icons.shopping_cart),
        )
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  final Item item;

  const _AddButton({required this.item});

  @override
  Widget build(BuildContext context) {
    bool isInCart =
        context.select<Cart, bool>((cart) => cart.items.contains(item));

    return TextButton(
        onPressed: () {
          Cart cart = context.read<Cart>();

          cart.items.contains(item) ? cart.remove(item) : cart.add(item);
        },
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor;
          }
          return null;
        })),
        child: isInCart
            ? const Icon(
                Icons.check,
                semanticLabel: 'ADDED',
              )
            : const Text('ADD'));
  }
}

class _CatalogListItem extends StatelessWidget {
  final int index;

  const _CatalogListItem(this.index);

  @override
  Widget build(BuildContext context) {
    Item item = context
        .select<Catalog, Item>((catalog) => catalog.getByPosition(index));

    TextStyle? nameStyle = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(color: item.color),
            ),
            const SizedBox(
              width: 24,
            ),
            Expanded(
                child: Text(
              item.name,
              style: nameStyle,
            )),
            const SizedBox(
              width: 24,
            ),
            _AddButton(item: item)
          ],
        ),
      ),
    );
  }
}
