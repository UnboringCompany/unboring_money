class Depense {
  final int? id;
  final String titre;
  final int categorieId;
  final double montant;
  final String date;
  final int compteId;

  Depense({
    this.id,
    required this.titre,
    required this.categorieId,
    required this.montant,
    required this.date,
    required this.compteId,
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
    };
  }
}