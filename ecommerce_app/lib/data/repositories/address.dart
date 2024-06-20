import 'package:ecommerce_app/data/datasources/address.dart';
import 'package:ecommerce_app/domain/entities/address.dart';
import 'package:ecommerce_app/domain/repositories/address.dart';

class AddressRepositoryImpl extends AddressRepository{
  final AddressDataSource addressProvider;

  AddressRepositoryImpl({required this.addressProvider});
  @override
  Future<List<AddressModel?>> getShippingAddress() async{
    try {
      return await addressProvider.getShippingAddress();
    } catch (e) {
      print("getShipping repo: $e");
      print("repo ${e.runtimeType}");
      rethrow;
    }
  }
  
  @override
  Future<bool> postShippingAddress(AddressModel address) async {
    try {
      return await addressProvider.postShippingAddress(address:  address);
    } catch (e) {
      print("getShipping repo: $e");
      print("repo ${e.runtimeType}");
      rethrow;
    }
  }
  
  @override
  Future<bool> putShippingAddress(AddressModel address) async{
    try {
      return await addressProvider.putShippingAddress(address:  address);
    } catch (e) {
      print("getShipping repo: $e");
      print("repo ${e.runtimeType}");
      rethrow;
    }
  }
   @override
     Future<bool> deleteShippingAddress(int addressId) async{
    try {
      return await addressProvider.deleteShippingAddress(addressId: addressId);
    } catch (e) {
      print("getShipping repo: $e");
      print("repo ${e.runtimeType}");
      rethrow;
    }
  }
  
  @override
  Future<List<AddressModel?>> getBillingAddress() async{
    try {
      return await addressProvider.getBillingAddress();
    } catch (e) {
      print(" getBilling repo: $e");
      print("repo ${e.runtimeType}");
      rethrow;
    }
  }

   @override
  Future<bool> postBillingAddress(AddressModel address) async {
    try {
      return await addressProvider.postBillingAddress(address:  address);
    } catch (e) {
      print("getShipping repo: $e");
      print("repo ${e.runtimeType}");
      rethrow;
    }
  }
  
  @override
  Future<bool> putBillingAddress(AddressModel address) async{
    try {
      return await addressProvider.putBillingAddress(address:  address);
    } catch (e) {
      print("getShipping repo: $e");
      print("repo ${e.runtimeType}");
      rethrow;
    }
  }
   @override
   Future<bool> deleteBillingAddress(int addressId) async{
    try {
      return await addressProvider.deleteBillingAddress(addressId: addressId);
    } catch (e) {
      print("getShipping repo: $e");
      print("repo ${e.runtimeType}");
      rethrow;
    }
  }
  
  
  
}