import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../data/service/network_caller.dart';
import '../data/utils/urls.dart';

class UpdateProfileController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  XFile? _pickedImage;

  Future<bool> updateProfile(String email, String password, String firstName,
      String lastName, String mobile) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "email": email.trim(),
      "firstName": firstName.trim(),
      "lastName": lastName.trim(),
      "mobile": mobile.trim(),
    };

    if (_pickedImage != null) {
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      requestBody['photo'] = base64Encode(imageBytes);
    }

    if (password.isNotEmpty) {
      requestBody['password'] = password;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.updateProfileUrl, body: requestBody);

    if (response.isSuccess) {
      _errorMessage = 'Profile updated successfully!';
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}