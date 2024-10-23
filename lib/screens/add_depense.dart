import 'package:flutter/material.dart';

import 'package:unboring_money/database/DatabaseHelper.dart';
import 'package:unboring_money/models/Categorie.dart';
import 'package:unboring_money/models/Compte.dart';
import 'package:unboring_money/models/Depense.dart';
import 'package:unboring_money/widgets/floating_add.dart';
import 'package:unboring_money/widgets/navbar.dart';

import '../widget/ToggleButtonSelectionAdder.dart';

class AddExpensePage extends StatefulWidget {
  final int initialTabIndex;

  const AddExpensePage({super.key, required this.initialTabIndex});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  late int _selectedTab; // Pour suivre l'option sélectionnée

  DateTime selectedDate = DateTime.now();
  final _titreController = TextEditingController();
  final _montantController = TextEditingController();
  int? _selectedCategorieId;
  int? _selectedCompteId;

  final _categorieNomController = TextEditingController();
  final _categorieLimiteController = TextEditingController();

  final _compteNomController = TextEditingController();

  List<Categorie> _categories = [];
  List<Compte> _comptes = [];


  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex;
    fetchCategories();
    fetchComptes();
    fetchDepenses();
  }

  Future<void> fetchDepenses() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.getDepenses();
  }
  
  Future<void> fetchCategories() async {
    final dbHelper = DatabaseHelper();
    _categories = await dbHelper.getCategories();
    setState(() {
      _categories = _categories;
    });
  }

  Future<void> fetchComptes() async {
    final dbHelper = DatabaseHelper();
    _comptes = await dbHelper.getComptes();
    setState(() {
      _comptes = _comptes;
    });
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
              primary: Colors.teal.shade700, // Couleur du bouton OK et de la date sélectionnée
              onPrimary: Colors.white,       // Couleur du texte sur le bouton OK
              onSurface: Colors.teal.shade900, // Couleur du texte (jours, mois, années)

            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary, // Couleur du texte sur les boutons
            ),
            dialogBackgroundColor: Colors.teal[50], // Couleur de fond de la boîte de dialogue
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
      fetchCategories();
      fetchComptes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDFA),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: const Text('Ajout d\'un nouveau', style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: const Color(0xFFF0FDFA),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Utilisation du widget ToggleButtonSelectionAdder
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: ToggleButtonSelectionAdder(onSelectionChanged: _onSelectionChanged, initialIndex: _selectedTab),
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
                    titreController: _titreController,  // Ajout du controller pour le titre
                    montantController: _montantController,  // Ajout du controller pour le montant
                  ),
                if (_selectedTab == 1) 
                    CategoryForm(
                    categorieNomController: _categorieNomController,
                    categorieLimiteController: _categorieLimiteController,
                  ),
                if (_selectedTab == 2)
                  AccountForm(
                    compteNomController: _compteNomController,
                  ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        if (_selectedTab == 0) {
                          final depense = Depense(
                              titre: _titreController.text,
                              montant: double.parse(_montantController.text),
                              categorieId: _selectedCategorieId!,
                              date: selectedDate.toIso8601String(),
                              compteId: _selectedCompteId!);
                          final dbHelper = DatabaseHelper();
                          dbHelper.insertDepense(depense);
                          _titreController.text = "";
                          _montantController.text = "";
                          _selectedCategorieId = null;
                          _selectedCompteId = null;
                        }

                        if (_selectedTab == 1) {
                          final categorie = Categorie(
                              nom: _categorieNomController.text,
                              limite: int.parse(_categorieLimiteController.text));
                          final dbHelper = DatabaseHelper();
                          dbHelper.insertCategorie(categorie);
                          _categorieNomController.text = "";
                          _categorieLimiteController.text = "";
                        }

                        if (_selectedTab == 2) {
                          final compte = Compte(nom: _compteNomController.text);
                          final dbHelper = DatabaseHelper();
                          dbHelper.insertCompte(compte);
                          _compteNomController.text = "";
                        }
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[700],
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
        ),
      ),
      floatingActionButton: const FloatingAdd(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const UnboringNavBar(),
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
  final TextEditingController titreController;  // Ajout du controller pour le titre
  final TextEditingController montantController; // Ajout du controller pour le montant

  const ExpenseForm({
    super.key,
    required this.selectDate,
    required this.selectedDate,
    required this.categories,
    required this.comptes,
    this.selectedCategorieId,
    this.selectedCompteId,
    required this.onCategorieChanged,
    required this.onCompteChanged,
    required this.titreController,  // Recevoir le controller pour le titre
    required this.montantController, // Recevoir le controller pour le montant
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Utilisation du controller pour le titre de la dépense
        TextField(
          controller: titreController,
          decoration: InputDecoration(
            labelText: 'Titre de la dépense',
            filled: true,
            fillColor: Colors.teal[100],
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Dropdown pour sélectionner une catégorie
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
            underline: Container(),
            isExpanded: true,
          ),
        ),
        const SizedBox(height: 16),
        
        // Champ pour le montant avec controller
        TextField(
          controller: montantController,
          keyboardType: TextInputType.number, // Pour forcer une entrée numérique
          decoration: InputDecoration(
            labelText: 'Montant',
            filled: true,
            fillColor: Colors.teal[100],
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Sélection de la date
        GestureDetector(
          onTap: () => selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.teal[100],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  //'${selectedDate.toLocal().day}/${selectedDate.toLocal().month}/${selectedDate.toLocal().year}',
                  '${selectedDate.toLocal().day.toString().padLeft(2, '0')}/${selectedDate.toLocal().month.toString().padLeft(2, '0')}/${selectedDate.toLocal().year}',
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Dropdown pour sélectionner un compte
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
            underline: Container(),
            isExpanded: true,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}


// Formulaire pour l'ajout de catégorie (à personnaliser)
class CategoryForm extends StatelessWidget {
  final TextEditingController categorieNomController;
  final TextEditingController categorieLimiteController;

  const CategoryForm({
    super.key,
    required this.categorieNomController,
    required this.categorieLimiteController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: categorieNomController,
          decoration: InputDecoration(
            labelText: 'Nom de la catégorie',
            filled: true,
            fillColor: Colors.teal[100],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: categorieLimiteController,
          decoration: InputDecoration(
            labelText: 'Limite de dépense',
            filled: true,
            fillColor: Colors.teal[100],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// Formulaire pour l'ajout de compte (à personnaliser)
class AccountForm extends StatelessWidget {
  final TextEditingController compteNomController;

  const AccountForm({super.key, required this.compteNomController});


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: compteNomController,
          decoration: InputDecoration(
            labelText: 'Nom du compte',
            filled: true,
            fillColor: Colors.teal[100],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
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