class MtgCard {
  final String id, name, type, imageUrl, text, manaCost, setName;

  MtgCard({
    required this.id, required this.name, required this.type, required this.imageUrl,
    this.text = '', this.manaCost = '', this.setName = '',
  });

  factory MtgCard.fromJson(Map<String, dynamic> json) => MtgCard(
    id: json['id'] ?? '',
    name: json['name'] ?? 'Bez nazwy',
    type: json['type'] ?? 'Nieznany',
    imageUrl: json['imageUrl'] ?? '',
    text: json['text'] ?? '',
    manaCost: json['manaCost'] ?? '',
    setName: json['setName'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'type': type, 'imageUrl': imageUrl,
    'text': text, 'manaCost': manaCost, 'setName': setName,
  };
}