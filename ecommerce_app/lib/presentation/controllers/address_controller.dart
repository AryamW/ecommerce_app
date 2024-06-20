import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/data/datasources/address.dart';
import 'package:ecommerce_app/data/repositories/address.dart';
import 'package:ecommerce_app/domain/entities/address.dart';
import 'package:ecommerce_app/domain/usecases/address.dart';
import 'package:get/get.dart';

class AddressController extends GetxController{

//constructor on page load
AddressController(){
  loadAddress();
}
//  final cart = CartModel(success: false, message: "failed. not found", data: null).obs;
 var addressType = true.obs;

 void addressTypeChange(){
  addressType.value = !addressType.value;  
 }
  var useCase =
      AddressUseCase(repo: AddressRepositoryImpl(addressProvider:  AddressDataSource()));

  var shippingAddressList = [].obs;
  var billingAddressList = [].obs;

  void loadAddress() async{
    shippingAddressList.clear();
    billingAddressList.clear();
    try {
      var addressShippingList = await getShippingAddress();
      var addressBillingList = await getBillingAddress();
    if ( addressShippingList.isNotEmpty){
      shippingAddressList.addAll(addressShippingList);
      print(shippingAddressList[0]!.city);
    }
     if ( addressBillingList.isNotEmpty){
      billingAddressList.addAll(addressBillingList);
      print(billingAddressList[0]!.city);
    }
    } on BadResponseException catch (e) {
      rethrow;
    } on NetworkException catch (e) {
      rethrow;
    } on CustomeException catch (e) {
      rethrow;
    } catch (e) {
      throw Exception("Something went wrong. Try again later.");
    }
  }


  Future<List<AddressModel?>> getShippingAddress() async{
    try{
      var address = await useCase.getShippingAddress();
      return address;
    }catch(e){
    }
    return [];
  }

Future<bool> postShippingAddress(AddressModel newAddress) async{
    try{
      var address = await useCase.postShippingAddress(newAddress);
      return address;
    }catch(e){
      rethrow;
    }
  }

  Future<bool> putShippingAddress(AddressModel editedAddress) async{
    try{
      var address = await useCase.putShippingAddress(editedAddress);
      return address;
    }catch(e){
      rethrow;
    }
  }

  Future<bool> deleteShippingAddress(int addressId) async{
    try{
      var address = await useCase.deleteShippingAddress(addressId);
      return address;
    }catch(e){
      rethrow;
    }
  }


  Future<List<AddressModel?>> getBillingAddress() async{
    try{
      var address = await useCase.getBillingAddress();
      return address;
    }catch(e){
    }
    return [];
  }

Future<bool> postBillingAddress(AddressModel newAddress) async{
    try{
      var address = await useCase.postBillingAddress(newAddress);
      return address;
    }catch(e){
      rethrow;
    }
  }

  Future<bool> putBillingAddress(AddressModel editedAddress) async{
    try{
      var address = await useCase.putBillingAddress(editedAddress);
      return address;
    }catch(e){
      rethrow;
    }
  }

  Future<bool> deleteBillingAddress(int addressId) async{
    try{
      var address = await useCase.deleteBillingAddress(addressId);
      return address;
    }catch(e){
      rethrow;
    }
  }
}