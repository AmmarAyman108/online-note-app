import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:online_note_app/cubits/theme_cubit/theme_cubit.dart';
import 'package:online_note_app/cubits/theme_cubit/theme_state.dart';
import 'package:online_note_app/views/auth/forget_password.dart';
import 'package:online_note_app/views/home_view.dart';
import 'package:online_note_app/views/auth/register_view.dart';
import 'package:online_note_app/widgets/center_text.dart';
import 'package:online_note_app/widgets/custom_button.dart';
import 'package:online_note_app/widgets/custom_text.dart';
import 'package:online_note_app/widgets/custom_text_field.dart';
import 'package:online_note_app/widgets/end_text.dart';
import 'package:online_note_app/widgets/logo.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool obscureText = true;
  bool loading = false;
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
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
                title: 'Login',
                textAlign: TextAlign.center,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 30,
              ),
              const text(
                title: 'Login to continue using the app',
                fontSize: 18,
              ),
              const SizedBox(
                height: 10,
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
                  hint: 'Enter your Email',
                  controller: email,
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
                controller: password,
                hint: 'Password',
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
                height: 5,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgetPasswordView(),
                      ),
                    );
                  },
                  child: EndText(title: 'Forget Password ? ')),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                title: 'Login',
                onTap: () async {
                  if (key.currentState!.validate()) {
                    loading = true;
                    setState(() {});
                    try {
                      await LoginByEmailAndPassword();
                      // ignore: use_build_context_synchronously
                      CustomSnackBar(const Text('Success Login.'));
                      loading = false;
                      setState(() {});
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomeView()),
                          (Route<dynamic> route) => false);
                    } on FirebaseAuthException catch (e) {
                      switch (e.code) {
                        case 'invalid-email':
                          // ignore: use_build_context_synchronously
                          CustomSnackBar(const Text('Invalid Email.'));
                          break;
                        case 'wrong-password':
                          CustomSnackBar(const Text('Wrong password.'));
                          break;
                        case 'user-not-found':
                        case 'invalid-credential':
                          CustomSnackBar(const Text('User not found.'));
                          break;
                        case 'user-disabled':
                          CustomSnackBar(const Text('user disabled'));
                          break;
                        default:
                          {
                            CustomSnackBar(const Text(
                                'No Connection  , please try again.'));
                          }
                      }

                      loading = false;
                      setState(() {});
                      // ignore: use_build_context_synchronously
                    }
                  } else {
                    autoValidateMode = AutovalidateMode.always;
                    setState(() {});
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              CenterText(
                textHint: 'Don\'t have an account ? ',
                textButton: ' Register',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterView(),
                  ),
                ),
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
  Future<void> LoginByEmailAndPassword() async {
    // ignore: unused_local_variable

    // ignore: unused_local_variable
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text,
      password: password.text,
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
