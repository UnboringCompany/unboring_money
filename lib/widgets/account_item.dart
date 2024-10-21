import 'package:flutter/material.dart';

class AccountItem extends StatelessWidget {
  final String name;
  final double spent;
  final IconData icon;

  const AccountItem({super.key, required this.name, required this.spent, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: ListTile(
        tileColor: const Color(0xFFF0FDFA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: Icon(icon, color: const Color(0xFF109186)),
        title: Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        subtitle: Text('Dépenses ce mois-ci : ${spent.toStringAsFixed(0)}€', style: const TextStyle(fontSize: 14, color: Colors.black54)),
        onTap: () => _showEditDeleteDialog(context),
      ),
    );
  }

  void _showEditDeleteDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: name);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          backgroundColor: const Color(0xFFF0FDFA),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Nom du compte'),
                controller: nameController,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Sauvegardez les modifications ici
                Navigator.of(context).pop();
                _editCategory(context, nameController.text);
              },
              child: const Text('Sauvegarder', style: TextStyle(color: Color(0xFF109186))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCategory(context);
              },
              child: const Text('Supprimer', style: TextStyle(color: Color(0xFF109186))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler', style: TextStyle(color: Color(0xFF109186))),
            ),
          ],
        );
      },
    );
  }

  void _editCategory(BuildContext context, String newName) {
    // Implémentez la logique pour éditer la catégorie ici
    print('Compte modifié : $newName');
  }

  void _deleteCategory(BuildContext context) {
    // Implémentez la logique pour supprimer la catégorie ici
    print('Compte supprimée : $name');
  }
}