class Depense {
  final int? id;
  final String titre;
  final int categorieId;
  final double montant;
  final String date;
  final int compteId;
  final String recurrence;

  Depense({
    this.id,
    required this.titre,
    required this.categorieId,
    required this.montant,
    required this.date,
    required this.compteId,
    required this.recurrence,
  });

  // Convert a Depense into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'categorieId': categorieId,
      'montant': montant,
      'date': date,
      'compteId': compteId,
      'recurrence': recurrence,
    };
  }
}