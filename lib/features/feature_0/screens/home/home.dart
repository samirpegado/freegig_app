import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freegig_app/services/search/search_service.dart';
import 'package:freegig_app/services/current_user/current_user_service.dart';
import 'package:freegig_app/features/feature_0/widgets/home/home_customcard.dart';
import 'package:freegig_app/features/feature_0/widgets/home/home_pageview.dart';
import 'package:freegig_app/common/functions/themeapp.dart';
import 'package:freegig_app/features/feature_1/screens/1_listmusicians.dart';
import 'package:freegig_app/features/feature_2/screens/1_listgigs.dart';
import 'package:iconsax/iconsax.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 390,
              child: Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 350,
                      viewportFraction: 1,
                      initialPage: 0,
                      autoPlay: true,
                    ),
                    items: [
                      'assets/images/backimg.png',
                      'assets/images/backimg2.png',
                      'assets/images/backimg3.png',
                      'assets/images/backimg4.png',
                    ].map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return SizedBox(
                            width: double.infinity,
                            child: Image.asset(
                              i,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 30),
                        HomeCustomCard(
                          buttonText: "Buscar músicos",
                          destination: ListMusicians(
                            profileListFunction:
                                _searchService.getAvalibleProfiles(
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
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 30),
                      Icon(Iconsax.calendar5,
                          color: Color.fromARGB(255, 55, 158, 58)),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Suas GIGs",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 19.0,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: HomeAgenda()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
