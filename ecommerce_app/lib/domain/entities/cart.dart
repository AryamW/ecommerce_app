import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/domain/entities/product.dart';

class CartItem {
  final int cartItemId;
  final num price;
  final int quantity;
  final PDetailModel product;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CartItem(
      {required this.cartItemId,
      required this.price,
      required this.quantity,
      required this.product,
      this.createdAt,
      this.updatedAt});

  Map<String, int>? createToJson() {
    return {"productId": product.id, "quantity": 1};
  }

  Map<String, int>? updateToJson(int newQuantity) {
    return {"cartItemId": cartItemId, "newQuantity": newQuantity};
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    // print(json);
    return CartItem(
      cartItemId: json["cartItemId"],
      price: json["price"],
      quantity: json["quantity"],
      product: PDetailModel.fromJson(json["product"]),
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  set quantity(value) => quantity = quantity;
  /*
  {
        "cartItemId": 2,
        "price": 63,
        "quantity": 6,
        "product": {
          "id": 3,
          "name": "Sample Product 3 for Automotive",
          "brand": "Seed",
          "count": 10,
          "details": "Seed product details for Automotive",
          "category": 0,
          "images": [],
          "price": 10.5,
          "ratings": []
        },
        "createdAt": "2024-04-15T12:03:52.402194",
        "updatedAt": "2024-04-15T13:11:34.308049"
      }
       */
}

class dataModel {
  final int cartId;
  final num totalPrice;
  final List<CartItem> items;

  dataModel(
      {required this.cartId, required this.totalPrice, required this.items});
  factory dataModel.fromJson(Map<String, dynamic> json) {
    // var items = json["items"].map((e) => CartItem.fromJson(e)).toList(CartItem);
    var items = json["items"]
        .map((e) => CartItem.fromJson(e))
        .toList()
        .cast<CartItem>();

    // items = items as List<CartItem>;

    return dataModel(
        cartId: json["cartId"], totalPrice: json["totalPrice"], items: items);
  }
  set items(value) => items = items;
}

class CartModel {
  final bool success;
  final String message;
  final dataModel? data;

  CartModel({required this.success, required this.message, required this.data});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        success: json["success"],
        message: json["message"],
        data: dataModel.fromJson(json["data"]));
  }
  /*
  {
  "success": true,
  "message": "Cart items fetched successfully.",
  "data": {
    "cartId": 2,
    "totalPrice": 63,
    "items": [
      {
        "cartItemId": 2,
        "price": 63,
        "quantity": 6,
        "product": {
          "id": 3,
          "name": "Sample Product 3 for Automotive",
          "brand": "Seed",
          "count": 10,
          "details": "Seed product details for Automotive",
          "category": 0,
          "images": [],
          "price": 10.5,
          "ratings": []
        },
        "createdAt": "2024-04-15T12:03:52.402194",
        "updatedAt": "2024-04-15T13:11:34.308049"
      }
    ]
  }
}
   */
}


/*
  final int cartItemId;
  int quantity;
  final double price;
  final PDetailModel product;

  CartItem(
      {required this.cartItemId,
      required this.price,
      required this.product,
      required this.quantity});
  void set addQuantity(int quantity) {
    this.quantity = quantity;
  }

  static CartItem fromJson(Map<String, dynamic> json) {
    if (json["cartItemId"] == null) {
      throw CustomeException(message: "cartItemId must not be null.");
    }
    if (json["quantity"] == null || json["quantity"]! < 1) {
      throw CustomeException(
          message:
              "quantity must not be null and must be between greater than 1.");
    }
    print("e: E: ${PDetailModel.fromJson(json["product"]).runtimeType}");
    var e = CartItem(
        cartItemId: json["cartItemId"]!,
        quantity: json["quantity"]!,
        price: json["price"]!.toDouble(),
        // product: PDetailModel.fromJson(json["product"]),
        product: PDetailModel.fromJson(json["product"]));
    print("e: E: $e");
    return e;
  }

  Map<String, dynamic> toJson() {
    return {
      "cartItemId": cartItemId,
      "productId": product.id,
      "quantity": quantity,
      "newQuantity": quantity,
    };
  }
 */