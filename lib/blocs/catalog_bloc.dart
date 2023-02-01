import 'package:bloc/bloc.dart';
import 'package:flutter_catalog/services/catalog_app.dart';
import 'package:flutter_catalog/view/catalog/catalog_event.dart';
import 'package:flutter_catalog/view/catalog/catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final _catalog = CatalogApp();

  CatalogBloc() : super(InitialState()) {
    on<GetCatalogEvent>((event, emit) async {
      try {
        emit(ArticlesLoadingState());
        var catalogData = await _catalog.getCatalogData();
        if (catalogData.items.isNotEmpty) return emit(ArticlesReceivedState(items: catalogData));
        return emit(NoArticlesState());
      } catch (exception) {
        return emit(ErrorState(error: exception.toString()));
      }
    });
  }

}
