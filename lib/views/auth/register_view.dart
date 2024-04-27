import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:online_note_app/constant.dart';
import 'package:online_note_app/cubits/theme_cubit/theme_cubit.dart';
import 'package:online_note_app/cubits/theme_cubit/theme_state.dart';
import 'package:online_note_app/models/user_information_model.dart';
import 'package:online_note_app/views/home_view.dart';
import 'package:online_note_app/widgets/center_text.dart';
import 'package:online_note_app/widgets/custom_button.dart';
import 'package:online_note_app/widgets/custom_text.dart';
import 'package:online_note_app/widgets/custom_text_field.dart';
import 'package:online_note_app/widgets/logo.dart';

// ignore: must_be_immutable
class RegisterView extends StatefulWidget {
  static String id = 'LoginView';

  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool obscureText = true;
  bool loading = false;
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  GlobalKey<FormState> key = GlobalKey();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Form(
          autovalidateMode: autoValidateMode,
          key: key,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: BlocBuilder<ThemeCubit, ThemeState>(
                      builder: (context, state) {
                        if (state is InitialState || state is LightThemeState) {
                          return IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                BlocProvider.of<ThemeCubit>(context)
                                    .theme(context);
                              },
                              icon: const Icon(Icons.dark_mode));
                        } else {
                          return IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                BlocProvider.of<ThemeCubit>(context)
                                    .theme(context);
                              },
                              icon: const Icon(Icons.light_mode));
                        }
                      },
                    ),
                  )
                ],
              ),
              const Logo(),
              const SizedBox(
                height: 10,
              ),
              const text(
                title: 'Register',
                textAlign: TextAlign.center,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 30,
              ),
              const text(
                title: 'Register to continue using the app',
                fontSize: 18,
              ),
              const SizedBox(
                height: 10,
              ),
              const text(
                title: 'Name',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                hint: 'Enter your Name',
                controller: name,
                icon: const Icon(Icons.person),
              ),
              const SizedBox(
                height: 15,
              ),
              const text(
                title: 'Email',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                  controller: email,
                  hint: 'Enter your Email',
                  icon: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(
                height: 15,
              ),
              const text(
                title: 'Password',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                hint: 'Password',
                controller: password,
                icon: obscureText
                    ? IconButton(
                        onPressed: () {
                          obscureText = !obscureText;
                          setState(() {});
                        },
                        icon: const Icon(Icons.visibility))
                    : IconButton(
                        onPressed: () {
                          obscureText = !obscureText;
                          setState(() {});
                        },
                        icon: const Icon(Icons.visibility_off)),
                obscureText: obscureText,
              ),
              const SizedBox(
                height: 25,
              ),
              CustomButton(
                  title: 'Register',
                  onTap: () async {
                    if (key.currentState!.validate()) {
                      loading = true;
                      setState(() {});
                      try {
                        // ignore: unused_local_variable
                        await AuthByEmailAndPassword();
                        await addUser();
                        var box =
                            Hive.box<UserInformationModel>(kUserInformationBox);
                        box.put(
                            'user',
                            UserInformationModel(
                                email: email.text, name: name.text));
                        loading = false;
                        setState(() {});
                        // ignore: use_build_context_synchronously
                        CustomSnackBar(const Text('Success Register'));

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => HomeView(
                                      id: FirebaseAuth
                                          .instance.currentUser!.uid,
                                    )),
                            (Route<dynamic> route) => false);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          // ignore: use_build_context_synchronously
                          CustomSnackBar(
                              const Text('The password provided is too weak.'));
                          loading = false;
                          setState(() {});
                        } else if (e.code == 'email-already-in-use') {
                          // ignore: use_build_context_synchronously
                          CustomSnackBar(const Text(
                              'The account already exists for that email.'));
                          loading = false;
                          setState(() {});
                        } else if (e.code == "invalid-email") {
                          // ignore: use_build_context_synchronously
                          CustomSnackBar(const Text('invalid-email'));
                          loading = false;
                          setState(() {});
                        }
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        CustomSnackBar(
                            const Text('No Connection  , please try again.'));
                        loading = false;
                        setState(() {});
                      }
                      loading = false;
                      setState(() {});
                    } else {
                      autoValidateMode = AutovalidateMode.always;
                      setState(() {});
                    }
                  }),
              const SizedBox(
                height: 30,
              ),
              CenterText(
                textHint: 'Don\'t have an account ? ',
                textButton: ' Login',
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  void CustomSnackBar(content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: content));
  }

  // ignore: non_constant_identifier_names
  Future<void> AuthByEmailAndPassword() async {
    // ignore: unused_local_variable
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.text,
      password: password.text,
    );
    FirebaseAuth.instance.currentUser!.updateDisplayName(name.text);
    FirebaseAuth.instance.currentUser!.updateEmail(email.text);
  }

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users.add({
      'name': name.text,
      'email': email.text,
      'id': FirebaseAuth.instance.currentUser!.uid
    });
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }
}
