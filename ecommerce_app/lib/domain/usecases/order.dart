import 'package:ecommerce_app/domain/entities/order.dart';
import 'package:ecommerce_app/domain/repositories/order.dart';

class OrderUseCase {
  final IOrderRepository repo;

  OrderUseCase({required this.repo});

  Future<List<Order>> fetchOrders() async {
    try {
      return await repo.fetchOrders();
    } catch (e) {
      rethrow;
    }
  }


 


}
