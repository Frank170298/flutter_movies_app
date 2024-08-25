// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:frank_salazar/page/AddMovieForm.dart';
import 'package:frank_salazar/page/list_movies.dart';
import 'package:frank_salazar/page/splashscreen/share/app_asset.dart';
import 'package:frank_salazar/page/splashscreen/welcome/welcome_screen_second.dart';
import 'package:frank_salazar/page/widgets/bottom_item_modal.dart';
import 'package:rive/rive.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

import 'constant/constant.dart';
import 'model/movie.dart';
import 'page/detail_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: WelcomeScreenSecond.route,
      routes: {
        WelcomeScreenSecond.route: (context) => const WelcomeScreenSecond(),
        MyHomePage.route: (context) => const MyHomePage()
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'lol',
        textTheme: textTheme,
      ),
      home: const WelcomeScreenSecond(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  static String route = 'home-screen';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String searchText = "";
  List<SMIBool> riveIconsInputs = [];
  List<StateMachineController?> controllers = [];
  int selectedNavIndex = 0;
  List<String?> pages = ["Chat", "Search", "ChNotification", "Profile"];

  void animatedTheIcon(int index) {
    if (index >= 0 && index < riveIconsInputs.length) {
      riveIconsInputs[index].change(true);
      Future.delayed(const Duration(seconds: 1), () {
        riveIconsInputs[index].change(false);
      });
    }
  }

  void riveOnInit(Artboard artboard, {required String stateMachineName}) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, stateMachineName);

    if (controller != null) {
      artboard.addController(controller);
      controllers.add(controller);
      riveIconsInputs.add(controller.findInput<bool>('active') as SMIBool);
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final champions = movies.values.toList();
    final filteredMovies = champions.where((movie) {
      return movie.title.toLowerCase().contains(searchText.toLowerCase()) ||
          movie.genre.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    List<Widget> pagesContent = [
      SafeArea(
        child: Column(
          children: <Widget>[
            Image.asset(
              AppAsset.logoSecondary2,
              width: 90.0,
              height: 90.0,
            ),
            Expanded(
              child: Container(
                child: VerticalCardPager(
                  titles:
                      filteredMovies.map((e) => e.title.toUpperCase()).toList(),
                  images: filteredMovies
                      .map((e) => Hero(
                            tag: e.title.toUpperCase(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                e.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))
                      .toList(),
                  onPageChanged: (page) {},
                  onSelectedItem: (index) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailMovie(
                                champion: filteredMovies[index],
                              )),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      AddMovieForm(
        onMovieAdded: (Movie) {},
      ),
      const ListMovieScreen()
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: pagesContent[selectedNavIndex],
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: 62,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 7, 72, 250).withOpacity(0.8),
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                  color: const Color.fromARGB(255, 7, 72, 250).withOpacity(0.3),
                  offset: const Offset(0, 20),
                  blurRadius: 20)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(bottomNavItems.length, (index) {
            final riveIcon = bottomNavItems[index].rive;
            return GestureDetector(
              onTap: () {
                animatedTheIcon(index);
                setState(() {
                  selectedNavIndex = index;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBar(
                    isActive: selectedNavIndex == index,
                  ),
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: Opacity(
                      opacity: selectedNavIndex == index ? 1 : 0.5,
                      child: RiveAnimation.asset(
                        riveIcon.src,
                        artboard: bottomNavItems[index].rive.artboard,
                        onInit: (artboard) {
                          riveOnInit(artboard,
                              stateMachineName: riveIcon.stateMachineName);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      )),
    );
  }

  Widget buildNavBarItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        // Acción cuando se presiona el ítem
      },
      child: Column(
        children: [Icon(icon), Text(label)],
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}
