import 'package:ecommerce_app/core/utils/category_enum.dart';
import 'package:ecommerce_app/presentation/controllers/expansion_controller.dart';
import 'package:ecommerce_app/presentation/controllers/search_page_controller.dart';
import 'package:ecommerce_app/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                    onPressed: () => Get.find<SearchPageController>().clear(),
                    child: Text("Clear")
                    ),
                    const SizedBox(width: 20,),
                  ContinueButton(onPress: (){
                    if (expController.formKey.value.currentState!.validate()) {
                         Get.find<SearchPageController>().refresh();
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
                                        Get.find<SearchPageController>()
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
                                        if (Get.find<SearchPageController>()
                                            .selectedFilters
                                            .contains(
                                                Category.values[index].name)) {
                                          Get.find<SearchPageController>()
                                              .removeFilter(
                                                  Category.values[index].name);
                                        } else {
                                          Get.find<SearchPageController>()
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
