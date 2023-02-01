import 'package:flutter_catalog/libraries/url_data.dart' as url_data;
import 'package:flutter_catalog/services/helpers/api_base_helper.dart';

import '../models/list/item_list.dart';

class CatalogApp{
  //singleton implementation:
  static final CatalogApp instance = CatalogApp.initial();
  CatalogApp.initial();
  factory CatalogApp() => instance;

  Future<ItemList> getCatalogData() async{
    const String url = url_data.GET_CATALOG;
    ApiService apiService = ApiService(url);
    var response = await apiService.apiGetRequest();
    var data = ItemList.fromJson(response);
    return data;
  }


}
