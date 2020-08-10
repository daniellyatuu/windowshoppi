class Product {
  int id, bussiness;
  final accountName, callNumber, whatsappNumber, businessLocation, caption;
  final List<Images> productPhoto;

  Product({
    this.id,
    this.bussiness,
    this.accountName,
    this.callNumber,
    this.whatsappNumber,
    this.businessLocation,
    this.caption,
    this.productPhoto,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      bussiness: json['bussiness'],
      accountName: json['account_name'],
      callNumber: json['call_number'],
      whatsappNumber:
          json['whatsapp_number'] != null ? json['whatsapp_number'] : null,
      businessLocation: json['business_location'],
      caption: json['caption'],
      productPhoto:
          (json['post_photos'] as List).map((i) => Images.fromJson(i)).toList(),
    );
  }
}

class Images {
  final String filename;

  Images({this.filename});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      filename: json['filename'],
    );
  }
}
