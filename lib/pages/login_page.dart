import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news/helpers/constant.dart';
import 'package:news/helpers/dio_api.dart';
import 'package:news/models/auth_model.dart';
import 'package:news/pages/home_page.dart';
import 'package:news/widgets/text_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final _identityController = TextEditingController();
  late final _passwordController = TextEditingController();
  late bool _hidePassword = true;
  late double fullWidth = MediaQuery.of(context).size.width;

  late bool _isLoading = false;

  void _login({required String username, required String password}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final Response response = await DioApi.dio.post(
        'account/post_Login',
        data: {
          'username': username,
          'password': password,
        },
      );

      final AuthModel authModel = AuthModel.fromJson(response.data);

      if (authModel.status.code >= 200 && authModel.status.code <= 299) {
        SharedPreferences.getInstance().then((sharedPreferences) {
          sharedPreferences.setString(keyUsername, username);
          sharedPreferences.setString(keyToken, authModel.data);
        });

        _redirectToHomePage();
      } else {
        final SnackBar snackBar = SnackBar(
          content: Text(authModel.status.message),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('StackTrace: $stackTrace');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _redirectToHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((sharedPreferences) {
      final String userName = sharedPreferences.getString(keyUsername) ?? '';

      if (userName.isNotEmpty) {
        _redirectToHomePage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: fullWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.arrow_turn_up_left,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  "Let's sign you in.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                child: const Text(
                  "Welcome back.\nYou've been missed!",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 28,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: TextInput(
                  controller: _identityController,
                  hintText: 'Phone, email or username',
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                child: TextInput(
                  controller: _passwordController,
                  hintText: 'Password',
                  hidePassword: _hidePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    },
                    icon: Icon(
                      _hidePassword
                          ? CupertinoIcons.eye
                          : CupertinoIcons.eye_slash,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              _isLoading
                  ? Center(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Container(
                      width: fullWidth,
                      height: 52,
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () {
                          _login(
                            username: _identityController.text,
                            password: _passwordController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                        ),
                        child: const Text("Sign in"),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
