import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:podcast/cubit/authUser/authuserdata_cubit.dart';
import 'package:podcast/cubit/login/login_cubit.dart';
import 'package:podcast/cubit/loginStatus/checkloginstatus_cubit.dart';
import 'package:podcast/cubit/logout/logout_cubit.dart';
import 'package:podcast/cubit/register/register_cubit.dart';
import 'package:podcast/screens/splash.dart';
import 'package:podcast/services/ApiService.dart';

final getIt = GetIt.instance;

void main() {
  getIt.registerSingleton<ApiService>(ApiService());
  WidgetsFlutterBinding.ensureInitialized();
  configLoading();
  runApp(
    BlocDefine(),
  );
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.wave
    ..indicatorSize = 45.0
    ..userInteractions = false
    ..dismissOnTap = false;
}

class BlocDefine extends StatelessWidget {
  const BlocDefine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ApiService(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(create: (context) => RegisterCubit()),
          BlocProvider(
              create: (context) => AuthuserdataCubit()..authUserCall()),
          BlocProvider(create: (context) => CheckloginstatusCubit()),
          BlocProvider(create: (context) => LogoutCubit()),
        ],
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
        ),
      ),
      debugShowCheckedModeBanner: false,
      // darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.dark,
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
