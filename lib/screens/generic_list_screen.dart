import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodels/mtg_viewmodel.dart';
import 'card_detail_screen.dart';

class GenericListScreen extends StatefulWidget {
  final bool isCards;
  const GenericListScreen({required this.isCards});

  @override
  _GenericListScreenState createState() => _GenericListScreenState();
}

class _GenericListScreenState extends State<GenericListScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    final vm = context.read<MtgViewModel>();
    if (widget.isCards && vm.cards.isEmpty) vm.fetchCards();
    if (!widget.isCards && vm.sets.isEmpty) vm.fetchSets();

    _scroll.addListener(() {
      if (_scroll.position.pixels == _scroll.position.maxScrollExtent && widget.isCards) {
        vm.fetchCards(loadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MtgViewModel>();
    final list = widget.isCards ? vm.cards : vm.sets;

    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: widget.isCards
            ? TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(hintText: 'Szukaj kart...', hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none),
          onChanged: vm.search,
        )
            : Text("Sety", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          if (vm.error.isNotEmpty)
            Container(padding: EdgeInsets.all(8), color: Colors.red, width: double.infinity, child: Text(vm.error, textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
          Expanded(
            child: list.isEmpty && vm.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: widget.isCards ? _scroll : null,
              itemCount: list.length + (vm.isLoading ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == list.length) return Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()));
                final item = list[i];

                if (widget.isCards) {
                  final card = item;
                  return ListTile(
                    leading: card.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: card.imageUrl, width: 40,
                      placeholder: (c, u) => CircularProgressIndicator(strokeWidth: 2),
                      errorWidget: (c, u, e) => Icon(Icons.error, color: Colors.white),
                    )
                        : Icon(Icons.image, color: Colors.white),
                    title: Text(card.name, style: TextStyle(color: Colors.white)),
                    subtitle: Text(card.type, style: TextStyle(color: Colors.grey)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CardDetailScreen(card: card)));
                    },
                  );
                } else {
                  return ListTile(
                    title: Text(item['name'] ?? '', style: TextStyle(color: Colors.white)),
                    subtitle: Text(item['releaseDate'] ?? '', style: TextStyle(color: Colors.grey)),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}