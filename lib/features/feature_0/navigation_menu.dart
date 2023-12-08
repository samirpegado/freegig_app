import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freegig_app/features/feature_0/screens/profiles/profileswitcher.dart';
import 'package:iconsax/iconsax.dart';
import 'package:freegig_app/features/feature_0/screens/gigs/gigs.dart';
import 'package:freegig_app/features/feature_0/screens/home/home.dart';
import 'package:freegig_app/features/feature_0/screens/messages/messages.dart';
import 'package:page_transition/page_transition.dart';

class NavigationMenu extends StatefulWidget {
  final int navPage;
  const NavigationMenu({Key? key, this.navPage = 0}) : super(key: key);

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.navPage;
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Inicia a animação após o primeiro frame ser desenhado
      controller.forward();
    });
  }

  void onDestinationSelected(int index) {
    controller.reverse().then((value) {
      setState(() {
        selectedIndex = index;
      });
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex == 0) {
          // Se a página atual for a Home, chama SystemNavigator.pop()
          SystemNavigator.pop();
          return false;
        } else {
          // Se não, navega para outra instância de NavigationMenu com navPage: 0
          Navigator.push(
            context,
            PageTransition(
              duration: Duration(milliseconds: 300),
              type: PageTransitionType.fade,
              child: NavigationMenu(navPage: 0),
            ),
          );

          return false;
        }
      },
      child: Scaffold(
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
      ),
    );
  }

  Widget _buildPage(int index) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.fastEaseInToSlowEaseOut,
        ),
      ),
      child: _getPage(index),
    );
  }

  Widget _getPage(int index) {
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
