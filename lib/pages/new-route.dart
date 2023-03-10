import 'package:flutter/material.dart';

class NewRoute extends StatelessWidget {
  const NewRoute({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New route"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("This is new route"),
              Text("id: $id"),
            ],
          ),
        ));
  }
}
