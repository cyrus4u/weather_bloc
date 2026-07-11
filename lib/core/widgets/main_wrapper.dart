import 'package:flutter/material.dart';
import 'package:weather_bloc/core/widgets/app_background.dart';
import 'package:weather_bloc/core/widgets/bottom_nav.dart';
import 'package:weather_bloc/features/feature_bookmark/presentation/screens/bookmark_screen.dart';
import 'package:weather_bloc/features/feature_weather/presentation/screens/home_screen.dart';
import 'package:weather_bloc/locator.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({super.key});

  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    List<Widget> pageViewWidget = [
      HomeScreen(getSuggestionCityUsecase: locator()),
      BookmarkScreen(pageController: pageController),
    ];

    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNav(Controller: pageController),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AppBackground.getBackGroundImage(),
            fit: BoxFit.cover,
          ),
        ),
        height: height,
        child: PageView(controller: pageController, children: pageViewWidget),
      ),
    );
  }
}
