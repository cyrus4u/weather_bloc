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
                  suggestionsCallback: getSuggestionCityUsecase,
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
                          // Flexible(
                          //   flex: 1,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //     children: [
                          //       _buildStatColumn(
                          //         'Wind',
                          //         '${city?.wind?.speed ?? 0} m/s',
                          //         height,
                          //       ),
                          //       _buildStatColumn(
                          //         'Sunrise',
                          //         DateConverter.changeDtToDateTimeHour(
                          //           city?.sys?.sunrise ?? 0,
                          //           city?.timezone ?? 0,
                          //         ),
                          //         height,
                          //       ),
                          //       _buildStatColumn(
                          //         'Sunset',
                          //         DateConverter.changeDtToDateTimeHour(
                          //           city?.sys?.sunset ?? 0,
                          //           city?.timezone ?? 0,
                          //         ),
                          //         height,
                          //       ),
                          //       _buildStatColumn(
                          //         'Humidity',
                          //         '${city?.main?.humidity ?? 0}%',
                          //         height,
                          //       ),
                          //     ],
                          //   ),
                          // ),
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

  // // helper function
  // Column _buildStatColumn(String label, String value, double height) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Text(
  //         label,
  //         style: TextStyle(fontSize: height * 0.017, color: Colors.amber),
  //       ),
  //       SizedBox(height: 8),
  //       Text(
  //         value,
  //         style: TextStyle(fontSize: height * 0.016, color: Colors.white),
  //       ),
  //     ],
  //   );
  // }

  // Widget build(BuildContext context) {
  //   final height = MediaQuery.of(context).size.height;
  //   final width = MediaQuery.of(context).size.width;
  //   return Center(
  //     child: SafeArea(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           SizedBox(height: height * .02),
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: width * .03),
  //             child: TypeAheadField<Data>(
  //               builder: (context, controller, focusNode) {
  //                 return TextField(
  //                   controller: controller,
  //                   focusNode: focusNode,
  //                   style: const TextStyle(color: Colors.white),
  //                   decoration: const InputDecoration(
  //                     contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
  //                     hintText: "Enter a City...",
  //                     hintStyle: TextStyle(color: Colors.white),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderSide: BorderSide(color: Colors.white),
  //                     ),
  //                     enabledBorder: OutlineInputBorder(
  //                       borderSide: BorderSide(color: Colors.white),
  //                     ),
  //                   ),
  //                 );
  //               },

  //               suggestionsCallback: (String prefix) {
  //                 return getSuggestionCityUsecase(prefix);
  //               },

  //               itemBuilder: (context, Data model) {
  //                 return ListTile(
  //                   leading: const Icon(Icons.location_on),
  //                   title: Text(model.name!),
  //                   subtitle: Text("${model.region!}, ${model.country!}"),
  //                 );
  //               },

  //               onSelected: (Data model) {
  //                 textEditingController.text = model.name!;

  //                 context.read<HomeBloc>().add(LoadCwEvent(model.name!));

  //                 context.read<HomeBloc>().add(LoadFwEvent(model.name!));
  //               },
  //             ),
  //           ),
  //           // main UI
  //           BlocBuilder<HomeBloc, HomeState>(
  //             builder: (context, state) {
  //               if (state is HomeLoading) {
  //                 return Expanded(child: DotLoadingWidget());
  //               } else if (state is HomeCompleted) {
  //                 final city = state.city;
  //                 return Expanded(
  //                   child: ListView(
  //                     children: [
  //                       Padding(
  //                         padding: EdgeInsets.only(top: height * .02),
  //                         child: SizedBox(
  //                           width: width,
  //                           height: height * .6,
  //                           child: PageView.builder(
  //                             physics: AlwaysScrollableScrollPhysics(),
  //                             allowImplicitScrolling: true,
  //                             controller: _pageController,
  //                             itemCount: 2,
  //                             itemBuilder: (context, position) {
  //                               if (position == 0) {
  //                                 return Column(
  //                                   children: [
  //                                     Padding(
  //                                       padding: EdgeInsets.only(top: 50),
  //                                       child: Text(
  //                                         city!.name ?? 'City not loaded',
  //                                         style: const TextStyle(
  //                                           color: Colors.white,
  //                                           fontSize: 30,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Padding(
  //                                       padding: EdgeInsets.only(top: 20),
  //                                       child: Text(
  //                                         '${city.weather![0].description}',
  //                                         style: TextStyle(
  //                                           color: Colors.grey,
  //                                           fontSize: 20,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     Padding(
  //                                       padding: EdgeInsets.only(top: 20),
  //                                       child: AppBackground.setIconForMain(
  //                                         '${city.weather![0].description}',
  //                                       ),
  //                                     ),
  //                                     Padding(
  //                                       padding: EdgeInsets.only(top: 50),
  //                                       child: Text(
  //                                         '${city.main!.temp!.round()}°',
  //                                         style: TextStyle(
  //                                           color: Colors.white,
  //                                           fontSize: 50,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     SizedBox(height: 20),
  //                                     Row(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.center,
  //                                       children: [
  //                                         /// max temp
  //                                         Column(
  //                                           children: [
  //                                             Text(
  //                                               'Max',
  //                                               style: TextStyle(
  //                                                 fontSize: 16,
  //                                                 color: Colors.grey,
  //                                               ),
  //                                             ),
  //                                             SizedBox(height: 20),
  //                                             Text(
  //                                               '${city.main!.tempMax!.round()}°',
  //                                               style: TextStyle(
  //                                                 color: Colors.white,
  //                                                 fontSize: 16,
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),

  //                                         /// divider
  //                                         Padding(
  //                                           padding: EdgeInsets.symmetric(
  //                                             horizontal: 10,
  //                                           ),
  //                                           child: Container(
  //                                             color: Colors.grey,
  //                                             width: 2,
  //                                             height: 40,
  //                                           ),
  //                                         ),

  //                                         /// min temp
  //                                         Column(
  //                                           children: [
  //                                             Text(
  //                                               'min',
  //                                               style: TextStyle(
  //                                                 fontSize: 16,
  //                                                 color: Colors.grey,
  //                                               ),
  //                                             ),
  //                                             SizedBox(height: 20),
  //                                             Text(
  //                                               '${city.main!.tempMin!.round()}°',
  //                                               style: TextStyle(
  //                                                 color: Colors.white,
  //                                                 fontSize: 16,
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 );
  //                               } else {
  //                                 return Container(color: Colors.amber);
  //                               }
  //                             },
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(height: 20),

  //                       Center(
  //                         child: SmoothPageIndicator(
  //                           controller: _pageController,
  //                           // PageController
  //                           count: 2,
  //                           effect: const ExpandingDotsEffect(
  //                             dotWidth: 10,
  //                             dotHeight: 10,
  //                             spacing: 5,
  //                             activeDotColor: Colors.white,
  //                           ),
  //                           // your preferred effect
  //                           onDotClicked: (index) =>
  //                               _pageController.animateToPage(
  //                                 index,
  //                                 duration: const Duration(microseconds: 500),
  //                                 curve: Curves.bounceOut,
  //                               ),
  //                         ),
  //                       ),

  //                       /// divider
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 30),
  //                         child: Container(
  //                           color: Colors.white24,
  //                           height: 2,
  //                           width: double.infinity,
  //                         ),
  //                       ),

  // /// forecast weather 7 days
  // Padding(
  //   padding: const EdgeInsets.only(top: 15),
  //   child: SizedBox(
  //     width: double.infinity,
  //     height: 100,
  //     child: Padding(
  //       padding: const EdgeInsets.only(left: 10.0),
  //       child: Center(
  //         child: BlocBuilder<HomeBloc, HomeState>(
  //           builder: (BuildContext context, state) {
  //             /// show Loading State for Fw
  //             if (state is HomeLoading) {
  //               return const DotLoadingWidget();
  //             }

  //             /// show Completed State for Fw
  //             if (state is HomeCompleted) {
  //               /// cast

  //               final ForecastDaysEntity? forecast =
  //                   state.forecast;

  //               if (forecast == null) {
  //                 return const Center(
  //                   child: Text('Forecast not loaded'),
  //                 );
  //               }
  //               print('forecast = ${state.forecast}');

  //               final List<ForecastItem> mainDaily =
  //                   forecast.list ?? [];
  //               return ListView.builder(
  //                 shrinkWrap: true,
  //                 scrollDirection: Axis.horizontal,
  //                 itemCount: mainDaily.length,
  //                 itemBuilder:
  //                     (BuildContext context, int index) {
  //                       return DaysWeatherView(
  //                         daily: mainDaily[index],
  //                       );
  //                     },
  //               );
  //             }

  //             /// show Error State for Fw
  //             if (state is HomeError) {
  //               return Center(child: Text(state.message));
  //             }

  //             /// show Default State for Fw
  //             return Container();
  //           },
  //         ),
  //       ),
  //     ),
  //   ),
  // ),

  //                       /// divider
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 15),
  //                         child: Container(
  //                           color: Colors.white24,
  //                           height: 2,
  //                           width: double.infinity,
  //                         ),
  //                       ),

  //                       SizedBox(height: 30),

  //                       /// last Row
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Column(
  //                             children: [
  //                               Text(
  //                                 "wind speed",
  //                                 style: TextStyle(
  //                                   fontSize: height * 0.017,
  //                                   color: Colors.amber,
  //                                 ),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(top: 10.0),
  //                                 child: Text(
  //                                   "${city!.wind?.speed ?? 0} m/s",

  //                                   style: TextStyle(
  //                                     fontSize: height * 0.016,
  //                                     color: Colors.white,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 10),
  //                             child: Container(
  //                               color: Colors.white24,
  //                               height: 30,
  //                               width: 2,
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 10.0),
  //                             child: Column(
  //                               children: [
  //                                 Text(
  //                                   "sunrise",
  //                                   style: TextStyle(
  //                                     fontSize: height * 0.017,
  //                                     color: Colors.amber,
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(top: 10.0),
  //                                   child: Text(
  //                                     DateConverter.changeDtToDateTimeHour(
  //                                       city.sys?.sunrise ?? 0,
  //                                       city.timezone ?? 0,
  //                                     ),
  //                                     style: TextStyle(
  //                                       fontSize: height * 0.016,
  //                                       color: Colors.white,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 10),
  //                             child: Container(
  //                               color: Colors.white24,
  //                               height: 30,
  //                               width: 2,
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 10.0),
  //                             child: Column(
  //                               children: [
  //                                 Text(
  //                                   "sunset",
  //                                   style: TextStyle(
  //                                     fontSize: height * 0.017,
  //                                     color: Colors.amber,
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(top: 10.0),
  //                                   child: Text(
  //                                     DateConverter.changeDtToDateTimeHour(
  //                                       city.sys?.sunset ?? 0,
  //                                       city.timezone ?? 0,
  //                                     ),
  //                                     style: TextStyle(
  //                                       fontSize: height * 0.016,
  //                                       color: Colors.white,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 10),
  //                             child: Container(
  //                               color: Colors.white24,
  //                               height: 30,
  //                               width: 2,
  //                             ),
  //                           ),
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 10.0),
  //                             child: Column(
  //                               children: [
  //                                 Text(
  //                                   "humidity",
  //                                   style: TextStyle(
  //                                     fontSize: height * 0.017,
  //                                     color: Colors.amber,
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(top: 10.0),
  //                                   child: Text(
  //                                     "${city.main!.humidity!}%",
  //                                     style: TextStyle(
  //                                       fontSize: height * 0.016,
  //                                       color: Colors.white,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),

  //                       SizedBox(height: 30),
  //                     ],
  //                   ),
  //                 );
  //               } else if (state is HomeError) {
  //                 return Center(child: Text(state.message));
  //               }

  //               return Container();
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
