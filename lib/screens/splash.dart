import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podcast/cubit/loginStatus/checkloginstatus_cubit.dart';
import 'package:podcast/screens/authCheck.dart';
import 'package:podcast/screens/bottomNavigation.dart';
import 'package:podcast/screens/login.dart';
import 'package:podcast/services/StorageService.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? loginstatus;
  @override
  void initState() {
    super.initState();
    timer();
    checkloginstatus();
  }

  timer() {
    var duration = const Duration(seconds: 5);
    return Timer(duration, navigationPage);
  }

  checkloginstatus() async {
    loginstatus = await StorageService().getLoginStatus();
  }

  navigationPage() {
    if (loginstatus == true) {
      BlocProvider.of<CheckloginstatusCubit>(context).checkStatus();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CheckloginstatusCubit, CheckloginstatusState>(
        listener: (context, state) {
          if (state is CheckloginstatusTrue) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => BottomNavigationWidget()),
                (route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false);
          }
        },
        child: SizedBox(
          child: Stack(
            children: [
              Align(
                alignment: FractionalOffset.center,
                child: Image.asset(
                  'assets/images/loginlogo.png',
                  scale: 0.6,
                ),
              ),
              const Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: 20,
                          fontStyle: FontStyle.italic),
                      "For Those Who Listen"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
