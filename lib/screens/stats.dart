import 'package:flutter/material.dart';
import 'package:unboring_money/widgets/floating_add.dart';
import 'package:unboring_money/widgets/navbar.dart';
import 'package:unboring_money/database/DatabaseHelper.dart';
import 'package:unboring_money/models/Depense.dart';
import 'package:unboring_money/models/Categorie.dart';
import 'package:unboring_money/models/Compte.dart';
import 'package:unboring_money/widgets/charts/BarChart.dart';

class StatsPage extends StatefulWidget {
  final int initialTabIndex;

  const StatsPage({super.key, required this.initialTabIndex});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<Map<String, dynamic>> _depenses = [];
  List<Map<String, dynamic>> allDepenseData = [];

  List<Categorie> _categories = []; // Liste de catégories
  List<Compte> _comptes = []; // Liste de comptes

  DateTime? _startDate;
  DateTime? _endDate;
  List<int> _selectedCategories = [];
  List<int> _selectedAccounts = [];
  String _sortBy = 'date';

  @override
  void initState() {
    super.initState();
    fetchDepenses(selectedCategories: null, selectedAccounts: null);
    fetchCategoriesAndComptes(); // Récupérer les catégories et comptes
  }

  Future<void> fetchCategoriesAndComptes() async {
    final dbHelper = DatabaseHelper();
    _categories = await dbHelper.getCategories(); // Récupère les catégories
    _comptes = await dbHelper.getComptes(); // Récupère les comptes
    setState(() {}); // Met à jour l'état pour rafraîchir l'interface
  }

  Future<void> fetchDepenses({
    required List<int>? selectedCategories,
    required List<int>? selectedAccounts,
  }) async {
    final dbHelper = DatabaseHelper();
    List<Depense> depenses = await dbHelper.getDepenses();
    List<Categorie> categories = await dbHelper.getCategories();
    List<Compte> comptes = await dbHelper.getComptes();

    // Si les listes de catégories ou comptes sont nulles, on sélectionne toutes les catégories/comptes par défaut
    _selectedCategories =
        selectedCategories ?? categories.map((c) => c.id!).toList();
    _selectedAccounts = selectedAccounts ?? comptes.map((c) => c.id!).toList();

    // Map des catégories et des comptes
    Map<int, String> categorieMap = {
      for (var cat in categories) cat.id!: cat.nom
    };
    Map<int, String> compteMap = {
      for (var compte in comptes) compte.id!: compte.nom
    };

    // Transformation des données en incluant la date formatée
    List<Map<String, dynamic>> allDepenseData = depenses.map((depense) {
      return {
        'valeur': depense.montant,
        'legende': depense.date,
        'categorieId': depense.categorieId,
        'categorie': categorieMap[depense.categorieId] ?? 'Inconnue',
        'compteId': depense.compteId,
        'compte': compteMap[depense.compteId] ?? 'Inconnu',
        'titre': depense.titre,
        'date': depense.date,
      };
    }).toList();

    setState(() {
      allDepenseData = allDepenseData;
      // _depenses = filterData(data: allDepenseData);
      applyFilter(_startDate, _endDate, _selectedCategories, _selectedAccounts,
          _sortBy, allDepenseData);
    });
  }

  void applyFilter(
      DateTime? startDate,
      DateTime? endDate,
      List<int>? selectedCategories,
      List<int>? selectedAccounts,
      String sortBy,
      List<Map<String, dynamic>> data) {
    // Si `selectedCategories` et `selectedAccounts` sont définis, nous les utilisons
    // Sinon, on récupère toutes les catégories et comptes par défaut

    selectedCategories ??= _selectedCategories;
    selectedAccounts ??= _selectedAccounts;

    // Applique le filtrage avec les paramètres actuels
    List<Map<String, dynamic>> filteredData = filterData(
      data: data,
      startDate: startDate,
      endDate: endDate,
      selectedCategories: selectedCategories,
      selectedAccounts: selectedAccounts,
      sortBy: sortBy,
    );

    setState(() {
      _depenses = filteredData;
    });
  }

  List<Map<String, dynamic>> filterData({
    required List<Map<String, dynamic>> data,
    DateTime? startDate,
    DateTime? endDate,
    required List<int> selectedCategories,
    required List<int> selectedAccounts,
    String? sortBy,
  }) {
    print("Début du filtrage...");
    print("Date de début : $startDate, Date de fin : $endDate");
    print("Catégories sélectionnées : $selectedCategories");
    print("Comptes sélectionnés : $selectedAccounts");
    print("Data avant filtrage : $data");
    print("Order by $sortBy");

    // Filtrage par date, catégorie, et compte
    List<Map<String, dynamic>> filteredData = data.where((entry) {
      final entryDate = DateTime.parse(entry['date']);

      // Filtre par date
      if (startDate != null && entryDate.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && entryDate.isAfter(endDate)) {
        return false;
      }

      // Filtre par catégorie sélectionnée
      if (!selectedCategories.contains(entry['categorieId'])) {
        return false;
      }

      // Filtre par compte sélectionné
      if (!selectedAccounts.contains(entry['compteId'])) {
        return false;
      }

      return true; // Conserve l'entrée si elle correspond aux critères
    }).toList();

    // Tri des données si nécessaire
    if (sortBy != null) {
      switch (sortBy) {
        case 'category':
          filteredData.sort((a, b) =>
              (a['categorieId'] as int).compareTo(b['categorieId'] as int));
          break;
        case 'account':
          filteredData.sort(
              (a, b) => (a['compteId'] as int).compareTo(b['compteId'] as int));
          break;
        case 'date':
          filteredData.sort((a, b) =>
              DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
          break;
      }
    }

    // Transformation finale en fonction du critère de tri pour la légende
    List<Map<String, dynamic>> resultData = filteredData.map((entry) {
      String legendeValue;
      switch (sortBy) {
        case 'category':
          legendeValue = entry['categorie'];
          break;
        case 'account':
          legendeValue = entry['compte'];
          break;
        default:
          legendeValue =
              entry['legende']; // Par défaut, la légende reste la date
      }
      return {
        'valeur': entry['valeur'],
        'order': entry['categorieId'],
        'legende': legendeValue,
      };
    }).toList();

    print("Données finales après filtrage : ${resultData.length}");
    return resultData;
  }

  // Fonction pour afficher la boîte de dialogue de filtre
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Variables locales pour stocker les sélections temporaires
        DateTime? localStartDate = _startDate;
        DateTime? localEndDate = _endDate;
        List<int> localSelectedCategories = List<int>.from(_selectedCategories);
        List<int> localSelectedAccounts = List<int>.from(_selectedAccounts);
        String localSortBy = _sortBy;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Filtrer les dépenses"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sélection de la date de début
                    ListTile(
                      title: const Text("Date de début"),
                      trailing: const Icon(Icons.calendar_today),
                      subtitle: Text(localStartDate != null
                          ? localStartDate.toString().split(' ')[0]
                          : 'Pas de date sélectionnée'),
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            localStartDate = selectedDate;
                          });
                        }
                      },
                    ),

                    // Sélection de la date de fin
                    ListTile(
                      title: const Text("Date de fin"),
                      trailing: const Icon(Icons.calendar_today),
                      subtitle: Text(localEndDate != null
                          ? localEndDate.toString().split(' ')[0]
                          : 'Pas de date sélectionnée'),
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            localEndDate = selectedDate;
                          });
                        }
                      },
                    ),

                    // Choix multiple des catégories
                    ExpansionTile(
                      title: const Text("Catégories"),
                      children: _categories.map((category) {
                        return CheckboxListTile(
                          title: Text(category.nom),
                          value: localSelectedCategories.contains(category.id),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                localSelectedCategories.add(category.id!);
                              } else {
                                localSelectedCategories.remove(category.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),

                    // Choix multiple des comptes
                    ExpansionTile(
                      title: const Text("Comptes"),
                      children: _comptes.map((compte) {
                        return CheckboxListTile(
                          title: Text(compte.nom),
                          value: localSelectedAccounts.contains(compte.id),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                localSelectedAccounts.add(compte.id!);
                              } else {
                                localSelectedAccounts.remove(compte.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),

                    // Tri par catégorie, compte ou date
                    ListTile(
                      title: const Text("Trier par"),
                      subtitle: Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text("Date"),
                            value: 'date',
                            groupValue: localSortBy,
                            onChanged: (value) {
                              setState(() {
                                localSortBy = value!;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text("Catégorie"),
                            value: 'category',
                            groupValue: localSortBy,
                            onChanged: (value) {
                              setState(() {
                                localSortBy = value!;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text("Compte"),
                            value: 'account',
                            groupValue: localSortBy,
                            onChanged: (value) {
                              setState(() {
                                localSortBy = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Applique les filtres
                    setState(() {
                      _startDate = localStartDate;
                      _endDate = localEndDate;
                      _selectedCategories = localSelectedCategories;
                      _selectedAccounts = localSelectedAccounts;
                      _sortBy = localSortBy;

                      // Applique le filtre avec les nouvelles sélections
                      fetchDepenses(
                          selectedCategories: _selectedCategories,
                          selectedAccounts: _selectedAccounts);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Appliquer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF0FDFA),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: const Text('Statistiques',
            style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: const Color(0xFFF0FDFA),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text("Vos dernières dépenses !"),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: BarChart(data: _depenses),
            ),
          ),
        ],
      ),
      floatingActionButton: const FloatingAdd(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const UnboringNavBar(),
    );
  }
}
