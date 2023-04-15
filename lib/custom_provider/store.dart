import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class StoreProvider<Value, Controller extends ValueNotifier<Value>>
    extends SingleChildStatelessWidget {
  const StoreProvider({
    Key? key,
    required this.create,
    Widget? child,
  }) : super(key: key, child: child);

  final Create<Controller> create;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return InheritedProvider<Controller>(
      create: create,
      builder: (context, widget) {
        return ValueListenableProvider<Value>.value(
          value: context.watch<Controller>(),
          child: child,
        );
      },
    );
  }
}

enum Action { increment, decrement }

class Store extends ValueNotifier<int> {
  Store() : super(0);
  void increment() => value++;
  void decrement() => value--;
}

class Bar {}

class Initial implements Bar {}

class Loading implements Bar {}

class Error implements Bar {
  final Object error;
  Error(this.error);
}

class Loaded implements Bar {
  final int value;
  Loaded(this.value);
}

class Foo extends ValueNotifier<Bar> {
  Foo() : super(Initial());

  Future<void> fetch() async {
    value = Loading();
    try {
      final result = await Future<int>.delayed(const Duration(seconds: 1));
      value = Loaded(result);
    } catch (exception) {
      value = Error(exception);
    }
  }
}

// interface & implementation
abstract class ProviderInterface with ChangeNotifier {}

class ProviderImplementation with ChangeNotifier implements ProviderInterface {}

class Baz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderInterface>(context);

    return Container();
  }
}

void main() {
  ChangeNotifierProvider<ProviderInterface>(
      create: (_) => ProviderImplementation(), child: Baz());
}
