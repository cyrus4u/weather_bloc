import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/features/feature_weather/presentation/bloc/bloc/cw_status.dart';
import 'package:weather_bloc/features/feature_weather/presentation/bloc/bloc/home_bloc.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent('Tehran'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.cwStatus is CwLoading) {
            return Center(child: Text('loading...'));
          }
          if (state.cwStatus is CwComleted) {
            return Center(child: Text('completed...'));
          }
          if (state.cwStatus is CwError) {
            final error = state.cwStatus as CwError;
            return Center(child: Text(error.message));
          }
          return Container();
        },
      ),
    );
  }
}
