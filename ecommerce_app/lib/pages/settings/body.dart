import 'package:flutter/material.dart';

import 'address_page.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 55),
          CircleAvatar(
            backgroundImage: AssetImage("lib/assets/images/Rectangle 9.png"),
            radius: 50,
          ),
          SizedBox(height: 35),
          CustomTextBtn(
            leading: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "username",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Text(
                  "email@gmail.com",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                Text(
                  "123-567-890",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
            trailing: Text(
                  "Edit",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
          ),
          SizedBox(height: 10),
          CustomTextBtn(
            title: "Address",
            trailing: ImageIcon(
                        color: Theme.of(context).colorScheme.onPrimary,
                        AssetImage(
                          "lib/assets/images/arrowright2.png",
                        ),
                      ),
            press: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddressPage())),),
          CustomTextBtn(
            title: "Payment",
            trailing: ImageIcon(
                        color: Theme.of(context).colorScheme.onPrimary,
                        AssetImage(
                          "lib/assets/images/arrowright2.png",
                        ),
                      ),
          ),
          CustomTextBtn(
            title: "Help",
            trailing: ImageIcon(
                        color: Theme.of(context).colorScheme.onPrimary,
                        AssetImage(
                          "lib/assets/images/arrowright2.png",
                        ),
                      ),
          ),
          CustomTextBtn(
            title: "Support",
            trailing: ImageIcon(
                        color: Theme.of(context).colorScheme.onPrimary,
                        AssetImage(
                          "lib/assets/images/arrowright2.png",
                        ),
                      ),
          ),
          SizedBox(
            height: 15,
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                "Sign Out",
                style: TextStyle(color: Color(0xFFFA3636)),
              ))
        ],
      ),
    );
  }
}

class CustomTextBtn extends StatelessWidget {
  CustomTextBtn({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.press
  });
  String? title;
  Widget? leading;
  Widget? trailing;
  VoidCallback? press;
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
