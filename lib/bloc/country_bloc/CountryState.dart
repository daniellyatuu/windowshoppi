import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:windowshoppi/models/models.dart';

abstract class CountryStates extends Equatable {
  const CountryStates();
  @override
  List<Object> get props => [];
}

class CountryEmpty extends CountryStates {}

class CountryLoading extends CountryStates {}

class CountryLoaded extends CountryStates {
  final List<Country> country;

  CountryLoaded({@required this.country}) : assert(country != null);

  @override
  List<Object> get props => [country];
}

class CountryError extends CountryStates {}
