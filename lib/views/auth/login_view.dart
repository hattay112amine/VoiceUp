import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voiceup/controllers/auth_controller.dart';
import 'package:voiceup/routes/app_routes.dart';
import 'package:voiceup/theme/app_theme.dart';

class LoginView extends StatefulWidget {

  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}
class _LoginViewState extends State<LoginView> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthController _authController = Get.find<AuthController>();
  bool _obsecurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.record_voice_over,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Text("Welcome Back!",
                    style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 8),
                Text("Sign in to continue chatting with friends & family",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                ),
                SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: 'Enter your email',
                  ), // InputDecoration
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your email';
                    }
                    if(!GetUtils.isEmail(value!)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ), // TextFormField
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obsecurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obsecurePassword = !_obsecurePassword;
                        });
                      }, icon: Icon(_obsecurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    ),
                  ), // InputDecoration
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your password';
                    }
                    if(value!.length<6){
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                Obx(
                      () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      onPressed: _authController.isLoading.value ? null : () {
                        if(_formkey.currentState?.validate()??false){
                          _authController.signInWithEmailAndPassword(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                        }
                      },
                      child: _authController.isLoading.value
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ), // CircularProgressIndicator
                      ) // SizedBox
                          : Text('Sign In'),
                    ), // ElevatedButton
                  ), // SizedBox
                ), // Obx
                SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.forgotPassword);
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: AppTheme.primaryColor),
                    ), // Text
                  ), // TextButton
                ), // Center
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: AppTheme.borderColor),
                    ), // Expanded
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "OR",
                        style: Theme.of(context).textTheme.bodySmall,
                      ), // Text
                    ), // Padding
                    Expanded(
                      child: Divider(color: AppTheme.borderColor),
                    ), // Expanded
                  ],
                ), // Row
                SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: Theme.of(context).textTheme.bodyMedium,
                ), // Text
                SizedBox(width: 8),

                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.register),
                  child: Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ), // Text
                ), // GestureDetector
              ],
            ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}