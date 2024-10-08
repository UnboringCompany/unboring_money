import 'package:flutter/material.dart';

import '../widget/ToggleButtonSelectionAdder.dart';

class AddExpensePage extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  int _selectedTab = 0; // Pour suivre l'option sélectionnée

  DateTime selectedDate = DateTime.now();

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal[100],
        title: Text('UnboringMoney'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child:
            Text(
              'Ajout d\'un${_selectedTab == 0 ? 'e dépense' : _selectedTab == 1 ? 'e catégorie' : ' compte'}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),)
            ,
            SizedBox(height: 16),
            // Utilisation du widget ToggleButtonSelectionAdder
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0), // Marge verticale autour du toggle
              child: 
              Center(
                child: ToggleButtonSelectionAdder(onSelectionChanged: _onSelectionChanged),
              ),

            ),
            SizedBox(height: 16),
            if (_selectedTab == 0) ExpenseForm(selectDate: _selectDate, selectedDate: selectedDate),
            if (_selectedTab == 1) CategoryForm(),
            if (_selectedTab == 2) AccountForm(),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Action à effectuer lorsque l'utilisateur valide
                },
                child: Text(
                  'Valider ${_selectedTab == 0 ? 'la dépense' : _selectedTab == 1 ? 'la catégorie' : 'le compte'}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
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

  ExpenseForm({required this.selectDate, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpenseTextField(label: 'Titre de la dépense'),
        SizedBox(height: 16),
        ExpenseTextField(label: 'Type de dépense'),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: ExpenseTextField(label: 'Montant')),
            SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.teal[100],
                  ),
                  child: Row(
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
        SizedBox(height: 16),
        ExpenseTextField(label: 'Compte associé'),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.teal[100],
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
          items: [
            DropdownMenuItem(child: Text('Dépense ponctuelle'), value: 'ponctuelle'),
            DropdownMenuItem(child: Text('Dépense récurrente'), value: 'recurrente'),
          ],
          onChanged: (value) {
            // Gérer le changement de valeur
          },
          hint: Text('Dépense ponctuelle'),
        ),
      ],
    );
  }
}

// Formulaire pour l'ajout de catégorie (à personnaliser)
class CategoryForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
  @override
  Widget build(BuildContext context) {
    return Column(
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

  ExpenseTextField({required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.teal[100],
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
