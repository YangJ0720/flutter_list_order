import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_list_order/reorder/material/reorderable_list.dart'
    as custom;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final StreamController<List<int>> _controller = StreamController();

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(DateTime.now().toIso8601String())),
      body: StreamBuilder<List<int>>(
        builder: (_, snapshot) {
          var data = snapshot.requireData;
          return custom.ReorderableListView.builder(
            itemBuilder: (_, index) {
              var item = data[index];
              return ListTile(
                key: ValueKey(index),
                title: Text(item.toString()),
              );
            },
            itemCount: data.length,
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) newIndex--;
              var item = data.removeAt(oldIndex);
              data.insert(newIndex, item);
              //
              _controller.sink.add(data);
            },
            onDragStart: () => debugPrint('onDragStart'),
            onDragUpdate: (int fromIndex, int toIndex) {
              debugPrint('onDragUpdate');
              data.removeAt(fromIndex);
              _controller.sink.add(data);
            },
            proxyDecorator: (Widget child, int index, Animation<double> _) {
              return Material(child: child, color: Colors.grey);
            },
          );
        },
        stream: _controller.stream,
        initialData: List.generate(10, (index) => index),
      ),
    );
  }
}
