import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podcast/cubit/loginStatus/checkloginstatus_cubit.dart';
import 'package:podcast/screens/bottomNavigation.dart';
import 'package:podcast/screens/login.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
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
        child: Container(
          child: BlocProvider.of<CheckloginstatusCubit>(context).checkStatus(),
        ),
      ),
    );
  }
}
