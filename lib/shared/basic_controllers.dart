import 'package:get/get.dart';


class BasicController extends GetxController {
  //TODO: Implement BasicController
var tabIndex = 1;
  final count = 0.obs;

  @override
  void onInit() async{
    super.onInit();

     update();
  }


  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
