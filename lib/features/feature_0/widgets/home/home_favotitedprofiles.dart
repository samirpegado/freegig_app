import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_1/provider/favoriteprovider.dart';
import 'package:freegig_app/data/data.dart';
import 'package:provider/provider.dart';

class FavoriteMusiciansList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoritedMusicians = favoritesProvider.favoritedIndexes;

    return favoritedMusicians.isEmpty
        ? Center(
            child: Text('Nenhum músico favoritado.'),
          )
        : ListView.builder(
            itemCount: favoritedMusicians.length,
            itemBuilder: (context, index) {
              final profile = profiles[favoritedMusicians[index]];

              return ListTile(
                contentPadding: EdgeInsets.only(bottom: 15),
                leading: ClipOval(
                  child: Image.asset(
                    profile.image,
                    width: 57,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(profile.name),
                trailing: IconButton(
                    icon: Icon(Icons.delete), // Ícone de remoção
                    onPressed: () {
                      // Execute a ação de remoção aqui
                      favoritesProvider
                          .toggleFavorite(favoritedMusicians[index]);
                    }),
              );
            },
          );
  }
}
