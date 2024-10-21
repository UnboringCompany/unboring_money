import 'package:flutter/material.dart';
import 'package:unboring_money/database/DatabaseHelper.dart';
import 'package:unboring_money/models/Categorie.dart';
import 'package:unboring_money/models/Compte.dart';
import 'package:unboring_money/models/Depense.dart';

import '../widget/ToggleButtonSelectionAdder.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  int _selectedTab = 0; // Pour suivre l'option sélectionnée

  DateTime selectedDate = DateTime.now();
  final _titreController = TextEditingController();
  final _montantController = TextEditingController();
  int? _selectedCategorieId;
  int? _selectedCompteId;
  final String _recurrence = 'ponctuelle'; // Valeur par défaut

  final _categorieNomController = TextEditingController();
  final _categorieDescriptionController = TextEditingController();

  final _compteNomController = TextEditingController();

  List<Categorie> _categories = [];
  List<Compte> _comptes = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchComptes();
  }

  Future<void> fetchCategories() async {
    final dbHelper = DatabaseHelper();
    _categories = await dbHelper.getCategories();
    setState(() {});
  }

  Future<void> fetchComptes() async {
    final dbHelper = DatabaseHelper();
    _comptes = await dbHelper.getComptes();
    setState(() {});
  }

  // Fonction pour sélectionner une date avec des couleurs personnalisées
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal[700], // Couleur principale
            colorScheme: ColorScheme.light(
              primary: Colors.teal
                  .shade700, // Couleur du bouton OK et de la date sélectionnée
              onPrimary: Colors.white, // Couleur du texte sur le bouton OK
              onSurface: Colors
                  .teal.shade900, // Couleur du texte (jours, mois, années)
            ),
            buttonTheme: const ButtonThemeData(
              textTheme:
                  ButtonTextTheme.primary, // Couleur du texte sur les boutons
            ),
            dialogBackgroundColor:
                Colors.teal[50], // Couleur de fond de la boîte de dialogue
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Fonction pour gérer le changement de sélection dans le ToggleButton
  void _onSelectionChanged(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal[100],
        title: const Text('UnboringMoney'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Ajout d\'un${_selectedTab == 0 ? 'e dépense' : _selectedTab == 1 ? 'e catégorie' : ' compte'}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Utilisation du widget ToggleButtonSelectionAdder
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0), // Marge verticale autour du toggle
              child: Center(
                child: ToggleButtonSelectionAdder(
                    onSelectionChanged: _onSelectionChanged),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedTab == 0)
              ExpenseForm(
                selectDate: _selectDate,
                selectedDate: selectedDate,
                categories: _categories,
                comptes: _comptes,
                selectedCategorieId: _selectedCategorieId,
                selectedCompteId: _selectedCompteId,
                onCategorieChanged: (int? newValue) {
                  setState(() {
                    _selectedCategorieId = newValue;
                  });
                },
                onCompteChanged: (int? newValue) {
                  setState(() {
                    _selectedCompteId = newValue;
                  });
                },
              ),
            if (_selectedTab == 1) const CategoryForm(),
            if (_selectedTab == 2) const AccountForm(),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if(_selectedTab == 0){
                    final depense = Depense(titre: _titreController.text, montant: double.parse(_montantController.text), type: _categorieNomController.text, date: selectedDate, compteId: _selectedCompteId!, recurrence: _recurrence);
                    final dbHelper = DatabaseHelper();
                    dbHelper.insertDepense(depense);
                    _titreController.text = "";
                    _montantController.text = "";
                    _selectedCategorieId = null;
                    _selectedCompteId = null;
                  }

                  if (_selectedTab == 1) {
                    final categorie = Categorie(nom: _categorieNomController.text, description: _categorieDescriptionController.text);
                    final dbHelper = DatabaseHelper();
                    dbHelper.insertCategorie(categorie);
                    _categorieNomController.text = "";
                    _categorieDescriptionController.text = "";
                  }

                  if (_selectedTab == 2) {
                    final compte = Compte(nom: _compteNomController.text);
                    final dbHelper = DatabaseHelper();
                    dbHelper.insertCompte(compte);
                    _compteNomController.text = "";
                  }
                  // Action à effectuer lorsque l'utilisateur valide
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Valider ${_selectedTab == 0 ? 'la dépense' : _selectedTab == 1 ? 'la catégorie' : 'le compte'}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Formulaire d'ajout de dépense
class ExpenseForm extends StatelessWidget {
  final Function(BuildContext) selectDate;
  final DateTime selectedDate;
  final List<Categorie> categories;
  final List<Compte> comptes;
  final int? selectedCategorieId;
  final int? selectedCompteId;
  final Function(int?) onCategorieChanged;
  final Function(int?) onCompteChanged;

  const ExpenseForm({super.key, 
    required this.selectDate,
    required this.selectedDate,
    required this.categories,
    required this.comptes,
    this.selectedCategorieId,
    this.selectedCompteId,
    required this.onCategorieChanged,
    required this.onCompteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ExpenseTextField(label: 'Titre de la dépense'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.teal[100],
          ),
          child: DropdownButton<int>(
            hint: const Text("Sélectionner une categorie"),
            value: selectedCategorieId,
            onChanged: onCategorieChanged,
            items: categories.map<DropdownMenuItem<int>>((Categorie categorie) {
              return DropdownMenuItem<int>(
                value: categorie.id,
                child: Text(categorie.nom),
              );
            }).toList(),
            underline: Container(), // Remove the underline
            isExpanded: true, // Expand the dropdown to fill the container
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: ExpenseTextField(label: 'Montant')),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => selectDate(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.teal[100],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.teal[100],
          ),
          child: DropdownButton<int>(
            hint: const Text("Sélectionner un compte"),
            value: selectedCompteId,
            onChanged: onCompteChanged,
            items: comptes.map<DropdownMenuItem<int>>((Compte compte) {
              return DropdownMenuItem<int>(
                value: compte.id,
                child: Text(compte.nom),
              );
            }).toList(),
            underline: Container(), // Remove the underline
            isExpanded: true, // Expand the dropdown to fill the container
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.teal[100],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
          items: const [
            DropdownMenuItem(
                value: 'ponctuelle', child: Text('Dépense ponctuelle')),
            DropdownMenuItem(
                value: 'recurrente', child: Text('Dépense récurrente')),
          ],
          onChanged: (value) {
            // Gérer le changement de valeur
          },
          hint: const Text('Dépense ponctuelle'),
        ),
      ],
    );
  }
}

// Formulaire pour l'ajout de catégorie (à personnaliser)
class CategoryForm extends StatelessWidget {
  const CategoryForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpenseTextField(label: 'Nom de la catégorie'),
        SizedBox(height: 16),
        ExpenseTextField(label: 'Description'),
      ],
    );
  }
}

// Formulaire pour l'ajout de compte (à personnaliser)
class AccountForm extends StatelessWidget {
  const AccountForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpenseTextField(label: 'Nom du compte'),
        SizedBox(height: 16),
      ],
    );
  }
}

// Champ de texte personnalisé
class ExpenseTextField extends StatelessWidget {
  final String label;

  const ExpenseTextField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.teal[100],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
