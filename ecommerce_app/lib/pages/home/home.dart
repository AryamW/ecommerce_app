import 'package:flutter/material.dart';

import 'components/body.dart';

import '../../widgets/navbar.dart';
import 'components/searching_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.person,
              color: Theme.of(context).primaryColorDark,
            )),
            title: SearchingBar(),
            titleSpacing: 0,
            // leadingWidth: 40,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.dark_mode_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.shopping_bag_outlined)),
        ],
      ),
      body: Body(),
      bottomNavigationBar: NavBar(),
    );
  }
}
