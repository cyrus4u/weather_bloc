import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/features/feature_weather/presentation/bloc/bloc/home_bloc.dart';


class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(const LoadCwEvent('Tehran'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: Text('loading...'));
          } else if (state is HomeCompleted) {
            final city = state.city;
            return Center(
              child: Text(
                'Weather loaded for ${city.name}, ${city.main?.temp}°C',
              ),
            );
          } else if (state is HomeError) {
            return Center(child: Text(state.message));
          }

          return Container();
        },
      ),
    );
  }
}