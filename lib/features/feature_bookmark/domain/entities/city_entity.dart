import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@entity
class City extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;

  City(this.name, {this.id});

  @override
  List<Object?> get props => [id, name];
}