import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PDetailModel {
  final String name;
  final double price;
  final String? details;
  Map<String, dynamic>? reviews;
  final List<dynamic>? images;
  final int id;
  final int count;

  PDetailModel({
    required this.name,
    required this.price,
    this.details,
    this.reviews,
    this.images,
    required this.id,
    required this.count,
  });

  static PDetailModel fromJson(Map<String, dynamic> json) {
    try {
      List images = json['images'];
      var imageList = [];
      images.forEach(
        (element) => imageList.add("${dotenv.env["BASE_URL"]}/Images/$element"),
      );
      var b = PDetailModel(
        id: json["id"],
        name: json["name"],
        details: json["details"],
        count: json["count"],
        images: imageList,
        price: json["price"].toDouble(),
      );
      return b;
    } catch (e) {
      throw Exception("jdfakljf ${e.runtimeType}");
    }
  }
}

class ReviewModel {
  final String review;
  final int rating;
  final String? name;
  final bool isMine;

  ReviewModel({
    required this.isMine,
    required this.review,
    required this.rating,
    this.name,
  });
  Map<String, dynamic> toJson() {
    return {"Review": review, "Rating": rating, "name": name, "isMine": isMine};
  }

  static ReviewModel fromJson(Map<String, dynamic> json) {
    return ReviewModel(
        review: json["review"],
        rating: json['rating'],
        name: json["name"],
        isMine: json["isMine"]);
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final List<dynamic> imageUrl;
  final String brand;
  final String details;
  final String category;
  final int count;
  factory Product.fromJson(Map<String, dynamic> json) {
    List images = json['images'];
    var imageList = [];
    images.forEach(
      (element) => imageList.add("${dotenv.env["BASE_URL"]}/Images/$element"),
    );
    return Product(
        id: json['id'].toInt(),
        name: json['name'],
        price: json['price'].toDouble(),
        imageUrl: imageList,
        brand: json["brand"],
        details: json["details"],
        count: json["count"].toInt(),
        category: json["category"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "imageUrl": imageUrl,
      "brand": brand,
      "details": details,
      "count": count,
      "category": category,
    };
  }

  Map<String, dynamic> toAdminJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "brand": brand,
      "details": details,
      "count": count,
      "category": category,
    };
  }

  Product(
      {required this.name,
      required this.price,
      required this.imageUrl,
      required this.id,
      required this.brand,
      required this.details,
      required this.count,
      required this.category});
}

class SearchModel {
  final String? searchWord;
  List<String>? filters;
  int? low;
  int? high;
  List<String?>? category;
  int? start;
  int? maxSize;
  String? sortType;

  SearchModel({
    this.high,
    this.category,
    this.searchWord,
    this.filters,
    this.low,
    this.start,
    this.maxSize,
    this.sortType,
  });

  Map<String, dynamic> toJson() {
    return {
      if (searchWord != null) "name": searchWord!,
      if (category != null) "categories": category,
      if (low != null) "low": low.toString(),
      if (high != null) "high": high.toString(),
      "sortType": sortType.toString(),
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

class AdminProduct {
  int? id;
  String? name;
  double? price;
  List<dynamic>? imageUrl;
  String? brand;
  String? details;
  String? category;
  int? count;
  File? imgFiles;
  factory AdminProduct.fromJson(Map<String, dynamic> json) {
    List images = json['images'];
    var imageList = [];
    images.forEach(
      (element) => imageList.add("${dotenv.env["BASE_URL"]}/Images/$element"),
    );
    return AdminProduct(
        id: json['id'].toInt(),
        name: json['name'],
        price: json['price'].toDouble(),
        imageUrl: imageList,
        brand: json["brand"],
        details: json["details"],
        count: json["count"].toInt(),
        category: json["category"]);
  }

  AdminProduct(
      {this.name,
      this.price,
      this.imageUrl,
      this.id,
      this.brand,
      this.details,
      this.count,
      this.category});

  Map<String, dynamic> toAdminJson() {
    return {
      if (id != null) "id": id!,
      if (name != null && name != "") "name": name!,
      if (price != null) "price": price!,
      if (brand != null && brand != "") "brand": brand!,
      if (details != null && details != "") "details": details!,
      if (count != null) "count": count!,
      if (category != null && category != "") "category": category!,
      if (imageUrl != null && imageUrl!.isNotEmpty) "imageUrl": imageUrl!,
    };
  }

  toForm() async {
    return FormData.fromMap({
      if (id != null) "id": id!,
      if (name != null && name != "") "name": name!,
      if (price != null) "price": price!,
      if (imageUrl != null && imageUrl!.isNotEmpty) "imageUrl": imageUrl!,
      if (brand != null && brand != "") "brand": brand!,
      if (details != null && details != "") "details": details!,
      if (count != null) "count": count!,
      if (category != null && category != "") "category": category!,
      if (imgFiles != null)
        "imgFiles": await MultipartFile.fromFile(imgFiles!.path),
    });
  }
}
