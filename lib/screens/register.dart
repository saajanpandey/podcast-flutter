import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:podcast/cubit/register/register_cubit.dart';
import 'package:podcast/screens/bottomNavigation.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  var fullname = TextEditingController();
  var dateOfBirth = TextEditingController();

  bool obsecure = true;
  final List<String> genderItems = ['Male', 'Female'];

  String? selectedValue;
  int? gender;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterButtonPressed) {
              FocusScope.of(context).unfocus();
              loadingAlertBox();
            }
            if (state is RegisterSuccess) {
              // ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Future.delayed(const Duration(seconds: 2), () {
                EasyLoading.dismiss();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const BottomNavigationWidget()),
                    (route) => false);
              });
            }
            if (state is RegisterError) {
              EasyLoading.dismiss();
              errorMsg = state.registerModal.errors?.email?.first;
              if (errorMsg != null) {
                Alert(
                  context: context,
                  title: "Error",
                  desc: "$errorMsg",
                  buttons: [
                    DialogButton(
                      color: Colors.purple,
                      onPressed: () => Navigator.pop(context),
                      width: 120,
                      child: const Text(
                        "Dismiss",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ).show();
              } else {
                Alert(
                  context: context,
                  title: "Error",
                  desc: "Something Went Wrong",
                  buttons: [
                    DialogButton(
                      color: Colors.purple,
                      onPressed: () => Navigator.pop(context),
                      width: 120,
                      child: const Text(
                        "Dismiss",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ).show();
              }
            }
          },
          child: Center(
            child: Column(
              children: [
                const Text(
                  "Create New Account",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Please Enter Name.',
                            labelText: 'Name',
                          ),
                          controller: fullname,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "The name field is required.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          readOnly: true,
                          controller: dateOfBirth,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Please Select Your Date of Birth.',
                            labelText: 'Date Of Birth',
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1990),
                                lastDate: DateTime(2200));
                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              setState(() {
                                dateOfBirth.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please select a date.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Please select a gender.',
                            labelText: 'Gender',
                          ),
                          items: genderItems
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value.toString();
                              if (selectedValue == 'Male') {
                                gender = 1;
                              } else if (selectedValue == 'Female') {
                                gender = 0;
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Please select a gender.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Please Enter Email.',
                            labelText: 'Email',
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
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: password,
                          obscureText: obsecure,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'Please Enter Password',
                            labelText: 'Password',
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
                            String pattern =
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
                            RegExp regExp = RegExp(pattern);
                            if (!regExp.hasMatch(value)) {
                              return 'The password does not match the stated requirements.';
                            }
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                                'Password should have more than 6 characters.'),
                            Text('Password must contain a special character.'),
                            Text('Password should contain a capital letter.'),
                            Text('Password should contain a number.'),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
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
                              BlocProvider.of<RegisterCubit>(context)
                                  .postRegister(fullname.text, dateOfBirth.text,
                                      gender, email.text, password.text);
                            }
                          },
                          child: const Text('Register'),
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
    );
  }

  loadingAlertBox() {
    EasyLoading.show(status: 'Creating Your Account...');
  }

  errorAlertBox(message) {
    // AlertDialog(
    //   title: Container(
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Text(
    //         'Pick Item',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ),
    //     color: Colors.blueAccent,
    //   ),
    //   content: setupAlertDialoadContainer(context),
    // );
  }
}
