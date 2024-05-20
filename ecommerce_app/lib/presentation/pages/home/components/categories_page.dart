import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/utils/category_enum.dart';
import 'selected_category_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(
               padding: EdgeInsets.only(left: 20,top: 25),
               child: Ink(
                decoration: ShapeDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: CircleBorder()),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: ImageIcon(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    AssetImage(
                                      "lib/assets/images/arrowleft2.png",
                                    ),
                                    //size: 40, // Adjust the size as needed
                                  ),
                )),
             ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 5),
              child: Text(
                "Shop by Categories",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 15,),
            // CategoryBtn(),
            // CategoryBtn(),
            // CategoryBtn(),
            // CategoryBtn(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Category.values.length,
                itemBuilder: (_,index){
                  return CategoryBtn(index: index,);
              }),
            )
          ],
        ));
  }
}

class CategoryBtn extends StatelessWidget {
 const CategoryBtn({
    super.key, required this.index,
  });
  final int index;

  @override
  Widget build(BuildContext context) {
    double size = 40;
    Color color =Theme.of(context).colorScheme.onPrimary;
    final List categoryIcons=[
      Icon(Icons.car_rental_outlined,size: size,color: color,),
      Icon(Icons.face_unlock_outlined,size: size,color: color,),
      Icon(Icons.cookie_sharp,size: size,color: color,),
      Icon(Icons.soap_outlined,size: size,color: color,),
      Icon(Icons.book,size: size,color: color,),
      Icon(Icons.theater_comedy_outlined,size: size,color: color,),
      Icon(Icons.bookmark_add_outlined,size: size,color: color,),
      Icon(Icons.electric_bolt,size: size,color: color,),
      Icon(Icons.phone_android,size: size,color: color,),
      Icon(Icons.computer,size: size,color: color,),
      Icon(Icons.man,size: size,color: color,),
      Icon(Icons.woman,size: size,color: color,),
      Icon(Icons.man_4,size: size,color: color,),
      Icon(Icons.woman_2_rounded,size: size,color: color,),
      Icon(Icons.airline_seat_legroom_reduced_outlined,size: size,color: color,),
      Icon(Icons.snowshoeing_sharp,size: size,color: color,),
      Icon(Icons.snowshoeing_sharp,size: size,color: color,),
      Icon(Icons.home,size: size,color: color,),
      Icon(Icons.soup_kitchen_outlined,size: size,color: color,),
      Icon(Icons.bathtub_outlined,size: size,color: color,),
      Icon(Icons.movie_creation_outlined,size: size,color: color,),
      Icon(Icons.question_mark,size: size,color: color,),
      Icon(Icons.view_compact_alt_outlined,size: size,color: color,),
      Icon(Icons.games_outlined,size: size,color: color,),
      Icon(Icons.toys_outlined,size: size,color: color,),
    ];
    return 
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: 
      TextButton(
        style: ButtonStyle(
            padding: MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 10, vertical: 20)),
            backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.secondary),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)))),
        onPressed: () => 
        // Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => SelectedCategoryPage()))
                          Get.toNamed("/selectedCategory",parameters: {"category": Category.values[index].name}),
        child: Row(
          children: [
           categoryIcons[index],
            SizedBox(
              width: 10,
            ),
            Text(
              Category.values[index].name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          ],
        ),
      )
    )
    ;
  }
}
