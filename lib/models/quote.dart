import 'dart:convert';

class Quote {
  const Quote(this.text, this.author);

  final String text;
  final String author;

  factory Quote.fromJSON(String quoteJSON) {
    final decoded = jsonDecode(quoteJSON);
    final Map<String, dynamic> quoteMap;
    if (decoded is List && decoded.isNotEmpty && decoded.first is Map) {
      quoteMap = Map<String, dynamic>.from(decoded.first as Map);
    } else if (decoded is Map) {
      quoteMap = Map<String, dynamic>.from(decoded);
    } else {
      throw const FormatException('Réponse JSON de citation invalide');
    }

    final text = quoteMap['q'];
    final author = quoteMap['a'];
    if (text is! String || text.trim().isEmpty || author is! String) {
      throw const FormatException('Champs de citation invalides');
    }
    return Quote(text, author);
  }
}
