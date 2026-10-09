import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:x_clone_ec/models/quote.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  late Future<Quote> _quoteFuture;

  @override
  void initState() {
    super.initState();
    _quoteFuture = fetchQuote();
  }

  Future<Quote> fetchQuote() async {
    final response = await http
        .get(
          Uri.parse('https://zenquotes.io/api/random'),
        )
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Échec de récupération de la citation');
    }
    return Quote.fromJSON(response.body);
  }

  void _reloadQuote() {
    setState(() {
      _quoteFuture = fetchQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Citation du jour')),
      body: FutureBuilder<Quote>(
        future: _quoteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _QuoteMessage(
              message: 'Impossible de récupérer une citation.',
              action: _reloadQuote,
            );
          }
          final quote = snapshot.data;
          if (quote == null) {
            return _QuoteMessage(
              message: 'Citation indisponible.',
              action: _reloadQuote,
            );
          }
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.format_quote, size: 56, color: Colors.blue),
                  const SizedBox(height: 24),
                  Text(
                    quote.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, height: 1.35),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '— ${quote.author}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    onPressed: _reloadQuote,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Nouvelle citation'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuoteMessage extends StatelessWidget {
  const _QuoteMessage({required this.message, required this.action});

  final String message;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: action,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
