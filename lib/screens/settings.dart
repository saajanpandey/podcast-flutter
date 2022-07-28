import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:podcast/cubit/authUser/authuserdata_cubit.dart';
import 'package:podcast/cubit/logout/logout_cubit.dart';
import 'package:podcast/screens/changePassword.dart';
import 'package:podcast/screens/feedback.dart';
import 'package:podcast/screens/login.dart';
import 'package:podcast/screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? message;
  String? name;
  String? avatar;
  int? gender;
  String? email;
  @override
  void initState() {
    BlocProvider.of<AuthuserdataCubit>(context).authUserCall();
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
              Future.delayed(
                const Duration(seconds: 3),
                () {
                  EasyLoading.dismiss();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false);
                  errorAlertBox(message);
                },
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                BlocBuilder<AuthuserdataCubit, AuthuserdataState>(
                  builder: (context, state) {
                    if (state is AuthuserdataFetching) {
                      fetchAlertBox();
                      return Container();
                    }
                    if (state is AuthuserdataFetched) {
                      EasyLoading.dismiss();
                      avatar = state.authData.avatar;
                      name = state.authData.name;
                      gender = state.authData.gender;
                      email = state.authData.email;
                      if (avatar == 'null' && gender == 1) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 26),
                          child: ListTile(
                            leading: const CircleAvatar(
                              radius: 28, // Image radius
                              backgroundImage:
                                  AssetImage('assets/images/maleAvatar.jpg'),
                            ),
                            title: Text('$name'),
                            subtitle: const Text('View Profile'),
                            trailing: const Icon(FontAwesomeIcons.arrowRight),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage()),
                              );
                            },
                          ),
                        );
                      } else if (avatar == 'null' && gender == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 26),
                          child: ListTile(
                            leading: const CircleAvatar(
                              radius: 28, // Image radius
                              backgroundImage:
                                  AssetImage('assets/images/femaleAvatar.png'),
                            ),
                            title: Text('$name'),
                            subtitle: const Text('View Profile'),
                            trailing: const Icon(FontAwesomeIcons.arrowRight),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage()),
                              );
                            },
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: ListTile(
                            style: ListTileStyle.list,
                            leading: CircleAvatar(
                              radius: 28, // Image radius
                              backgroundImage: NetworkImage("$avatar"),
                            ),
                            title: Text('$name'),
                            subtitle: const Text('View Profile'),
                            trailing: const Icon(FontAwesomeIcons.arrowRight),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage()),
                              );
                            },
                          ),
                        );
                      }
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: ListTile(
                          style: ListTileStyle.list,
                          leading: const CircleAvatar(
                            radius: 28, // Image radius
                            backgroundImage:
                                AssetImage('assets/images/maleAvatar.jpg'),
                          ),
                          title: Text('$name'),
                          subtitle: const Text('View Profile'),
                          trailing: const Icon(FontAwesomeIcons.arrowRight),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<AuthuserdataCubit, AuthuserdataState>(
                  builder: (context, state) {
                    return ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.only(left: 36.0),
                        child: Icon(
                          FontAwesomeIcons.envelope,
                          color: Colors.purple,
                        ),
                      ),
                      title: const Padding(
                        padding: EdgeInsets.only(left: 35.0),
                        child: Text(
                          'Email',
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 35.0),
                        child: Text('$email'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 36.0),
                    child: Icon(
                      Icons.feedback,
                      color: Colors.purple,
                    ),
                  ),
                  title: const Padding(
                    padding: EdgeInsets.only(left: 35.0),
                    child: Text('Feedback'),
                  ),
                  subtitle: const Padding(
                    padding: EdgeInsets.only(left: 35.0),
                    child: Text('Provide Your Feedback'),
                  ),
                  trailing: const Icon(FontAwesomeIcons.arrowRight),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeedBackPage(
                                email: email,
                              )),
                    );
                  },
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePassword(),
                      ),
                    );
                  },
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 36.0),
                    child: Icon(
                      Icons.lock,
                      color: Colors.purple,
                    ),
                  ),
                  title: const Padding(
                    padding: EdgeInsets.only(left: 35.0),
                    child: Text('Change Password'),
                  ),
                  subtitle: const Padding(
                    padding: EdgeInsets.only(left: 35.0),
                    child: Text('Reset Your Password'),
                  ),
                  trailing: const Icon(FontAwesomeIcons.arrowRight),
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                BlocBuilder<AuthuserdataCubit, AuthuserdataState>(
                  builder: (context, state) {
                    return ListTile(
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
                    );
                  },
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

  fetchAlertBox() {
    EasyLoading.show(status: 'Fetching User Information....');
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
