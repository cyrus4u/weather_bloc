import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/features/feature_bookmark/presentation/bloc/bloc/bookmark_bloc.dart';
import 'package:weather_bloc/features/feature_bookmark/presentation/bloc/bloc/get_city_status.dart';
import 'package:weather_bloc/features/feature_bookmark/presentation/bloc/bloc/save_city_status.dart';

class BookMarkIcon extends StatelessWidget {
  final String name;

  const BookMarkIcon({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookmarkBloc, BookmarkState>(
      listenWhen: (previous, current) =>
          previous.saveCityStatus != current.saveCityStatus,

      buildWhen: (previous, current) =>
          previous.getCityStatus != current.getCityStatus ||
          previous.saveCityStatus != current.saveCityStatus,

      listener: (context, state) {
        if (state.saveCityStatus is SaveCityCompleted) {
          final data = state.saveCityStatus as SaveCityCompleted;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${data.city.name} Added to Bookmark")),
          );

          // ✅ re-check DB so isSaved updates and star fills immediately
          // After saving successfully, ask the DB again:
          // "Hey, is this city saved now?" → updates getCityStatus → star fills ⭐
          context.read<BookmarkBloc>().add(GetCityByNameEvent(name));
          // Reset saveCityStatus back to its original state
          // so the snackbar doesn't show again next time anything changes
          context.read<BookmarkBloc>().add(SaveCityInitialEvent());
        }

        if (state.saveCityStatus is SaveCityError) {
          final error = state.saveCityStatus as SaveCityError;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.message ?? "")));
        }
      },
      builder: (context, state) {
        if (state.saveCityStatus is SaveCityLoading) {
          return const CircularProgressIndicator();
        }

        bool isSaved = false;

        if (state.getCityStatus is GetCityCompleted) {
          final result = state.getCityStatus as GetCityCompleted;

          isSaved = result.city != null;
        }

        return IconButton(
          onPressed: () {
            context.read<BookmarkBloc>().add(SaveCwEvent(name));
          },

          icon: Icon(
            isSaved ? Icons.star : Icons.star_border,

            color: Colors.white,
            size: 35,
          ),
        );
      },
    );
  }
}
