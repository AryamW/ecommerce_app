import 'package:ecommerce_app/data/datasources/edit_product.dart';
import 'package:ecommerce_app/data/datasources/edit_user.dart';
import 'package:ecommerce_app/domain/entities/edit_user.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/domain/repositories/edit_product.dart';
import 'package:ecommerce_app/domain/repositories/edit_user.dart';

class EditProductRepositoryImpl implements EditProductRepository{
  final EditProductDataSource editProductProvider;

  EditProductRepositoryImpl({required this.editProductProvider});
  
  @override
  Future<bool> editProduct(AdminProduct product) async {
    try {
      return await editProductProvider.editProduct(product);
    } catch (e) {
      print("repo: $e");
      print("repo ${e.runtimeType}");
      rethrow;
    }
  }
  @override
  Future<AdminProduct?> addProduct(AdminProduct product) async {
    try {
      return await editProductProvider.addProduct(product);
    } catch (e) {
      print("repo: $e");
      print("repo ${e.runtimeType}");
      rethrow;
    }
  }
  
  @override
  Future<bool> deleteProduct(int id) async {
    try {
      return await editProductProvider.deleteProduct(id);
    } catch (e) {
      print("repo: $e");
      print("repo ${e.runtimeType}");
      rethrow;
    }
  }

  @override
  Future<bool> deleteImage(int id, List imageList) async {
    try {
      return await editProductProvider.deleteImage(id, imageList);
    } catch (e) {
      print("repo: $e");
      print("repo ${e.runtimeType}");
      rethrow;
    }
  }

  @override
  Future<AdminProduct?> getProduct(int id) async {
    try {
      return await editProductProvider.getProduct(id,);
    } catch (e) {
      print("repo: $e");
      print("repo ${e.runtimeType}");
      rethrow;
    }
  }
}