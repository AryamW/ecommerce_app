import 'package:ecommerce_app/core/utils/exceptions.dart';
import 'package:ecommerce_app/data/datasources/order.dart';
import 'package:ecommerce_app/data/repositories/order.dart';
import 'package:ecommerce_app/domain/entities/order.dart';
import 'package:ecommerce_app/domain/usecases/order.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    fetchOrders();
    super.onInit();
  }

  final orders = RxList<Order>([]);
  var useCase =
      OrderUseCase(repo: OrderRepositoryImp(dataSource: OrderDataSource()));
  void fetchOrders() async {
    try {
      var res = await useCase.fetchOrders();
      orders(res);
      orders.refresh();
    } on BadResponseException catch (e) {
      if (e.statusCode == 404) {
        Get.toNamed("/emptyCart");
      } else if (e.statusCode == 400) {
        Get.snackbar("Invalid", "invalid request.");
      } else if (e.statusCode == 500) {
        Get.toNamed("/error", arguments: {
          "message": "A Server Error has occured. try again later."
        });
      }
    } on NetworkException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } on CustomeException catch (e) {
      Get.toNamed("/error", arguments: {"message": e.toString()});
    } catch (e) {
      Get.toNamed("/error",
          arguments: {"message": "something went wrong. try again later"});
    }
  }

  Order fetchOrder(int id) {
    return orders.firstWhere((element) => element.orderId == id);
  }
}
