import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:podcast/cubit/changePassword/change_password_cubit.dart';
import 'package:podcast/screens/login.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  var oldPassword = TextEditingController();
  var newPassword = TextEditingController();
  var confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChangePasswordCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocListener<ChangePasswordCubit, ChangePasswordState>(
            listener: (context, state) {
              if (state is ChangePasswordFetching) {
                loadingAlertBox();
              } else if (state is ChangePasswordSuccess) {
                EasyLoading.dismiss();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) => false);
                final snackBar = SnackBar(
                  content: const Text('Password Changed Successfully!'),
                  action: SnackBarAction(
                    label: 'Close',
                    onPressed: () {},
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                EasyLoading.dismiss();
                errorAlertBox('Password Cannot Be Changed!');
              }
            },
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    margin: const EdgeInsets.all(2),
                    color: Colors.yellow,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.yellow,
                      ),
                    ),
                    elevation: 0,
                    child: Column(
                      children: const [
                        ListTile(
                          leading: Icon(
                            Icons.info_outline_rounded,
                            size: 30.0,
                          ),
                          enableFeedback: false,
                          title: Text(
                            'Once your password has been changed you will be logged out.',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Current Password',
                            labelText: 'Current Password',
                          ),
                          controller: oldPassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "The current password field is required.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Enter New Password',
                            labelText: 'Enter New Password',
                          ),
                          controller: newPassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "The new password field is required.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const SizedBox(
                          child: Text(
                              '* Password must be 6 characters or more with least one letter and one number and a special character.'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Retype New Password',
                            labelText: 'Retype New Password',
                          ),
                          controller: confirmPassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "The retype password field is required.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            primary: Colors.purple,
                            onPrimary: Colors.white,
                            fixedSize: const Size(200, 70),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              BlocProvider.of<ChangePasswordCubit>(context)
                                  .changePassword(oldPassword.text,
                                      newPassword.text, confirmPassword.text);
                            }
                          },
                          child: const Text('Change Password'),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  loadingAlertBox() {
    EasyLoading.show(status: 'Changing Your Password.....');
  }

  errorAlertBox(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Failed'),
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
