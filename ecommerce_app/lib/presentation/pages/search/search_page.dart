import 'package:ecommerce_app/presentation/pages/search/categoryfilter.dart';
import 'package:ecommerce_app/presentation/pages/search/search_results.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/datasources/search_product_data_source.dart';
import '../../../data/datasources/search_products_data_source_impl.dart';
import '../../../data/repositories/search_product_repository_impl.dart';
import '../../../domain/repositories/search_product_repository.dart';
import '../../../domain/usecases/search_product_usecase.dart';
import '../../../domain/usecases/search_product_usecase_impl.dart';
import '../../controllers/search_page_controller.dart';
import '../../controllers/search_text_controller.dart';



class SearchPage extends StatelessWidget {
  final String? keyWord = Get.arguments?['keyword'];
  SearchPage({super.key});
   
 @override
 Widget build(BuildContext context) {


final SearchProductsDataSource searchProductsDataSource = SearchProductsDataSourceImpl();
 final SearchProductsRepository searchProductsRepository = SearchProductsRepositoryImpl(searchRepo: searchProductsDataSource);
final SearchProductsUseCase searchProductsUseCase = SearchProductsUseCaseImpl(searchRepo: searchProductsRepository);
  final SearchPageController controller = Get.put(SearchPageController(searchProductsUseCase,keyword: keyWord));

  final List<Widget> filter = [
      IconButton(
          onPressed: () {controller.searchWordController.clear();},
          icon:
              Icon(Icons.clear, color: Theme.of(context).colorScheme.onPrimary))
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Ink(
                    decoration: ShapeDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: CircleBorder()),
                    child: IconButton(
                      onPressed: () {
                        try {
                          Get.find<SearchTextController>()
                              .searchController
                              .clear();
                        } catch (e) {}
                        controller.searchWordController.clear();
                        Navigator.pop(context);
                      },
                      icon: ImageIcon(
                        color: Theme.of(context).colorScheme.onSecondary,
                        AssetImage("lib/assets/images/arrowleft2.png"),
                      ),
                    )),
              ),
              SearchBar(
                controller: controller.searchWordController,
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                constraints: BoxConstraints(maxHeight: 40,maxWidth: MediaQuery.of(context).size.width*0.7),
                textStyle: MaterialStatePropertyAll(
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Theme.of(context).colorScheme.secondary),
                onSubmitted: (value) => ({
                  // controller.searchWord.value =value,
                  controller.validateSearchWord(),
                  if(controller.valid){controller.refresh()},
                  }),
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.only(left: 30, right: 10),
                ),
                leading: Icon(
                  Icons.search_outlined,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                // hintText: "$keyWord",
                elevation: const MaterialStatePropertyAll(2),
                trailing: filter,
              ),
            ],
          ),
          SizedBox(height: 20,),
          SizedBox(
            height: 40,
            child: ListView(
              padding:  EdgeInsets.only(left: 20),
              scrollDirection: Axis.horizontal,
              children: [
                Obx(() => FilterChip(
                    label: Row( mainAxisSize: MainAxisSize.min,
                      children: [Text("${controller.selectedFilters.length}"),
                        Icon(Icons.filter_alt),
                      ],
                    ),
                    onSelected: (value) { _showFilterBottomSheet(context);},
                    selected: controller.selectedFilters.length>0,
                    // selectedColor:  Theme.of(context).colorScheme.tertiary ,
                    color: MaterialStatePropertyAll(Theme.of(context).colorScheme.tertiary),
                  ),
                ),
                SizedBox(width: 20,),
                SortButton()
              ],
            ),
          ),
          Obx(
            () => Padding(
              padding: EdgeInsets.only(left: 20, bottom: 5, top: 10),
              child: Text(
                "${controller.total.value} ${controller.total.value==1?'result':'results'} found",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
          Expanded(child: SearchResult())
        ],
      ),
    );
 }

 void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor:Theme.of(context).colorScheme.primary,
      context: context,
      builder: (context) {
        return Container(
          color: Theme.of(context).colorScheme.primary,
          child: SingleChildScrollView(
            child: categoryfilter(),
        ));
      },
    );
 }
}


class SortButton extends StatelessWidget {
  final title = "Sort by";
  final values = ["None","Low-Hi", "Hi-Low",];
  final choices = [
    "None",
    "Price: Lowest - Highest",
    "Price: Highest - Lowest",
  ];

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        // padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(20)),
        backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).colorScheme.secondary),
      ),
      onPressed: () {
        showModalBottomSheet(
          backgroundColor: Theme.of(context).colorScheme.primary,
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Use min to make the bottom sheet only as tall as its content
                children: <Widget>[
                  // Add a title at the top of the bottom sheet
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  // Add a divider for better visual separation
                  Divider(color: Theme.of(context).colorScheme.onSecondary),
                  // Your existing ListView.builder
                  Expanded(
                    child: ListView.builder(
                      itemCount: choices.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            textColor: Theme.of(context).colorScheme.onPrimary,
                            tileColor: Theme.of(context).colorScheme.secondary,
                            hoverColor: Theme.of(context).colorScheme.tertiary,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: BorderSide.none),
                            title:Text(choices[index]),
                            onTap: () {
                                 Get.find<SearchPageController>().currentChoice.value = values[index];
                                Get.find<SearchPageController>().setSortType(index);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold),
          ),
                SizedBox(width: 20,),
          Row(
            children: [
              Obx(()=> Text(Get.find<SearchPageController>().currentChoice.value, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),)),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                "lib/assets/images/arrow_down.png",
                color: Theme.of(context).colorScheme.onSecondary,
              )
            ],
          )
        ],
      ),
    );
  }
}
