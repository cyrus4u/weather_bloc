import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_bloc/core/widgets/app_background.dart';
import 'package:weather_bloc/core/widgets/dot_loading_widget.dart';
import 'package:weather_bloc/features/feature_weather/data/models/forecast_days_model.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/forecast_days_entity.dart';
import 'package:weather_bloc/features/feature_weather/presentation/bloc/bloc/home_bloc.dart';
import 'package:weather_bloc/features/feature_weather/presentation/widgets/day_weather_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(const LoadCwEvent('Tehran'));

    /// start load Fw event
    BlocProvider.of<HomeBloc>(context).add(LoadFwEvent('Tehran'));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Center(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return Expanded(child: DotLoadingWidget());
                } else if (state is HomeCompleted) {
                  final city = state.city;
                  return Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: height * .02),
                          child: SizedBox(
                            width: width,
                            height: height * .6,
                            child: PageView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              allowImplicitScrolling: true,
                              controller: _pageController,
                              itemCount: 2,
                              itemBuilder: (context, position) {
                                if (position == 0) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 50),
                                        child: Text(
                                          '${city!.name}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Text(
                                          '${city.weather![0].description}',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: AppBackground.setIconForMain(
                                          '${city.weather![0].description}',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 50),
                                        child: Text(
                                          '${city.main!.temp!.round()}°',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 50,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          /// max temp
                                          Column(
                                            children: [
                                              Text(
                                                'Max',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                '${city.main!.tempMax!.round()}°',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),

                                          /// divider
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: Container(
                                              color: Colors.grey,
                                              width: 2,
                                              height: 40,
                                            ),
                                          ),

                                          /// min temp
                                          Column(
                                            children: [
                                              Text(
                                                'min',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              SizedBox(height: 20),
                                              Text(
                                                '${city.main!.tempMin!.round()}°',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container(color: Colors.amber);
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            // PageController
                            count: 2,
                            effect: const ExpandingDotsEffect(
                              dotWidth: 10,
                              dotHeight: 10,
                              spacing: 5,
                              activeDotColor: Colors.white,
                            ),
                            // your preferred effect
                            onDotClicked: (index) =>
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(microseconds: 500),
                                  curve: Curves.bounceOut,
                                ),
                          ),
                        ),

                        /// divider
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Container(
                            color: Colors.white24,
                            height: 2,
                            width: double.infinity,
                          ),
                        ),

                        /// forecast weather 7 days
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: SizedBox(
                            width: double.infinity,
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Center(
                                child: BlocBuilder<HomeBloc, HomeState>(
                                  builder: (BuildContext context, state) {
                                    /// show Loading State for Fw
                                    if (state is HomeLoading) {
                                      return const DotLoadingWidget();
                                    }

                                    /// show Completed State for Fw
                                    if (state is HomeCompleted) {
                                      /// cast

                                      final ForecastDaysEntity? forecast =
                                          state.forecast;

                                      if (forecast == null) {
                                        return const Center(
                                          child: Text('Forecast not loaded'),
                                        );
                                      }

                                      final List<Daily> mainDaily =
                                          forecast.daily ?? [];

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: mainDaily.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                              return DaysWeatherView(
                                                daily: mainDaily[index],
                                              );
                                            },
                                      );
                                    }

                                    /// show Error State for Fw
                                    if (state is HomeError) {
                                      return Center(child: Text(state.message));
                                    }

                                    /// show Default State for Fw
                                    return Container();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// divider
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Container(
                            color: Colors.white24,
                            height: 2,
                            width: double.infinity,
                          ),
                        ),

                        SizedBox(height: 30),
                      ],
                    ),
                  );
                } else if (state is HomeError) {
                  return Center(child: Text(state.message));
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
