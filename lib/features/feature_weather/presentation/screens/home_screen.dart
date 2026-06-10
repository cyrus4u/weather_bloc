import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_bloc/core/utils/date_converter.dart';
import 'package:weather_bloc/core/widgets/app_background.dart';
import 'package:weather_bloc/core/widgets/dot_loading_widget.dart';
import 'package:weather_bloc/features/feature_weather/data/models/forecast_days_model.dart';
import 'package:weather_bloc/features/feature_weather/data/models/forecast_item.dart';
import 'package:weather_bloc/features/feature_weather/data/models/suggest_city_model.dart';
import 'package:weather_bloc/features/feature_weather/domain/entities/forecast_days_entity.dart';
import 'package:weather_bloc/features/feature_weather/domain/use_cases/get_suggestion_city_usecase.dart';
import 'package:weather_bloc/features/feature_weather/presentation/bloc/bloc/home_bloc.dart';
import 'package:weather_bloc/features/feature_weather/presentation/widgets/day_weather_view.dart';
import 'package:weather_bloc/locator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController searchController;
  GetSuggestionCityUsecase getSuggestionCityUsecase = GetSuggestionCityUsecase(
    locator(),
  );

  String cityName = 'Tehran';
  final PageController _pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(cityName));

    /// start load Fw event
    BlocProvider.of<HomeBloc>(context).add(LoadFwEvent(cityName));
  }

  @override
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      bottom: true, // ensures UI doesn't go under BottomAppBar
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // City search
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * .03,
                  vertical: 8,
                ),
                child: TypeAheadField<Data>(
                  builder: (context, controller, focusNode) {
                    searchController = controller;
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      // maxLines: 2,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        hintText: "Enter a City...",
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    );
                  },
                  suggestionsCallback: getSuggestionCityUsecase.call,
                  itemBuilder: (context, Data model) {
                    return ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(model.name!),
                      subtitle: Text("${model.region!}, ${model.country!}"),
                    );
                  },
                  onSelected: (Data model) {
                    searchController.text = "${model.name}";

                    searchController.selection = TextSelection.fromPosition(
                      TextPosition(offset: searchController.text.length),
                    );
                    context.read<HomeBloc>().add(LoadCwEvent(model.name!));
                    context.read<HomeBloc>().add(LoadFwEvent(model.name!));
                  },
                ),
              ),

              // Main weather UI
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const Center(child: DotLoadingWidget());
                    } else if (state is HomeCompleted) {
                      final city = state.city;

                      return Column(
                        children: [
                          // PageView for current weather
                          Flexible(
                            flex: 8,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: 2,
                              itemBuilder: (context, position) {
                                if (position == 0) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        city?.name ?? 'City not loaded',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '${city?.weather?[0].description ?? ""}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      AppBackground.setIconForMain(
                                        '${city?.weather?[0].description ?? ""}',
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        '${city?.main?.temp?.round() ?? 0}°',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 50,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              const Text(
                                                'Max',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                '${city?.main?.tempMax?.round() ?? 0}°',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 16),
                                          Column(
                                            children: [
                                              const Text(
                                                'Min',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                '${city?.main?.tempMin?.round() ?? 0}°',
                                                style: const TextStyle(
                                                  color: Colors.white,
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

                          // Page indicator
                          Flexible(
                            flex: 1,
                            child: Center(
                              child: SmoothPageIndicator(
                                controller: _pageController,
                                count: 2,
                                effect: const ExpandingDotsEffect(
                                  dotWidth: 10,
                                  dotHeight: 10,
                                  spacing: 5,
                                  activeDotColor: Colors.white,
                                ),
                                onDotClicked: (index) {
                                  _pageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut,
                                  );
                                },
                              ),
                            ),
                          ),
                          // Divider
                          Container(
                            color: Colors.white24,
                            height: 2,
                            width: double.infinity,
                          ),
                          Flexible(
                            flex: 3,
                            child:
                                /// forecast weather 7 days
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                      ),
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

                                              final ForecastDaysEntity?
                                              forecast = state.forecast;

                                              if (forecast == null) {
                                                return const Center(
                                                  child: Text(
                                                    'Forecast not loaded',
                                                  ),
                                                );
                                              }
                                              print(
                                                'forecast = ${state.forecast}',
                                              );

                                              final List<ForecastItem>
                                              mainDaily = forecast.list ?? [];
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: mainDaily.length,
                                                itemBuilder:
                                                    (
                                                      BuildContext context,
                                                      int index,
                                                    ) {
                                                      return DaysWeatherView(
                                                        daily: mainDaily[index],
                                                      );
                                                    },
                                              );
                                            }

                                            /// show Error State for Fw
                                            if (state is HomeError) {
                                              return Center(
                                                child: Text(state.message),
                                              );
                                            }

                                            /// show Default State for Fw
                                            return Container();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                          // Bottom divider
                          Container(
                            color: Colors.white24,
                            height: 2,
                            width: double.infinity,
                          ),

                          // Bottom stats row (wind, sunrise, sunset, humidity)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildInfo(
                                  title: "Wind",
                                  value: "${city?.wind?.speed ?? 0} m/s",
                                  height: height,
                                ),

                                _divider(),

                                _buildInfo(
                                  title: "Sunrise",
                                  value: DateConverter.changeDtToDateTimeHour(
                                    city?.sys?.sunrise ?? 0,
                                    city?.timezone ?? 0,
                                  ),
                                  height: height,
                                ),

                                _divider(),

                                _buildInfo(
                                  title: "Sunset",
                                  value: DateConverter.changeDtToDateTimeHour(
                                    city?.sys?.sunset ?? 0,
                                    city?.timezone ?? 0,
                                  ),
                                  height: height,
                                ),

                                _divider(),

                                _buildInfo(
                                  title: "Humidity",
                                  value: "${city?.main?.humidity ?? 0}%",
                                  height: height,
                                ),
                              ],
                            ),
                          ),
                          
                        ],
                      );
                    } else if (state is HomeError) {
                      return Center(child: Text(state.message));
                    }
                    return Container();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfo({
    required String title,
    required String value,
    required double height,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: height * 0.014, color: Colors.amber),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(fontSize: height * 0.013, color: Colors.white),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 25, color: Colors.white24);
  }

}
