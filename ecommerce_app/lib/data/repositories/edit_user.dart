import 'package:ecommerce_app/data/datasources/edit_user.dart';
import 'package:ecommerce_app/domain/entities/edit_user.dart';
import 'package:ecommerce_app/domain/repositories/edit_user.dart';

class EditUserRepositoryImpl implements EditUserRepository{
  final EditUserDataSource editUserProvider;

  EditUserRepositoryImpl({required this.editUserProvider});
  
  @override
  Future<bool> editUser(EditUserModel user) async {
    try {
      return await editUserProvider.editUser(user);
    } catch (e) {
      rethrow;
    }
  }
}


 class GetUserRepositoryImpl extends GetUserRepository{
  final GetUserDataSource getUserProvider;

  GetUserRepositoryImpl({required this.getUserProvider});
  
  Future<GetUserModel> getUserDetails() async{
    try {
      return await getUserProvider.getUserDetails();
    } catch (e) {
      print("repo: $e");
      print("repo ${e.runtimeType}");
      rethrow;
    }
  }
}