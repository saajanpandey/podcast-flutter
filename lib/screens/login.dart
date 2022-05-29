import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:podcast/cubit/login/login_cubit.dart';
import 'package:podcast/screens/bottomNavigation.dart';
import 'package:podcast/screens/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    configLoading();
    EasyLoading.addStatusCallback((status) {});
  }

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.wave
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..backgroundColor = Colors.white
      ..indicatorColor = Colors.purple
      ..textColor = Colors.black
      ..dismissOnTap = false;
  }

  final _formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  bool obsecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: BlocListener<LoginCubit, LoginState>(
          listener: ((context, state) {
            if (state is LoginButtonPressed) {
              FocusScope.of(context).unfocus();
              loadingAlertBox();
            }
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Future.delayed(const Duration(seconds: 3), () {
                EasyLoading.dismiss();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const BottomNavigationWidget()),
                    (route) => false);
              });
            }
            if (state is LoginError) {
              Future.delayed(const Duration(seconds: 3), () {
                EasyLoading.dismiss();
                errorAlertBox('Please provide valid credentials');
              });
            }
          }),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 36.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: Text(
                  'Enter your credentials to continue',
                  style: TextStyle(
                    fontSize: 10.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Please Enter Email.',
                            labelText: 'Email',
                            prefixIcon: const Icon(
                              FontAwesomeIcons.user,
                              // color: Colors.black,
                            ),
                          ),
                          controller: email,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "The email field is required.";
                            } else if (!EmailValidator.validate(value)) {
                              return "Please enter a valid email.";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextFormField(
                          controller: password,
                          obscureText: obsecure,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Please Enter Password',
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obsecure == false
                                      ? obsecure = true
                                      : obsecure = false;
                                });
                              },
                              child: obsecure == false
                                  ? const Icon(FontAwesomeIcons.eye)
                                  : const Icon(FontAwesomeIcons.eyeSlash),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "The password field is required.";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            primary: Colors.purple,
                            onPrimary: Colors.white,
                            fixedSize: const Size(200, 70)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<LoginCubit>(context)
                                .postLogin(email.text, password.text);
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        " Register",
                        style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  loadingAlertBox() {
    EasyLoading.show(status: 'Logging In...');
  }

  errorAlertBox(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text('$message'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }
}
