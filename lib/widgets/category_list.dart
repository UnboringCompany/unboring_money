import 'package:flutter/material.dart';
import 'package:unboring_money/widgets/category_item.dart';

class CategoryList extends StatefulWidget {

  final Map categoryList;
  
  const CategoryList({super.key, required this.categoryList});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
        color: const Color(0xFFCDFAF0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                children: [
                const Text("Toutes les catégories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(width: 5),
                Text("(${widget.categoryList.length})", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: widget.categoryList.length,
                itemBuilder: (context, index) {

                  final category = widget.categoryList.keys.elementAt(index);
                  final spent = widget.categoryList[category];

                  return CategoryItem(
                    name: category.nom,
                    limit: category.limite,
                    spent: spent,
                    icon: Icons.food_bank
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}