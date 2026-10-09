import 'package:flutter/material.dart';
import 'package:x_clone_ec/app_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSaving = false;

  static const _colors = {
    'Noir': Colors.black,
    'Gris foncé': Color(0xff252525),
    'Bleu nuit': Color(0xff15202b),
    'Violet foncé': Color(0xff291b35),
  };

  Future<void> _selectColor(Color color) async {
    setState(() => _isSaving = true);
    try {
      await AppSettings.of(context).changeBackgroundColor(color);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Couleur sauvegardée')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible de sauvegarder la couleur. Réessayez.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = AppSettings.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Couleur du fond',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'La couleur est sauvegardée automatiquement pour le prochain lancement.',
          ),
          const SizedBox(height: 20),
          for (final entry in _colors.entries)
            ListTile(
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: entry.value,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
              ),
              title: Text(entry.key),
              trailing: settings.backgroundColor == entry.value
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: _isSaving ? null : () => _selectColor(entry.value),
            ),
          if (_isSaving) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
