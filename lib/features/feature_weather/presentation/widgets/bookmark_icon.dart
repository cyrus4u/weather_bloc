import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/features/feature_bookmark/presentation/bloc/bloc/bookmark_bloc.dart';
import 'package:weather_bloc/features/feature_bookmark/presentation/bloc/bloc/get_city_status.dart';
import 'package:weather_bloc/features/feature_bookmark/presentation/bloc/bloc/save_city_status.dart';

/// A star icon button that toggles bookmark status for a city.
/// Displays a filled star if the city is saved, outline if not.
class BookMarkIcon extends StatelessWidget {
  final String name;

  const BookMarkIcon({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookmarkBloc, BookmarkState>(
      // Only run the listener (side effects like snackbars) when
      // saveCityStatus actually changes — avoids re-triggering the
      // snackbar/dispatch logic on unrelated state changes (e.g. getCityStatus).
      listenWhen: (previous, current) =>
          previous.saveCityStatus != current.saveCityStatus,

      // Rebuild the UI only when getCityStatus or saveCityStatus change,
      // since those are the only two slices this widget actually renders from.
      buildWhen: (previous, current) =>
          previous.getCityStatus != current.getCityStatus ||
          previous.saveCityStatus != current.saveCityStatus,

      listener: (context, state) {
        // Save just succeeded — show confirmation and refresh saved status.
        if (state.saveCityStatus is SaveCityCompleted) {
          final data = state.saveCityStatus as SaveCityCompleted;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${data.city.name} Added to Bookmark")),
          );

          // ✅ Re-check DB so isSaved updates and star fills immediately.
          // After saving successfully, ask the DB again:
          // "Hey, is this city saved now?" → updates getCityStatus → star fills ⭐
          context.read<BookmarkBloc>().add(GetCityByNameEvent(name));

          // Reset saveCityStatus back to its initial state so the snackbar
          // doesn't fire again on the next unrelated state change.
          context.read<BookmarkBloc>().add(SaveCityInitialEvent());
        }

        // Save failed — show the error message to the user.
        if (state.saveCityStatus is SaveCityError) {
          final error = state.saveCityStatus as SaveCityError;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.message ?? "")));
        }
      },
      builder: (context, state) {
        // While the save request is in flight, show a spinner instead of the icon.
        if (state.saveCityStatus is SaveCityLoading) {
          return const CircularProgressIndicator();
        }

        bool isSaved = false;

        // Determine star fill state from the latest "is this city saved?" check.
        if (state.getCityStatus is GetCityCompleted) {
          final result = state.getCityStatus as GetCityCompleted;

          isSaved = result.city != null;
        }

        return IconButton(
          onPressed: () {
            // Dispatch save event — triggers SaveCityLoading, then
            // Completed/Error, which the listener above reacts to.
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
