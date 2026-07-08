// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:weather_bloc/features/feature_bookmark/data/data_source/local/city_dao.dart';
import 'package:weather_bloc/features/feature_bookmark/domain/entities/city_entity.dart';

part 'database.g.dart'; // the generated code will be there

// @Database tells Floor: "this is the main database class".
// version: 1 → the current version of your database schema.
//   if you later add a new column or table, you increase this to 2, 3, etc.
//   Floor uses this number to run migration code when the app updates.
// entities: [City] → tells Floor which Dart classes are tables.
//   every class listed here becomes a table in SQLite.
//   if you add a new table later (e.g. WeatherCache), you add it here too: entities: [City, WeatherCache]
@Database(version: 1, entities: [City])
// abstract → you don't write the body — Floor generates it in database.g.dart
// extends FloorDatabase → gives this class all the built-in database functionality from Floor
abstract class AppDatabase extends FloorDatabase {
  // This is a getter — it gives access to CityDao from anywhere you have AppDatabase.
  // You don't implement it here — Floor generates the implementation automatically.
  // Usage elsewhere in the app: database.cityDao.getAllCity()
  //                             database.cityDao.insertCity(city)
  CityDao get cityDao;
}
