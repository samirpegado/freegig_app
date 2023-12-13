import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/features/feature_0/screens/profiles/profileswitcher.dart';
import 'package:freegig_app/services/notification/notifications_service.dart';
import 'package:iconsax/iconsax.dart';
import 'package:freegig_app/features/feature_0/screens/gigs/gigs.dart';
import 'package:freegig_app/features/feature_0/screens/home/home.dart';
import 'package:freegig_app/features/feature_0/screens/messages/messages.dart';

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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (selectedIndex == 0) {
          // Se a página atual for a Home, chama SystemNavigator.pop()
          SystemNavigator.pop();
        } else if (selectedIndex == 2) {
          NotificationService().removeMessageNotification();
          navigationFadeTo(
              context: context, destination: NavigationMenu(navPage: 0));
        } else {
          // Se não, navega para outra instância de NavigationMenu com navPage: 0
          navigationFadeTo(
              context: context, destination: NavigationMenu(navPage: 0));
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
