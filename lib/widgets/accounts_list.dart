import 'package:flutter/material.dart';
import 'package:unboring_money/widgets/account_item.dart';

class AccountsList extends StatefulWidget {

  final Map accountsList;
  
  const AccountsList({super.key, required this.accountsList});

  @override
  _AccountsListState createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
        color: const Color(0xFFCDFAF0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: widget.accountsList.length,
                itemBuilder: (context, index) {
                  // Récupérer la clé (Compte) et la valeur (dépense) à partir de la Map
                  final compte = widget.accountsList.keys.elementAt(index);
                  final spent = widget.accountsList[compte];

                  return AccountItem(
                    name: compte.nom,  // Assure-toi que 'nom' est défini dans Compte
                    spent: spent ?? 0,   // Utiliser la dépense associée
                    icon: Icons.account_balance_wallet,
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
