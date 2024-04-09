class PDetailModel {
  final String name;
  final double price;
  final String? details;
  final Map<String, dynamic>? reviews;
  final List<dynamic>? images;
  final int id;
  final int count;
  final String? category;

  PDetailModel(
      {required this.name,
      required this.price,
      this.details,
      this.reviews,
      this.images,
      required this.id,
      required this.count,
      this.category});

  static PDetailModel fromJson(Map<String, dynamic> json) {
    try {
      var b = PDetailModel(
        id: json["id"],
        name: json["name"],
        details: json["details"],
        count: json["count"],
        images: json["images"],
        category: json["category"],
        price: json["price"].toDouble(),
      );
      return b;
    } catch (e) {
      print(e);
      throw Exception("jdfakljf");
    }
  }
}

class ReviewModel {
  final String review;
  final int rating;

  ReviewModel({required this.review, required this.rating});
  Map<String, dynamic> toJson() {
    return {"Review": review, "Rating": rating};
  }
}

class Product {
  final String name;
  final double price;
  final List<dynamic> imageUrl;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'].toDouble(),
      imageUrl: json['images'],
    );
  }

  Product({required this.name, required this.price, required this.imageUrl});
}

class SearchModel {
  final String? searchWord;
  List<String>? filters;
  int? low;
  int? high;
  List<String?>? category;
  int? start;
  int? maxSize;

  SearchModel({
    this.high,
    this.category,
    this.searchWord,
    this.filters,
    this.low,
    this.start,
    this.maxSize,
  });

  Map<String, dynamic> toJson() {
    return {
      if (searchWord != null) "name": searchWord!,
      if (category != null) "categories": category,
      if (low != null) "low": low.toString(),
      if (high != null) "high": high.toString(),
      // if(start!=null)"start": start.toString(),
      // if(maxSize!=null)"maxSize": maxSize.toString(),
    };
  }

  String toQueryParameter() {
    if (category != null) {
      String qp = category!.join(',');
      return qp;
    }
    return "";
  }
}

class ProductResponseModel {
  List<Product> productDtos;
  int nextIndex;
  int total;
  ProductResponseModel(
      {required this.productDtos,
      required this.nextIndex,
      required this.total});

  factory ProductResponseModel.fromJson(
      Map<String, dynamic> json, List<Product> products) {
    return ProductResponseModel(
      productDtos: products,
      nextIndex: json['nextIndex'].toInt(),
      total: json['total'],
    );
  }
}
