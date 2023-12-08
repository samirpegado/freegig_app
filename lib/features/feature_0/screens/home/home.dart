import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:freegig_app/common/functions/navigation.dart';
import 'package:freegig_app/features/feature_0/widgets/gigs/notifications.dart';
import 'package:freegig_app/features/feature_0/widgets/home/home_search_cards.dart';
import 'package:freegig_app/services/relationship/user_invitation.dart';
import 'package:freegig_app/services/relationship/user_rate.dart';
import 'package:freegig_app/services/relationship/user_request.dart';
import 'package:freegig_app/features/feature_0/widgets/home/home_pageview.dart';
import 'package:freegig_app/common/themeapp.dart';
import 'package:iconsax/iconsax.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int notification = 0;

  @override
  void initState() {
    super.initState();

    loadNotifications();
  }

  Future<void> loadNotifications() async {
    List<Map<String, dynamic>> requests =
        await UserRequest().listRequestsByGigOwner();
    List<Map<String, dynamic>> invitations =
        await UserInvitation().getReceivedInvitation();
    List<Map<String, dynamic>> rateNotifications =
        await UserRateService().getRateNotifications();

    if (mounted) {
      setState(() {
        // Atualize o estado apenas se a página estiver montada
        notification =
            requests.length + invitations.length + rateNotifications.length;
      });
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
              height: 420,
              child: Stack(
                children: [
                  _carouselSlider(),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: _notificationButton(),
                  ),
                  Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    child: HomeSearchCards(),
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

  Widget _carouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 380,
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
    );
  }

  Widget _notificationButton() {
    return Visibility(
      visible: notification != 0 ? true : false,
      child: InkWell(
        onTap: () {
          navigationFadeTo(context: context, destination: GigsNotification());
        },
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.5),
              ),
              child: Center(
                child: Icon(
                  Iconsax.notification5,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 3,
              left: 28,
              child: Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    notification < 10 ? '$notification' : '9+',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 7.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
