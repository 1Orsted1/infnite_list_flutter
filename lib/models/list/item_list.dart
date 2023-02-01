import 'package:flutter_catalog/models/catalog/catalog_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_list.g.dart';

@JsonSerializable()
class ItemList {
  final List<CatalogModel> items;

  ItemList(
    this.items,
  );

  factory ItemList.fromJson(List<dynamic> list) => _$ItemListFromJson(list);

  Map<String, dynamic> toJson() => _$ItemListToJson(this);
}
