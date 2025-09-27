import 'package:get/get.dart';
import 'package:pms_module/ui/controller/auth_controller.dart';
import 'package:pms_module/ui/controller/sign_in_controller.dart';
import 'package:pms_module/ui/controller/sign_up_controller.dart';
import 'package:pms_module/ui/controller/update_profile_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => SignUpController());
  /* Get.put(VerifyEmailController());
    Get.lazyPut(() => VerifyOTPController());
    Get.lazyPut(() => ResetPasswordController());*/
    Get.put(UpdateProfileController());
  }
}