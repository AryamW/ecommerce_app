import 'package:ecommerce_app/domain/entities/order.dart';
import 'package:ecommerce_app/presentation/controllers/admin_user.dart';
import 'package:ecommerce_app/presentation/controllers/order.dart';
import 'package:ecommerce_app/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AdminOrders extends StatelessWidget {
  var controller = Get.find<AdminUsersController>();

  AdminOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: backButton(),
        title: Text(
          "Orders",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Obx(() {
       
          return   Column(
            children: [
           if ( controller.isLoading.value)  CustomLoadingWidget(),
              Expanded(child: AllOrders(orders: controller.recentOrders.value))
              // Text("kjfajf"),
            ],
          );
      
      }),
    );
  }
}

class AllOrders extends StatelessWidget {
  final List<Order> orders;

  AllOrders({super.key, required this.orders});
  var controller = Get.find<AdminUsersController>();
  @override
  Widget build(BuildContext context) {
    if (orders.length == 0) {
      if (controller.recentOrdersError.isNotEmpty) {
        return Text(
          "${controller.recentOrdersError['status']}: ${controller.recentOrdersError['message']}",
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        );
      } else {
        return Text("No Order to show.",
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary));
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: ListView.builder(
          itemBuilder: (context, index) {
            Order order = orders[index];
            return GestureDetector(
                onTap: () {
                  // go to a screen that shows all of the details of that order
                  Get.toNamed("/order-detail", arguments: {"order": order});
                },
                child: SingleOrderItem(order: order));
          },
          itemCount: orders.length),
    );
  }
}

class SingleOrderItem extends StatelessWidget {
  final Order order;

  const SingleOrderItem({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size.width;

    var width;
    var maxwidth = 600.01;
    if (screen > maxwidth) {
      width = maxwidth;
    } else {
      width = screen;
    }
    var statuses = [null, "Pending", "Shipped", "Delivered"];
    // print("screen: $screen, maxw: $maxwidth, width: $width");
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(),
      width: width,
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'User: ${order.user?.email ?? "AnonymousUser."}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              SizedBox(height: 8),
              Text(
                'Order Number: ${order.orderNumber}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              SizedBox(height: 8),
              Wrap(
                children: [
                  Text(
                    'Status: ${statuses[order.status]}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  if (order.status != 3)
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.amber.shade500),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              title: Text(
                                'Confirm Action',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              content: Text(
                                'Are you sure you want to mark this order as ${statuses[order.status + 1]}?\n This is an irreversible action.',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      Get.find<AdminUsersController>()
                                          .changeIsLoading(true);
                                      Get.find<AdminUsersController>()
                                          .delivered(
                                              order.orderId, order.status + 1)
                                          .then((value) {
                                        Get.find<AdminUsersController>()
                                            .changeIsLoading(false);
                                      }); // Proceed with the function
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    )),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "${statuses[order.status + 1]}",
                        style: TextStyle(color: Colors.black87),
                      ),
                    )
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Order Date: ${order.orderDate ?? "N/A"}',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
              SizedBox(height: 8),
              Text(
                'Total Items: ${order.items.length}',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
              SizedBox(height: 8),
              Text(
                'Total Amount: ${order.paymentInfo.amount} ${order.paymentInfo.currency}',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





class CustomLoadingWidget extends StatefulWidget {
  @override
  _CustomLoadingWidgetState createState() => _CustomLoadingWidgetState();
}

class _CustomLoadingWidgetState extends State<CustomLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  @override
void initState() {
  super.initState();
  _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

  _controller.forward();
}

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          height: 4.0, // Height of the line
          width: _animation.value * 200, // Width of the line based on animation value
          decoration: BoxDecoration(
            color: Colors.blue, // Color of the line
            borderRadius: BorderRadius.circular(2.0), // Optional: to make the line rounded
          ),
        );
      },
    );
  }
}