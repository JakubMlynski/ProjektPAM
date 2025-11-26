import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models.dart';

class CardDetailScreen extends StatelessWidget {
  final MtgCard card;
  const CardDetailScreen({required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white)
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          if (card.imageUrl.isNotEmpty)
            CachedNetworkImage(
              imageUrl: card.imageUrl, height: 300, fit: BoxFit.contain,
              placeholder: (c, u) => Center(child: CircularProgressIndicator()),
              errorWidget: (c, u, e) => Column(children: [Icon(Icons.broken_image, size: 50, color: Colors.grey), Text("Brak obrazka (offline)", style: TextStyle(color: Colors.grey))]),
            ),
          SizedBox(height: 20),
          Text(card.name, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(card.type, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
          SizedBox(height: 20),
          if (card.text.isNotEmpty) Container(
            padding: EdgeInsets.all(10), color: Color(0xFF2B2B2B),
            child: Text(card.text, style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Mana: ${card.manaCost}", style: TextStyle(color: Colors.white)),
              Text("Set: ${card.setName}", style: TextStyle(color: Colors.white)),
            ],
          )
        ],
      ),
    );
  }
}