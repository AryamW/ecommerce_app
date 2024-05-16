import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/data/data_sources/edit_user.dart';
import 'package:ecommerce_app/data/repositories/edit_user.dart';
import 'package:ecommerce_app/domain/entities/edit_user.dart';
import 'package:ecommerce_app/domain/repositories/edit_user.dart';
import 'package:ecommerce_app/domain/usecases/edit_user.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController{
  late Rx<GetUserModel?> userData =GetUserModel().obs;
  SettingsController(){
    loadUser();
  }

  Future<void> loadUser()async{
    userData.value = await getUserDetails();
  }
GetUserCase useCase = GetUserCase(repo: GetUserRepositoryImpl(getUserProvider: GetUserDataSource()));
Future<GetUserModel?> getUserDetails() async {
   
    try { var result = await useCase.getUserDetails();
    // print("object");
    return result;
    } catch (e) {
      return GetUserModel();
    }
  }
}