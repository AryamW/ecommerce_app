import 'package:ecommerce_app/core/utils/roles.dart';
import 'package:ecommerce_app/data/datasources/api_client.dart';
import 'package:ecommerce_app/presentation/pages/ErrorPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_app/presentation/widgets/route_guard.dart';

class AccessControlWidget extends StatefulWidget {
  final Widget child;
  final Roles allowedRole;
  final bool showError;

  const AccessControlWidget({
    super.key,
    required this.child,
    required this.allowedRole,
    this.showError = true,
  });

  @override
  State<AccessControlWidget> createState() => _AccessControlWidgetState();
}

class _AccessControlWidgetState extends State<AccessControlWidget> {
  late Core core;

  @override
  void initState() {
    // TODO: implement initState
    core = Core();
    super.initState();
  }

  bool get isAllowed => core.role == widget.allowedRole;

  @override
  Widget build(BuildContext context) {
    print(
        "${isAllowed}, ${widget.showError}, ${core.role}, ${widget.allowedRole}, ${widget.child}");
    if (isAllowed) {
      return widget.child;
    } else if (!isAllowed && !widget.showError) {
      // return Visibility(visible: widget.showError, child: widget.child);
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }

    return ErrorPage(
        message:
            "Access Denied! A ${core.role} does not have access to this ptoage.");
  }
}

class Core {
  static Roles? _role;

  Roles? get role => _role;

  Future<void> setUserData() async {
    // loads user data from shared preferences and sets it to
    var r = await DioClient().getRole();
    print("r: $r");
    if (r == "Admin") {
      _role = Roles.ADMIN;
    } else if (r == "Customer") {
      _role = Roles.CUSTOMER;
    } else {
      _role = null;
    }
    Get.find<RouteGuard>().toggleLoginStatus( r != null ) ;
    // [user]
  }
}
