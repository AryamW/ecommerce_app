import 'package:ecommerce_app/presentation/pages/home/components/categories_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/utils/category_enum.dart';
import 'selected_category_page.dart';

class Categories extends StatelessWidget {
  Categories({super.key});
    final List categoryIcons=[Icon(Icons.car_rental_outlined),
  
  Icon(Icons.face_unlock_outlined),
  Icon(Icons.cookie_sharp),
  Icon(Icons.soap_outlined),
  Icon(Icons.book),
  Icon(Icons.theater_comedy_outlined),
  Icon(Icons.bookmark_add_outlined),
  Icon(Icons.electric_bolt),
  Icon(Icons.phone_android),
  Icon(Icons.computer),
  ];

  @override
  Widget build(BuildContext context) {

  CategoryToList categoriesList = CategoryToList();
  var categories = [];
  categories =  categoriesList.toCategoryList();
  
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Categories",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary,fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                  onTap: () => Get.toNamed("/category"),
                  child: Text(
                    "See All",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w500),
                  )),
            ],
          ),
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 110,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemExtent: 100,
                padding: EdgeInsets.symmetric(horizontal: 5),
                itemBuilder: (_, index) {
                  return Column(
                    children: [
                      IconButton(
                        onPressed: () => Get.toNamed("/selectedCategory",arguments: {"category": Category.values[index].name}),
                        icon: categoryIcons[index],
                      ),
                      GestureDetector(
                          onTap: () => Get.toNamed("/selectedCategory",arguments: {"category": Category.values[index].name}),
                          child: Container(
                            height: 60,
                            child: Text(
                              // softWrap: true,
                              overflow: TextOverflow.clip,
                              "${categories[index]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary),
                            ),
                          ))
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }
}
