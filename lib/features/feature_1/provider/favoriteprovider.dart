import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  List<int> favoritedIndexes = [];

  void toggleFavorite(int index) {
    if (favoritedIndexes.contains(index)) {
      favoritedIndexes.remove(index);
    } else {
      favoritedIndexes.add(index);
    }
    notifyListeners();
  }
}
