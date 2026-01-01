import 'package:get/get.dart';
import 'package:voiceup/models/models.dart';


class AuthController extends GetxController {
  RxBool isAuthenticated = true.obs;
  RxBool isLoading = false.obs;

  // Utilisation du UserModel importé
  final Rx<UserModel> currentUser = UserModel(
    id: 'user1', // ID nécessaire pour UsersListController
    displayName: 'Mohamed Amine Hattay',
    email: 'hattay112@gmail.com',
    isOnline: true,
    lastSeen: DateTime.now(),
    photoURL: 'https://i.pravatar.cc/150?img=3',
  ).obs;

  // CORRECTION ICI : Retourner la valeur actuelle, pas null
  UserModel? get user => currentUser.value;

  void signInWithEmailAndPassword(String email, String password) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isAuthenticated.value = true;
    currentUser.value = UserModel(
      id: 'user1', // Mock ID
      displayName: 'Mohamed Amine Hattay',
      email: email,
      photoURL: 'https://i.pravatar.cc/150?img=3',
    );
    isLoading.value = false;
    print("Login mock pour $email");
  }

  void registerWithEmailAndPassword(String email, String password, String name) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isAuthenticated.value = true;
    currentUser.value = UserModel(
      id: 'user_new', // Mock ID
      displayName: name,
      email: email,
      photoURL: 'https://i.pravatar.cc/150?img=3',
    );
    isLoading.value = false;
    print("Register mock pour $email / $name");
  }

  void logout() {
    isAuthenticated.value = false;
    print("Logout mock");
  }

  Future<void> signOut() async {}
}