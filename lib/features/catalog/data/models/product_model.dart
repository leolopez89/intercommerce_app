import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intercommerce_app/features/catalog/domain/entities/product.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required int id,
    required String title,
    required String description,
    required double price,
    required String thumbnail,
    required String category,
    required String shippingInformation,
    required String warrantyInformation,
    required String returnPolicy,
    required String availabilityStatus,
    required double rating,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Product toEntity() => Product(
    id: id,
    title: title,
    description: description,
    price: price,
    thumbnail: thumbnail,
    category: category,
    shippingInformation: shippingInformation,
    warrantyInformation: warrantyInformation,
    returnPolicy: returnPolicy,
    availabilityStatus: availabilityStatus,
    rating: rating,
  );
}
