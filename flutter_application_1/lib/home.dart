import 'package:flutter/material.dart';
import 'item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _load = false;

  void update(bool success) {
    setState(() {
      _load = true;
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load data')));
      }
    });
  }

  @override
  void initState() {
    updateItems(update);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text('Menu', style: TextStyle(color: Colors.amber),),
        centerTitle: true,
      ),
      body: _load
          ? ShowItems(width: MediaQuery.of(context).size.width)
          : const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
