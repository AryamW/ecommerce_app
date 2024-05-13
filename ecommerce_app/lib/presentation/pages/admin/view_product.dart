import 'package:ecommerce_app/core/utils/roles.dart';
import 'package:ecommerce_app/presentation/controllers/admin_table_controller.dart';
import 'package:ecommerce_app/presentation/widgets/roleBasedAccessControlWidget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/data_sources/search_product_data_source.dart';
import '../../../data/data_sources/search_products_data_source_impl.dart';
import '../../../data/repositories/search_product_repository_impl.dart';
import '../../../domain/repositories/search_product_repository.dart';
import '../../../domain/usecases/search_product_usecase.dart';
import '../../../domain/usecases/search_product_usecase_impl.dart';
import '../../widgets/button.dart';


import 'package:ecommerce_app/core/utils/category_enum.dart';
import 'package:ecommerce_app/presentation/controllers/expansion_controller.dart';

class MyProducts extends StatelessWidget {
  const MyProducts({super.key});

  @override
  Widget build(BuildContext context) {


final SearchProductsDataSource searchProductsDataSource = SearchProductsDataSourceImpl();
 final SearchProductsRepository searchProductsRepository = SearchProductsRepositoryImpl(searchRepo: searchProductsDataSource);
final SearchProductsUseCase searchProductsUseCase = SearchProductsUseCaseImpl(searchRepo: searchProductsRepository);
  final AdminTableController controller = Get.put(AdminTableController(searchProductsUseCase));

  final List<Widget> filter = [
      IconButton(
          onPressed: () {controller.searchWordController.clear();},
          icon:
              Icon(Icons.clear, color: Theme.of(context).colorScheme.onPrimary))
    ];
    return AccessControlWidget(
    allowedRole: Roles.ADMIN,
      child: Scaffold(
        floatingActionButton: IconButton(
          onPressed: () {
            Get.toNamed('/adminEditProducts', arguments: {'product': null});
          },
          icon: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.secondary)),
        ),
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
                        onPressed: () => {controller.searchWordController.clear(),Navigator.pop(context),},
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
                    // controller.validateSearchWord(),
                    // if(controller.valid){
                      controller.refresh()
                      // },
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
                  SortButton(),
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
            Expanded(child: Results())
          ],
        ),
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
                                 Get.find<AdminTableController>().currentChoice.value = values[index];
                                Get.find<AdminTableController>().setSortType(index);
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
              Obx(()=> Text(Get.find<AdminTableController>().currentChoice.value, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),)),
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


class categoryfilter extends StatelessWidget {
  const categoryfilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ExpansionController expController = Get.find<ExpansionController>();
    return Obx(
      () => SizedBox(
        height: 800,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Filters",
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Spacer(),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: () => Get.find<AdminTableController>().clear(),
                    child: Text("Clear")
                    ),
                    const SizedBox(width: 20,),
                  ContinueButton(onPress: (){
                      if (expController.formKey.value.currentState!.validate()) {
                         Get.find<AdminTableController>().refresh();
                      }
                  }, child: Text(
                            "Apply",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),padding: 10,)
                ],
              ),
            ),
            
                  Text(
                    "Items per page",
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  SegmentedButton(
                    segments: [
                      ButtonSegment(
                          value: "5",
                          // icon: Icon(Icons.timer_10),
                          label: Text(
                            "5",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )),
                      ButtonSegment(
                          value: "10",
                          // icon: Icon(Icons.timer_10),
                          label: Text(
                            "10",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )),
                      ButtonSegment(
                          value: "20",
                          // icon: Icon(Icons.timer_10),
                          label: Text(
                            "20",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )),
                      ButtonSegment(
                          value: "50",
                          // icon: Icon(Icons.timer_10),
                          label: Text(
                            "50",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )),
                    ],
                    selected: expController.pageSize,
                    onSelectionChanged: (p0) =>
                        Get.find<ExpansionController>().changeSize(p0),
                    style: ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.onPrimary),
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.onSecondary),
                        minimumSize: MaterialStatePropertyAll(Size(50, 50))),
                  ),
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) => expController
                  .isOpen[panelIndex] = !expController.isOpen[panelIndex],
              children: [
                ExpansionPanel(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  isExpanded: expController.isOpen[0],
                  headerBuilder: (context, bool isExpanded) => Text(
                    "Categories",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  body: SizedBox(
                    height: 200,
                    child: ListView.builder(
                        itemCount: Category.values.length,
                        itemBuilder: (_, index) {
                          return Obx(() => Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      Category.values[index].name,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Get.find<AdminTableController>()
                                                .selectedFilters
                                                .contains(
                                                    Category.values[index].name)
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                      onPressed: () {
                                        if (Get.find<AdminTableController>()
                                            .selectedFilters
                                            .contains(
                                                Category.values[index].name)) {
                                          Get.find<AdminTableController>()
                                              .removeFilter(
                                                  Category.values[index].name);
                                        } else {
                                          Get.find<AdminTableController>()
                                              .addFilter(
                                                  Category.values[index].name);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ));
                        }),
                  ),
                ),
                ExpansionPanel(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  isExpanded: expController.isOpen[1],
                  headerBuilder: (context, bool isExpanded) => Text(
                    "Price",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  body: Form(
                    key: expController.formKey(),
                    child: Column(
                            children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            constraints: BoxConstraints(maxWidth: 400),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary),
                              decoration: InputDecoration(
                                  hintText: "Min",
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                                  labelText: "Min",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  floatingLabelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  border: OutlineInputBorder(
                                      // borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  fillColor:
                                      Theme.of(context).colorScheme.secondary,
                                  filled: true),
                              controller: expController.minController,
                              validator: (value) {
                                expController.validateRange();
                                return expController.minError.value;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            constraints: BoxConstraints(maxWidth: 400),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary),
                              decoration: InputDecoration(
                                  hintText: "Max",
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary),
                                  labelText: "Max",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  floatingLabelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  border: OutlineInputBorder(
                                      // borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  fillColor:
                                      Theme.of(context).colorScheme.secondary,
                                  filled: true),
                              controller:  expController.maxController,
                              validator: (value) {
                                expController.validateRange();
                                return expController.maxError.value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class Results extends StatelessWidget {
  Results({super.key});
 final AdminTableController productController = Get.find<AdminTableController>();
 final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
            print(productController.results.length);
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      onRefresh: () => Future.sync(() => productController.refresh()),
      child: Obx(
        ()=> Stack(
              children: [SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Table(
                // border: TableBorder.all(color: Theme.of(context).colorScheme.onPrimary,borderRadius: BorderRadius.circular(8)),
                // border: TableBorder(horizontalInside: BorderSide(color: Theme.of(context).colorScheme.onPrimary,)),
                children: [
                  TableRow(children: [
                    Text("No.",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),textAlign: TextAlign.center,),
                    Text("name",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),textAlign: TextAlign.center,),
                    Text("id",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),textAlign: TextAlign.center,),
                    Text("price",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),textAlign: TextAlign.center,),
                    Text("image",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),textAlign: TextAlign.center,),
                    Text("",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),textAlign: TextAlign.center,),
                  ]),
                  ...productController.results.asMap().entries.map((e) {
                    return TableRow(
                      decoration: BoxDecoration(
                        color: e.key.isEven?
                        Theme.of(context).colorScheme.secondary
                        :Theme.of(context).colorScheme.primary
                        ,
                      ),
                      children: [
                      Text("${e.key+1}",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),textAlign: TextAlign.center,),
                      Text(e.value.name.toString(),style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),textAlign: TextAlign.center,),
                      Text(e.value.id.toString(),style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),textAlign: TextAlign.center,),
                      Text(e.value.price.toString(),style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),textAlign: TextAlign.center,),
                      e.value.imageUrl.isNotEmpty?Icon(Icons.check,color: Colors.green,):Icon(Icons.cancel_outlined,color: Colors.red,),
                      // Text(e.value.imageUrl.isNotEmpty.toString(),style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                      IconButton(
                        onPressed: () {
                        print("${e.key}");
                        Get.toNamed('/adminEditProducts', arguments: {'product':e.value});
                      },
                      icon: Icon(Icons.edit,color: Theme.of(context).colorScheme.onPrimary)),
                    ]);
                  }),
                  TableRow(
                    decoration: BoxDecoration(
                    color:Theme.of(context).colorScheme.primary,
                    ),
                    children: [
                    Text("",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                    Text("",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                    TextButton(
                      onPressed: () {  if(productController.offset.value!=-1){print(productController.results.length);
                                        productController.loadNextPage(); }
                                        },
                      child: Text("next",style: productController.offset.value!=-1? TextStyle(color: Theme.of(context).colorScheme.onPrimary): TextStyle(color: Theme.of(context).colorScheme.tertiary),),
                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary),
                      ),),
                    TextButton(
                      onPressed: () {  print(productController.results.length);
                                        productController.refresh(); 
                                        },
                      child: Text("refresh",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary),
                      ),),
                    Text("",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                    Text("",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                  ]),
                ],
              
              ),
          ),
        ),
               Positioned(
                left: 10,
                bottom: 0,
                child: IconButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondaryContainer)),
                onPressed: () {
                  _scrollController.animateTo(
                    0.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                },
                icon: Icon(Icons.keyboard_arrow_up),
                        ),
              ),
              ],
            ),
      ),
    );
  }
}