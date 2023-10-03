// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koshki/auth/home_page.dart';
import 'package:koshki/auth/sign_in_screen.dart';
import 'package:koshki/common/widgets/components.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String id = 'signup_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;
  late String _confirmPass;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return true;
      },
      child: Scaffold(
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TopScreenImage(screenImageName: 'signup.png'),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const ScreenTitle(title: 'Регистрация'),
                          CustomTextField(
                            textField: TextField(
                              onChanged: (value) {
                                _email = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Email',
                              ),
                            ),
                          ),
                          CustomTextField(
                            textField: TextField(
                              obscureText: true,
                              onChanged: (value) {
                                _password = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Пароль',
                              ),
                            ),
                          ),
                          CustomTextField(
                            textField: TextField(
                              obscureText: true,
                              onChanged: (value) {
                                _confirmPass = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Подтвердите пароль',
                              ),
                            ),
                          ),
                          CustomBottomScreen(
                            textButton: 'Регистрация',
                            heroTag: 'signup_btn',
                            question: 'Уже есть аккаунт?',
                            buttonPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                _saving = true;
                              });
                              if (_confirmPass == _password) {
                                try {
                                  await _auth.createUserWithEmailAndPassword(
                                      email: _email, password: _password);

                                  if (context.mounted) {
                                    signUpAlert(
                                      context: context,
                                      title: 'Отлично',
                                      desc: 'Вы зарегистрировались',
                                      btnText: 'Войти',
                                      onPressed: () {
                                        setState(() {
                                          _saving = false;
                                          Navigator.popAndPushNamed(
                                              context, SignUpScreen.id);
                                        });
                                        Navigator.pushNamed(
                                            context, LoginScreen.id);
                                      },
                                    ).show();
                                  }
                                } catch (e) {
                                  signUpAlert(
                                      context: context,
                                      onPressed: () {
                                        SystemNavigator.pop();
                                      },
                                      title: 'Что-то пошло не так',
                                      desc:
                                          'Закройте приложение и попробуйте снова',
                                      btnText: 'Закрыть');
                                }
                              } else {
                                showAlert(
                                    context: context,
                                    title: 'Неверный пароль',
                                    desc:
                                        'Убедитесь что вы правильно ввели пароли',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }).show();
                              }
                            },
                            questionPressed: () async {
                              Navigator.pushNamed(context, LoginScreen.id);
                            },
                          ),
                        ],
                      ),
                    ),
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
