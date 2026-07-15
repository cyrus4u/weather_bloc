part of 'bookmark_bloc.dart';

class BookmarkState extends Equatable {
  final GetCityStatus getCityStatus;
  final SaveCityStatus saveCityStatus;
  final GetAllCityStatus getAllCityStatus;
  final DeleteCityStatus deleteCityStatus;

  const BookmarkState({
    required this.getCityStatus,
    required this.saveCityStatus,
    required this.getAllCityStatus,
    required this.deleteCityStatus,
  });

  BookmarkState copyWith({
    GetCityStatus? getCityStatus,
    SaveCityStatus? saveCityStatus,
    GetAllCityStatus? getAllCityStatus,
    DeleteCityStatus? deleteCityStatus,
  }) {
    return BookmarkState(
      getCityStatus: getCityStatus ?? this.getCityStatus,
      saveCityStatus: saveCityStatus ?? this.saveCityStatus,
      getAllCityStatus: getAllCityStatus ?? this.getAllCityStatus,
      deleteCityStatus: deleteCityStatus ?? this.deleteCityStatus,
    );
  }

  @override
  List<Object> get props => [
    getCityStatus,
    saveCityStatus,
    getAllCityStatus,
    deleteCityStatus,
  ];
}
