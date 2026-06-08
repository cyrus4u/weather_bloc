import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/core/widgets/main_wrapper.dart';
import 'package:weather_bloc/features/feature_weather/presentation/bloc/bloc/home_bloc.dart';
import 'package:weather_bloc/locator.dart';

void main() async {
  /// init locator
  await setup();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [BlocProvider(create: (context) => locator<HomeBloc>())],
        child: MainWrapper(),
      ),
    ),
  );
}
