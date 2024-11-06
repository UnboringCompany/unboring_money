import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unboring_money/widgets/floating_add.dart';
import 'package:unboring_money/widgets/navbar.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  // Charger le prénom depuis les SharedPreferences
  Future<void> _loadName() async {
    _prefs = await SharedPreferences.getInstance();
    _nameController.text = _prefs?.getString('userName') ?? '';
  }

  // Enregistrer le prénom dans les SharedPreferences
  Future<void> _saveName() async {
    if (_prefs != null) {
      await _prefs!.setString('userName', _nameController.text);
    }
  }

  @override
  void dispose() {
    _saveName(); // Sauvegarder quand on quitte la page
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF0FDFA),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: const Text('Paramètres', style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: const Color(0xFFF0FDFA),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Prénom de l'utilisateur",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Entrez votre prénom',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingAdd(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const UnboringNavBar(),
    );
  }
}
