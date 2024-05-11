import 'package:ecommerce_app/presentation/controllers/admin_user.dart';
import 'package:ecommerce_app/presentation/pages/admin/dashboard.dart';
import 'package:ecommerce_app/presentation/pages/admin/view_users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class StoreBody extends StatelessWidget {
  StoreBody({super.key});
  var adminUserController = Get.put(AdminUsersController());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        alignment: WrapAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextBtn(
                  title: "View products",
                  trailing: ImageIcon(
                    color: Theme.of(context).colorScheme.onPrimary,
                    AssetImage(
                      "lib/assets/images/arrowright2.png",
                    ),
                  ),
                  press: () => Get.toNamed('/adminProducts'),
                ),
                CustomTextBtn(
                  title: "View Users",
                  trailing: ImageIcon(
                    color: Theme.of(context).colorScheme.onPrimary,
                    AssetImage(
                      "lib/assets/images/arrowright2.png",
                    ),
                  ),
                  press: () => Get.to(() => ViewUsers()),
                ),
              ],
            ),
          ),
          AdminDashBoard(),
        ],
      ),
    );
  }
}

class CustomTextBtn extends StatelessWidget {
  const CustomTextBtn(
      {super.key, this.title, this.leading, this.trailing, this.press});
  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? press;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextButton(
        style: ButtonStyle(
            padding: MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 10, vertical: 20)),
            backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.secondary),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)))),
        onPressed: press,
        child: Row(
          children: [
            if (leading != null) leading!,
            Text(
              title ?? "",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                // fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Spacer(),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
