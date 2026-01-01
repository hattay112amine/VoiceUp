import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voiceup/models/models.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  final RxBool _isEditing = false.obs;
  final RxBool _isLoading = false.obs;

  bool get isEditing => _isEditing.value;
  bool get isLoading => _isLoading.value;

  // CORRECTION ICI : J'ai ajouté le '?' après UserModel
  UserModel? get currentUser => authController.currentUser.value;

  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  GestureTapCallback? get deleteAccount => () {
    print("Delete account mock");
    Get.snackbar("Info", "Delete Account clicked (mock)");
  };

  GestureTapCallback? get signOut => () {
    authController.logout();
    Get.snackbar("Info", "Signed out (mock)");
  };

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    // Maintenant cette condition est valide car currentUser peut être null
    if (currentUser != null) {
      displayNameController.text = currentUser!.displayName;
      emailController.text = currentUser!.email;
    }
  }

  void toggleEditing() {
    _isEditing.value = !_isEditing.value;
    if (!_isEditing.value) {
      _loadUserData(); // Reset les champs si on annule
    }
  }

  void updateProfile() async {
    if (currentUser == null) return;

    _isLoading.value = true;

    // Simulation d'attente réseau
    await Future.delayed(const Duration(seconds: 1));

    // Mise à jour de l'utilisateur dans l'AuthController
    authController.currentUser.value = UserModel(
      id: currentUser!.id, // On garde l'ID existant
      displayName: displayNameController.text,
      email: emailController.text,
      photoURL: currentUser!.photoURL,
      isOnline: currentUser!.isOnline,
      lastSeen: currentUser!.lastSeen,
    );

    _isEditing.value = false;
    _isLoading.value = false;

    Get.snackbar("Success", "Profile updated");
  }

  @override
  void onClose() {
    displayNameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  String getJoinedData() {
    return "${currentUser?.displayName ?? ''} | ${currentUser?.email ?? ''}";
  }
}