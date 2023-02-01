// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CatalogModel _$CatalogModelFromJson(Map<String, dynamic> json) => CatalogModel(
      articleName: json['article_name'] as String,
      mainDescriptions: json['main_descriptions'] as String,
      isActive: json['is_active'] as bool,
      mainModel: json['main_model'] as int,
      localCost: json['local_cost'] as int,
      nationalCost: json['national_cost'] as int,
      image: json['image'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$CatalogModelToJson(CatalogModel instance) =>
    <String, dynamic>{
      'article_name': instance.articleName,
      'main_descriptions': instance.mainDescriptions,
      'is_active': instance.isActive,
      'main_model': instance.mainModel,
      'local_cost': instance.localCost,
      'national_cost': instance.nationalCost,
      'image': instance.image,
      'id': instance.id,
    };
