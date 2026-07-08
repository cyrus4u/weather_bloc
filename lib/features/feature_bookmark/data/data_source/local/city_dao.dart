import 'package:floor/floor.dart';
import 'package:weather_bloc/features/feature_bookmark/domain/entities/city_entity.dart';

@dao
// DAO = Data Access Object
// This abstract class defines all database operations for the City table.
// Floor will automatically generate the real implementation — you never write the method bodies yourself.
abstract class CityDao {
  // Retrieves every row from the City table.
  // Returns a list of all saved cities — used in BookmarkScreen to show the watchlist.
  @Query('SELECT * FROM City')
  Future<List<City>> getAllCity();

  // Searches the City table for a row where the name column matches the given [name].
  // Returns null if no city is found — used to decide if the star icon should be filled or empty.
  // :name is a placeholder — Floor replaces it with the actual String value at runtime.
  @Query('SELECT * FROM City WHERE name = :name')
  Future<City?> findCityByName(String name);

  // Inserts a new City row into the table.
  // @insert tells Floor to generate the INSERT SQL automatically — no query needed.
  // Returns void because we don't need anything back after saving.
  @insert
  Future<void> insertCity(City city);

  // Deletes the row from the City table where the name matches.
  // Used when the user taps the trash icon in BookmarkScreen.
  // :name is replaced at runtime — only the matching city is removed, not all cities.
  @Query('DELETE FROM City WHERE name = :name')
  Future<void> deleteCityByName(String name);
}
