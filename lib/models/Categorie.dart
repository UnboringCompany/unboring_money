class Categorie {
  final int? id;
  final String nom;
  final int limite;

  Categorie({this.id, required this.nom, required this.limite});

  // Convert a Categorie into a Map.
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'limite': limite
    };
  }
}