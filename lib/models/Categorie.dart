class Categorie {
  final int? id;
  final String nom;
  final String description;

  Categorie({this.id, required this.nom, required this.description});

  // Convert a Categorie into a Map.
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'description': description,
    };
  }
}