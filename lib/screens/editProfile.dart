import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:podcast/cubit/userUpdate/userupdate_cubit.dart';
import 'package:podcast/screens/bottomNavigation.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditProfilePage extends StatefulWidget {
  final String? name;
  final int? gender;
  final String? userDOB;
  final String? userAvatar;

  const EditProfilePage(
      {Key? key, this.name, this.gender, this.userDOB, this.userAvatar})
      : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final List<String> genderItems = ['Male', 'Female'];

  String? selectedValue;
  String? avatar;
  String? name;
  int? gender;
  String? userGender;
  String? userDOB;
  bool? status;

  final _formKey = GlobalKey<FormState>();
  var fullname = TextEditingController();
  var dateOfBirth = TextEditingController();

  @override
  void initState() {
    fullname.text = '${widget.name}';
    dateOfBirth.text = '${widget.userDOB}';
    userGender = '${widget.gender}';
    avatar = '${widget.userAvatar}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.xmark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<UserupdateCubit, UserupdateState>(
        listener: (context, state) {
          if (state is UserupdateButtonPressed) {
            FocusScope.of(context).unfocus();
            loadingAlertBox();
          }
          if (state is UserupdateSuccess) {
            Future.delayed(
              const Duration(seconds: 2),
              () {
                EasyLoading.dismiss();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const BottomNavigationWidget()),
                    (route) => false);
                final snackBar = SnackBar(
                  content: const Text('Profile Updated Successfully!'),
                  action: SnackBarAction(
                    label: 'Close',
                    onPressed: () {},
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            );
          }
          if (state is UserupdateError) {
            EasyLoading.dismiss();
            Alert(
              context: context,
              title: "Error",
              desc: "Something went wrong!",
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
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Edit Your Information',
                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
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
                        value: userGender == '1' ? 'Male' : 'Female',
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
                          setState(() {
                            if (value == 'Female') {
                              gender = 0;
                            } else if (value == 'Male') {
                              gender = 1;
                            }
                          });
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
                              dateOfBirth.text = formattedDate;
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
                            BlocProvider.of<UserupdateCubit>(context)
                                .userUpdate(
                                    fullname.text, dateOfBirth.text, gender);
                          }
                        },
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loadingAlertBox() {
    EasyLoading.show(status: 'Updating your profile...');
  }
}
