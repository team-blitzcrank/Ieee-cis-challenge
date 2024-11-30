import 'package:flutter/material.dart';
import '../data/items_data.dart';
import '../widgets/item_card.dart';
import 'item_detail_screen.dart';

class ItemListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items Gallery'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: ItemsData.items.length,
        itemBuilder: (context, index) {
          final item = ItemsData.items[index];
          return ItemCard(
            item: item,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailScreen( item: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
