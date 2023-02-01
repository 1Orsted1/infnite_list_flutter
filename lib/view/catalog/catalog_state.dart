import 'package:equatable/equatable.dart';
import 'package:flutter_catalog/blocs/catalog_bloc.dart';
import 'package:flutter_catalog/models/catalog/catalog_model.dart';
import 'package:flutter_catalog/models/list/item_list.dart';

abstract class CatalogState extends Equatable {
  //Equatable help us comparing objects later on
  const CatalogState();

  @override
  List<Object?> get props => [];
}

class InitialState extends CatalogState {}

class ArticlesLoadingState extends CatalogState {}

class ArticlesReceivedState extends CatalogState {
  const ArticlesReceivedState({required this.items});
  final ItemList items;
}

class NoArticlesState extends CatalogState{}

class ErrorState extends CatalogState {
  final String error;

  const ErrorState({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => "Catalog error ${error.toString().toUpperCase()}";
}
