import 'package:cosmetic_shop/core/widgets/app_field_widget.dart';
import 'package:cosmetic_shop/core/widgets/social_media_btn.dart';
import 'package:cosmetic_shop/features/auth/signin/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:cosmetic_shop/core/theme/app_theme.dart';
import 'package:cosmetic_shop/core/utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  bool isCheck = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    // TODO: call auth service
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _loading = false);
  }

  List<Map<String, dynamic>> socialList = [
    {
      "icon": Icons.facebook,
      "onTap": () {
        print("facebook");
      },
    },
    {
      "icon": Icons.apple,
      "onTap": () {
        print("apple");
      },
    },
    {
      "icon": Icons.email,
      "onTap": () {
        print("google");
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create an account to get started!',
                    style: TextStyle(fontSize: 15, color: AppColors.gray),
                  ),
                  const SizedBox(height: 40),
                  AppTextFieldWidget(
                    controller: _emailCtrl,
                    label: 'Name',
                    hint: 'Enter your name',
                    prefixIcon: Icons.person_outline,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 20),
                  AppTextFieldWidget(
                    controller: _emailCtrl,
                    label: 'Email',
                    hint: 'you@example.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 20),
                  AppTextFieldWidget(
                    controller: _passwordCtrl,
                    label: 'Password',
                    hint: 'Enter your password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    validator: Validators.password,
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Checkbox(
                          checkColor: AppColors.background,
                          activeColor: AppColors.primary,
                          value: isCheck,
                          onChanged: (c) {
                            setState(() {
                              isCheck = c!;
                            });
                          },
                        ),
                        Text(
                          "Agree with",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Terms and Conditions",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.4,
                              ),
                            )
                          : const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(height: 0.5, width: 50, color: AppColors.gray),
                      Text(
                        'Or continue with',
                        style: TextStyle(fontSize: 12, color: AppColors.gray),
                      ),
                      Container(height: 0.5, width: 50, color: AppColors.gray),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      socialList.length,
                      (index) => SocialMediaBtn(
                        icon: socialList[index]['icon'],
                        onTap: socialList[index]['onTap'],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Sign up
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignInScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
