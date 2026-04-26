class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final String category;
  final String shippingInformation;
  final String warrantyInformation;
  final String returnPolicy;
  final String availabilityStatus;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.category,
    required this.shippingInformation,
    required this.warrantyInformation,
    required this.returnPolicy,
    required this.availabilityStatus,
    required this.rating,
  });
}
