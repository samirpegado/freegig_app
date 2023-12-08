import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/widgets/home/home_customcard.dart';
import 'package:freegig_app/features/feature_1/screens/1_listmusicians.dart';
import 'package:freegig_app/features/feature_2/screens/1_listgigs.dart';
import 'package:freegig_app/services/current_user/current_user_service.dart';
import 'package:freegig_app/services/search/search_service.dart';

class HomeSearchCards extends StatefulWidget {
  const HomeSearchCards({
    super.key,
  });

  @override
  State<HomeSearchCards> createState() => _HomeSearchCardsState();
}

class _HomeSearchCardsState extends State<HomeSearchCards> {
  final _searchService = SearchService();
  late Map<String, dynamic> userData = {};
  late String _city = "";
  late String _category = "";
  late String _profileCategory = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic> userData =
          await UserDataService().getCurrentUserData();

      setState(() {
        _city = userData['city'];
        _category = userData['category'];
        _profileCategory = 'Todos';
      });
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 30),
        HomeCustomCard(
          buttonText: "Buscar músicos",
          destination: ListMusicians(
            profileListFunction: _searchService.getAvalibleProfiles(
                category: _profileCategory, city: _city),
            city: _city,
            category: _profileCategory,
          ),
          imgCard: 'assets/images/musicos.png',
        ),
        SizedBox(width: 30),
        HomeCustomCard(
          buttonText: "Buscar GIGs",
          destination: ListGigs(
            dataListFunction: _searchService.getAvalibleGigs(
                city: _city, category: _category),
            city: _city,
            category: _category,
          ),
          imgCard: 'assets/images/encontrar.png',
        ),
        SizedBox(width: 30),
      ],
    );
  }
}
