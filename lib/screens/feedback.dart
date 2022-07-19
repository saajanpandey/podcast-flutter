import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:podcast/cubit/feedback/feedback_cubit.dart';
import 'package:podcast/screens/bottomNavigation.dart';

class FeedBackPage extends StatefulWidget {
  String? email;
  FeedBackPage({Key? key, this.email}) : super(key: key);

  @override
  State<FeedBackPage> createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  String? email;
  @override
  void initState() {
    email = '${widget.email}';
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  var title = TextEditingController();
  var message = TextEditingController();
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
                'Feedback',
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
        body: BlocListener<FeedbackCubit, FeedbackState>(
          listener: (context, state) {
            if (state is FeedbackSending) {
              FocusManager.instance.primaryFocus?.unfocus();
              sendingAlertBox();
            }
            if (state is FeedbackSuccess) {
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  EasyLoading.dismiss();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const BottomNavigationWidget()),
                      (route) => false);
                  final snackBar = SnackBar(
                    content: const Text('Feedback Sent Successfully!'),
                    action: SnackBarAction(
                      label: 'Close',
                      onPressed: () {},
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              );
            }
            if (state is FeedbackError) {
              errorAlertBox('Something Went Wrong..!');
            }
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Please Enter Title.',
                        labelText: 'Title',
                      ),
                      controller: title,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "The title field is required.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Please Enter Message.',
                        labelText: 'Message',
                      ),
                      controller: message,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "The message field is required.";
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
                          BlocProvider.of<FeedbackCubit>(context)
                              .postFeedback(email, title.text, message.text);
                        }
                      },
                      child: const Text('Send Feedback'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  sendingAlertBox() {
    EasyLoading.show(status: 'Sending Your Feedback....');
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
