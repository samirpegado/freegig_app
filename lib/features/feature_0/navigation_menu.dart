import 'package:flutter/material.dart';
import 'package:freegig_app/features/feature_0/screens/4_profileswitcher.dart';
import 'package:iconsax/iconsax.dart';
import 'package:freegig_app/features/feature_0/screens/2_gigs.dart';
import 'package:freegig_app/features/feature_0/screens/1_home.dart';
import 'package:freegig_app/features/feature_0/screens/3_messages.dart';

class NavigationMenu extends StatefulWidget {
  final int navPage;
  const NavigationMenu({Key? key, this.navPage = 0}) : super(key: key);

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.navPage;
  }

  void onDestinationSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        iconSize: 30,
        unselectedItemColor: Colors.black45,
        currentIndex: selectedIndex,
        onTap: onDestinationSelected,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Iconsax.home5),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Iconsax.music_dashboard5),
            label: 'GIGs',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Iconsax.message5),
            label: 'Mensagens',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Iconsax.tag_user5),
            label: 'Perfil',
          ),
        ],
      ),
      body: _buildPage(selectedIndex),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Home();
      case 1:
        return GIGs();
      case 2:
        return Messages();
      case 3:
        return ProfileSwitcher();
      default:
        return Home();
    }
  }
}
