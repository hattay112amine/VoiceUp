import 'package:get/get.dart';

// Mock AuthController
class AuthController extends GetxController {
  // true si l'utilisateur est déjà connecté, false sinon
  bool isAuthenticated = false;

  // valeur mock réactive pour le loading
  RxBool isLoading = false.obs;

  // Tu peux ajouter d'autres mocks si nécessaire
  void login() async {
    isLoading.value = true;   // commence le chargement
    await Future.delayed(Duration(seconds: 2)); // simulation attente
    isAuthenticated = true;
    isLoading.value = false;  // fin du chargement
  }

  void logout() {
    isAuthenticated = false;
  }

  void signInWithEmailAndPassword(String trim, String text) {}

  void registerWithEmailAndPassword(String trim, String trim2, String text) {}
}
