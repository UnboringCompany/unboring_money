import 'package:flutter/material.dart';
import 'package:unboring_money/widgets/category_item.dart';

class CategoryList extends StatefulWidget {
  
  const CategoryList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  bool showUpcomingTransactions = false;

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
        color: const Color(0xFFCDFAF0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Row(
                children: [
                Text("Toutes les catégories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                SizedBox(width: 5),
                Text("(3)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: [1,2,3].length,
                itemBuilder: (context, index) {
                  return const CategoryItem(
                    name: "Alimentation",
                    limit: 200,
                    spent: 150,
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