import 'package:ecommerce_app/domain/entities/edit_user.dart';
import 'package:ecommerce_app/domain/entities/product.dart';

class Order {
  final GetUserModel? user;
  final String orderNumber;
  final int orderId;
  final int status;
  final Map<String, dynamic>? shippingAddress;
  final Map<String, dynamic>? billingAddress;
  final PaymentInfo paymentInfo;
  final DateTime? orderDate;
  final DateTime? updatedAt;
  final List<OrderItem> items;

  const Order({
    this.user,
    required this.orderNumber,
    required this.orderId,
    required this.status,
    this.shippingAddress = null,
    this.billingAddress = null,
    required this.paymentInfo,
    required this.orderDate,
    required this.updatedAt,
    required this.items,
  });

  set status(int st) => status = st;
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      user: json['user'] != null ? GetUserModel().fromJson(json["user"]) : json['user'],
        orderNumber: json["orderNumber"] ?? "N/A",
        orderId: json['orderId'] ?? "N/A",
        status: json['statusInt'] ?? 1,
        shippingAddress: json['shippingAddress'],
        
        paymentInfo: PaymentInfo.fromJson(json['paymentInfo']),
        orderDate: DateTime.parse(json["orderDate"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        items: json["items"]
            ?.map((elem) {
              return OrderItem.fromJson(elem);
            })
            .toList()
            .cast<OrderItem>());
  }

  Map<String, dynamic> toJson() {
    return {"status": status};
  }
}

class OrderItem {
  /*
  {
          "orderItemId": 1,
          "quantity": 2,
          "price": 21,
          "product": {
            "id": 11,
            "name": "Sample Product 11 for Automotive",
            "brand": "Seed",
            "count": 8,
            "details": "Seed product details for Automotive",
            "category": 0,
            "images": [],
            "price": 10.5,
            "ratings": []
          },
          "createdAt": "2024-04-24T17:14:14.001619",
          "updatedAt": "2024-04-24T17:14:14.001619"
        }
         */

  final int orderItemId;
  final int quantity;
  final num price;
  final Map<String, dynamic>? product;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderItem(
      {required this.orderItemId,
      required this.quantity,
      required this.price,
      this.product,
      required this.createdAt,
      required this.updatedAt});
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        product: json['product'],
        price: json["price"] ?? "N/A",
        quantity: json['quantity'] ?? "N/A",
        orderItemId: json['orderItemId'] ?? "N/A");
  }
}

class PaymentInfo {
  /*
  {
        "paymentInfoId": 1,
        "amount": 21,
        "currency": "ETB",
        "txRef": "tx638495756381887225",
        "createdAt": "2024-04-24T17:14:13.66922",
        "updatedAt": "2024-04-24T17:14:13.669252"
      },
   */

  final int paymentInfoId;
  final num amount;
  final String currency;
  final String txRef;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentInfo(
      {required this.paymentInfoId,
      required this.amount,
      required this.currency,
      required this.txRef,
       this.createdAt,
       this.updatedAt});

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    print("payment info json: $json");
    return PaymentInfo(
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        currency: json['currency'] ?? "N/A",
        txRef: json["txRef"] ?? "N/A",
        amount: json['amount'] ?? "N/A",
        paymentInfoId: json['paymentInfoId'] ?? "N/A");
  }
}

class RecentOrders {
  final List<Order> orders;
  final int count;

  RecentOrders({required this.orders, required this.count});
}
