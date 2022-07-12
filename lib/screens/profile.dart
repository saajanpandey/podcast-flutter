import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:podcast/cubit/authUser/authuserdata_cubit.dart';
import 'package:podcast/cubit/profileImage/profile_image_cubit.dart';
import 'package:podcast/screens/bottomNavigation.dart';
import 'package:podcast/screens/editProfile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? avatar;
  int? gender;
  String? dob;
  String? email;
  var image;
  final _formkey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'My Profile',
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
      body: SingleChildScrollView(
        child: BlocListener<ProfileImageCubit, ProfileImageState>(
          listener: (context, state) {
            if (state is ProfileImageButtonPressed) {
              FocusScope.of(context).unfocus();
              loadingAlertBox();
            }
            if (state is ProfileImageSuccess) {
              EasyLoading.dismiss();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const BottomNavigationWidget(),
                  ),
                  (route) => false);
              final snackBar = SnackBar(
                content: const Text('Image Updated Successfully!'),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {},
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

            if (state is ProfileImageError) {
              EasyLoading.dismiss();
              errorAlertBox('Image Cannot Be Updated');
            }
          },
          child: BlocBuilder<AuthuserdataCubit, AuthuserdataState>(
            builder: (context, state) {
              if (state is AuthuserdataFetched) {
                name = state.authData.name;
                avatar = state.authData.avatar;
                gender = state.authData.gender;
                dob = state.authData.dateOfBirth;
                email = state.authData.email;
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      avatar != 'null'
                          ? Form(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      buttonActionSheet();
                                    },
                                    child: image == null
                                        ? Container(
                                            height: 250,
                                            child: Stack(
                                              children: [
                                                Center(
                                                    child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child:
                                                      Image.network('$avatar'),
                                                )),
                                                GestureDetector(
                                                  onTap: () {
                                                    buttonActionSheet();
                                                  },
                                                  child: const Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 130, 10),
                                                      child: Icon(
                                                        FontAwesomeIcons.camera,
                                                        size: 30,
                                                        color: Colors.purple,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(
                                            child: Image.file(
                                              File(image),
                                              height: 250,
                                            ),
                                          ),
                                  ),
                                  image != null || avatar == 'null'
                                      ? ElevatedButton(
                                          onPressed: () {
                                            if (image != null) {
                                              BlocProvider.of<
                                                          ProfileImageCubit>(
                                                      context)
                                                  .imageUpdate(image);
                                            } else {}
                                          },
                                          child: const Text('Update Image'),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            )
                          : Form(
                              key: _formkey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      buttonActionSheet();
                                    },
                                    child: image == null
                                        ? const CircleAvatar(
                                            radius: 70, // Image radius
                                            backgroundImage: AssetImage(
                                                'assets/images/avatar.jpg'),
                                          )
                                        : Container(
                                            child: Image.file(
                                              File(image),
                                              height: 250,
                                            ),
                                          ),
                                  ),
                                  image != null
                                      ? ElevatedButton(
                                          onPressed: () {
                                            if (image != null) {
                                              BlocProvider.of<
                                                          ProfileImageCubit>(
                                                      context)
                                                  .imageUpdate(image);
                                            } else {}
                                          },
                                          child: const Text('Update Image'),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 7,
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                name: name,
                                gender: gender,
                                userDOB: dob,
                                userAvatar: avatar,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ListTile(
                        leading: const Padding(
                          padding: EdgeInsets.only(left: 36.0),
                          child: Icon(
                            Icons.info,
                            color: Colors.purple,
                          ),
                        ),
                        title: const Padding(
                          padding: EdgeInsets.only(left: 35.0),
                          child: Text(
                            'Name',
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 35.0),
                          child: Text('$name'),
                        ),
                      ),
                      ListTile(
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
                      ),
                      ListTile(
                        leading: const Padding(
                          padding: EdgeInsets.only(left: 36.0),
                          child: Icon(
                            FontAwesomeIcons.calendar,
                            color: Colors.purple,
                          ),
                        ),
                        title: const Padding(
                          padding: EdgeInsets.only(left: 35.0),
                          child: Text(
                            'Date Of Birth',
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 35.0),
                          child: Text('$dob'),
                        ),
                      ),
                      ListTile(
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 36.0),
                          child: gender == 1
                              ? const Icon(
                                  FontAwesomeIcons.person,
                                  color: Colors.purple,
                                )
                              : const Icon(
                                  FontAwesomeIcons.personDress,
                                  color: Colors.purple,
                                ),
                        ),
                        title: const Padding(
                          padding: EdgeInsets.only(left: 35.0),
                          child: Text(
                            'Gender',
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 35.0),
                          child: gender == 1
                              ? const Text('Male')
                              : const Text('Female'),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  child: Text("Error"),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  imagepicker(type) async {
    var imagechoose = await _picker.pickImage(source: type);
    setState(() {
      imagechoose != null ? image = imagechoose.path : image;
    });
  }

  buttonActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () {
                imagepicker(ImageSource.camera);
                Navigator.pop(context, 'One');
              },
            ),
            ListTile(
              leading: Icon(Icons.collections),
              title: Text('Gallery'),
              onTap: () {
                imagepicker(ImageSource.gallery);
                Navigator.pop(context, 'two');
              },
            ),
          ],
        );
      },
    );
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

  successAlertBox(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Success'),
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

  loadingAlertBox() {
    EasyLoading.show(status: 'Uploading Image...');
  }
}
