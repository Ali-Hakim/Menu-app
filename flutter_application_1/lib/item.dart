import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String _baseURL = '192.168.1.104';

class Item {
  final int id;
  final String name;
  final String image;
  final double price;
  final String description;

  Item(this.id, this.name, this.image, this.price, this.description);

  @override
  String toString() {
    return 'ID: $id Name: $name\nImage: $image \nPrice: \$${price.toStringAsFixed(2)}\nDescription: $description';
  }
}


List<Item> items = [];

void updateItems(Function(bool success) update) async {
  try {
    final url = Uri.http(_baseURL, 'getitems.php');
    final response = await http.get(url).timeout(const Duration(seconds: 5));
    items.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
      for (var row in jsonResponse) {
        Item item = Item(
          int.parse(row['id']),
          row['name'],
          row['image'],
          double.parse(row['price']),
          row['description'],
        );
        items.add(item);
      }
      print(items);
      update(true);
    } else {
      print("Failed to load data: ${response.statusCode}");
      update(false);
    }
  } catch (e) {
    print("Error: $e");
    update(false);
  }
}


class ShowItems extends StatelessWidget {
  final double width;
  const ShowItems({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => Column(
        children: [
          const SizedBox(height: 10),
          Container(
            color: index % 2 == 0 ? Colors.black54 : Colors.cyan,
            padding: const EdgeInsets.all(10),
            width: width * 0.9,
            child: Row(
              children: [
                Image.network(
                  items[index].image,
                  width: width * 0.25,
                  height: width * 0.25,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        items[index].name,
                        style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '\$${items[index].price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: width * 0.045,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        items[index].description,
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

