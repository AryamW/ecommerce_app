import 'package:ecommerce_app/domain/entities/auth.dart';
import 'package:ecommerce_app/domain/entities/edit_user.dart';
import 'package:ecommerce_app/domain/entities/order.dart';
import 'package:ecommerce_app/domain/entities/product.dart';

abstract class IAdminUsers {
  Future<List<GetUserModel>> fetchUsers();
  Future<bool> deleteUser(String id, String email);
  Future<bool> register(RegisterModel user);
  Future<List<ReviewModel>> fetchRecentReviews();
  Future<RecentOrders?> fetchRecentOrders();
  Future<bool> delivered(int id, int status);



}
