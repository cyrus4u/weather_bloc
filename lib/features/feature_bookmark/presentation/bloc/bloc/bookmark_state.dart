part of 'bookmark_bloc.dart';

 class BookmarkState extends Equatable {
  final GetCityStatus getCityStatus;
  final SaveCityStatus saveCityStatus;
  const BookmarkState({
    required this.getCityStatus,
    required this.saveCityStatus,
  });

  BookmarkState copyWith({
    GetCityStatus? newCityStatus,
    SaveCityStatus? newSaveStatus,
  }) {
    return BookmarkState(
      getCityStatus: newCityStatus ?? getCityStatus,
      saveCityStatus: newSaveStatus ?? saveCityStatus,
    );
  }

  @override
  List<Object> get props => [getCityStatus, saveCityStatus];
}


