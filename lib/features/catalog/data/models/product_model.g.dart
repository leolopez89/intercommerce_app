// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'] as String,
      category: json['category'] as String,
      shippingInformation: json['shippingInformation'] as String,
      warrantyInformation: json['warrantyInformation'] as String,
      returnPolicy: json['returnPolicy'] as String,
      availabilityStatus: json['availabilityStatus'] as String,
      rating: (json['rating'] as num).toDouble(),
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'thumbnail': instance.thumbnail,
      'category': instance.category,
      'shippingInformation': instance.shippingInformation,
      'warrantyInformation': instance.warrantyInformation,
      'returnPolicy': instance.returnPolicy,
      'availabilityStatus': instance.availabilityStatus,
      'rating': instance.rating,
    };
