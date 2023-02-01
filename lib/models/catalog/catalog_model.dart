import 'package:json_annotation/json_annotation.dart';

part 'catalog_model.g.dart';

@JsonSerializable()
class CatalogModel {
//article_name
  @JsonKey(name: 'article_name')
  final String articleName;

//main_descriptions
  @JsonKey(name: 'main_descriptions')
  final String mainDescriptions;

//is_active
  @JsonKey(name: 'is_active')
  final bool isActive;

//main_model
  @JsonKey(name: 'main_model')
  final int mainModel;

//local_cost
  @JsonKey(name: 'local_cost')
  final int localCost;

//national_cost
  @JsonKey(name: 'national_cost')
  final int nationalCost;

//image
  final String image;

//id
  final String id;

  CatalogModel({
    required this.articleName,
    required this.mainDescriptions,
    required this.isActive,
    required this.mainModel,
    required this.localCost,
    required this.nationalCost,
    required this.image,
    required this.id,
  });
  factory CatalogModel.fromJson(Map<String,dynamic>json) => _$CatalogModelFromJson(json);

  Map<String, dynamic> toJson() => _$CatalogModelToJson(this);

}
