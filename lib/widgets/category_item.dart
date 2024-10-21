import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String name;
  final double limit;
  final double spent;
  final IconData icon;

  const CategoryItem({super.key, required this.name, required this.limit, required this.spent, required this.icon});

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
        subtitle: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10),
              width: double.infinity,
              height: 20,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: LinearProgressIndicator(
                  value: (limit - spent) / limit,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF109186)),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${spent.toStringAsFixed(0)}€', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                  Text('${limit.toStringAsFixed(0)}€', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
        onTap: () => _showEditDeleteDialog(context),
      ),
    );
  }

  void _showEditDeleteDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: name);
    final TextEditingController limitController = TextEditingController(text: limit.toString());

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
                decoration: const InputDecoration(labelText: 'Nom de la catégorie'),
                controller: nameController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Limite'),
                controller: limitController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Sauvegardez les modifications ici
                Navigator.of(context).pop();
                _editCategory(context, nameController.text, double.parse(limitController.text));
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

  void _editCategory(BuildContext context, String newName, double newLimit) {
    // Implémentez la logique pour éditer la catégorie ici
    print('Catégorie modifiée : $newName, Limite : $newLimit');
  }

  void _deleteCategory(BuildContext context) {
    // Implémentez la logique pour supprimer la catégorie ici
    print('Catégorie supprimée : $name');
  }
}