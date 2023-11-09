import 'package:flutter/material.dart';
import 'package:freegig_app/data/data.dart';
import 'package:freegig_app/features/feature_0/widgets/home/home_favotitedprofiles.dart';
import 'package:freegig_app/common_widgets/themeapp.dart';
import 'package:iconsax/iconsax.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  // declare and initizlize the page controller
  final PageController _pageController = PageController(initialPage: 0);

  // the index of the current page
  int _activePage = 0;

  final List<Widget> _pages = [
    HomeFavoritos(),
    const HomeAgenda(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (int page) {
            setState(() {
              _activePage = page;
            });
          },
          itemCount: _pages.length,
          itemBuilder: (BuildContext context, int index) {
            return _pages[index % _pages.length];
          },
        ),
        Positioned(
          bottom: 25,
          left: 0,
          right: 0,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                  _pages.length,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: InkWell(
                          onTap: () {
                            _pageController.animateToPage(index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          },
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: _activePage == index
                                ? primaryColor
                                : Colors.grey,
                          ),
                        ),
                      )),
            ),
          ),
        ),
      ],
    );
  }
}

class HomeFavoritos extends StatefulWidget {
  @override
  _HomeFavoritosState createState() => _HomeFavoritosState();
}

class _HomeFavoritosState extends State<HomeFavoritos> {
  List<bool> isClickedList = List.filled(profiles.length, false);
  List<Profile> favoritedProfiles = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 30),
            Icon(Iconsax.heart5, color: Colors.red),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Favoritos",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 19.0,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              padding: EdgeInsets.only(left: 10, right: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 211, 211, 211).withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FavoriteMusiciansList()),
        ),
      ],
    );
  }
}

class HomeAgenda extends StatelessWidget {
  const HomeAgenda({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 30),
              Icon(Iconsax.calendar5, color: Color.fromARGB(255, 55, 158, 58)),
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
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              padding: EdgeInsets.all(35),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 211, 211, 211).withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Suas próximas GIGs aparecerão aqui",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
