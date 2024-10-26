import 'package:get/get.dart';

class TabbarNavigationController extends GetxController {
  var tab = "Storage".obs;
  changeTab(String givenTab) {
    tab.value = givenTab;
  }
}
