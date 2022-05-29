import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:podcast/cubit/authUser/authuserdata_cubit.dart';
import 'package:podcast/cubit/logout/logout_cubit.dart';
import 'package:podcast/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? message;
  String? name = '';
  String? avatar = '';
  int? gender;
  @override
  void initState() {
    checksharedvalue();
    super.initState();
  }

  checksharedvalue() async {
    final pref = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Settings',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: BlocListener<LogoutCubit, LogoutState>(
          listener: (context, state) {
            if (state is LogoutPressed) {
              FocusScope.of(context).unfocus();
              loadingAlertBox();
            }
            if (state is LogoutSuccess) {
              message = state.logoutModal.message;
              Future.delayed(const Duration(seconds: 3), () {
                EasyLoading.dismiss();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
                errorAlertBox(message);
              });
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    BlocBuilder<AuthuserdataCubit, AuthuserdataState>(
                      builder: (context, state) {
                        if (state is AuthuserdataFetched) {
                          avatar = state.authData.avatar;
                          name = state.authData.name;
                          gender = state.authData.gender;
                          if (avatar != null) {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 48, // Image radius
                                backgroundImage: NetworkImage("$avatar"),
                              ),
                              title: Text('$name'),
                              subtitle: const Text('View Profile'),
                              trailing: const Icon(FontAwesomeIcons.arrowRight),
                            );
                          } else if (avatar == null && gender == 1) {
                            return ListTile(
                              style: ListTileStyle.list,
                              leading: const CircleAvatar(
                                radius: 48, // Image radius
                                backgroundImage:
                                    AssetImage('assets/images/maleAvatar.jpg'),
                              ),
                              title: Text('$name'),
                              subtitle: const Text('View Profile'),
                              trailing: const Icon(FontAwesomeIcons.arrowRight),
                            );
                          } else {
                            return ListTile(
                              leading: const CircleAvatar(
                                radius: 48, // Image radius
                                backgroundImage: AssetImage(
                                    'assets/images/femaleAvatar.jpg'),
                              ),
                              title: Text('$name'),
                              subtitle: const Text('View Profile'),
                              trailing: const Icon(FontAwesomeIcons.arrowRight),
                            );
                          }
                        } else {
                          return const ListTile(
                            leading: CircleAvatar(
                              radius: 48, // Image radius
                              backgroundImage:
                                  AssetImage("assets/images/logo1.png"),
                            ),
                            title: Text('John Doe'),
                            subtitle: Text('View Profile'),
                            trailing: Icon(FontAwesomeIcons.arrowRight),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 36.0),
                    child: Icon(
                      FontAwesomeIcons.arrowRightFromBracket,
                      color: Colors.purple,
                    ),
                  ),
                  title: const Padding(
                    padding: EdgeInsets.only(left: 35.0),
                    child: Text(
                      'Logout',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 35.0),
                    child: Text('You are logged in as $name'),
                  ),
                  onTap: () {
                    BlocProvider.of<LogoutCubit>(context).logout();
                  },
                  onLongPress: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loadingAlertBox() {
    EasyLoading.show(status: 'Logging Out...');
  }

  errorAlertBox(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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
