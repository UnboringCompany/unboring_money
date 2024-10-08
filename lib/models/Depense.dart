class Depense {
  final int? id;
  final String titre;
  final String type;
  final double montant;
  final DateTime date;
  final int compteId;
  final String recurrence;

  Depense({
    this.id,
    required this.titre,
    required this.type,
    required this.montant,
    required this.date,
    required this.compteId,
    required this.recurrence,
  });

  // Convert a Depense into a Map.
  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'type': type,
      'montant': montant,
      'date': date,
      'compteId': compteId,
      'recurrence': recurrence,
    };
  }
}