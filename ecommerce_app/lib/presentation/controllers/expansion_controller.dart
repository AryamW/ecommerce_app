import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpansionController extends GetxController{
  List<bool> isOpen = <bool>[false,true].obs;

  Rx<String?> minError = null.obs;
  Rx<String?> maxError = null.obs;
  TextEditingController minController = TextEditingController();
  TextEditingController maxController = TextEditingController();
  bool valid = false;

  final formKey = GlobalKey<FormState>().obs;
  void validateRange() {
    if (minController.text.isNotEmpty && !minController.text.isNumericOnly) {
      valid = false;
      minError= Rx("please only enter numbers greater than or equal to 0 (zero)");
    } else {
      minError = Rx(null);
      valid = true;
    }

    
    if (maxController.text.isNotEmpty && !maxController.text.isNumericOnly) {
      valid = false;
      maxError = Rx("please only enter numbers greater than 0 (zero)");
    } else if (minController.text.isNotEmpty && minController.text.isNumericOnly && maxController.text.isNotEmpty && maxController.text.isNumericOnly) {
        int min = int.tryParse(minController.text) ?? 0;
        int max = int.tryParse(maxController.text) ?? 0;
        if (min >= max) {
          maxError = Rx("maximum must be greater than minimum");
          valid = false;
        } else {
          maxError = Rx(null);
          valid = true;
        }
    } else {
      maxError = Rx(null);
      valid = true;
    }
  }

void clear(){
minController.clear();
maxController.clear();
}

  var pageSize = {"5"}.obs;
  void changeSize(Set<String> value){
    pageSize.clear();
    pageSize.add(value.single);
  }
}
