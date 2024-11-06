class Compte {
  final int? id;
  final String nom;

  Compte({this.id, required this.nom});

  // Convert a Compte into a Map.
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
    };
  }
}