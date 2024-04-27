import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:online_note_app/cubits/theme_cubit/theme_cubit.dart';
import 'package:online_note_app/cubits/theme_cubit/theme_state.dart';
import 'package:online_note_app/views/auth/login_view.dart';
import 'package:online_note_app/widgets/custom_button.dart';
import 'package:online_note_app/widgets/custom_text.dart';
import 'package:online_note_app/widgets/custom_text_field.dart';
import 'package:online_note_app/widgets/logo.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});
  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
                height: 100,
              ),
              const text(
                title: 'Reset password to continue using the app',
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
              CustomButton(
                title: 'Send',
                onTap: () async {
                  if (key.currentState!.validate()) {
                    loading = true;
                    setState(() {});
                    try {
                      // ignore: use_build_context_synchronously
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email.text)
                          .then((value) {
                        CustomSnackBar(
                            // ignore: use_build_context_synchronously
                            context,
                            const Text(
                                'please go to your email and reset new password .'));
                        loading = false;
                        setState(() {});
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const LoginView()),
                            (Route<dynamic> route) => false);
                      }).catchError((e) {});
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        // ignore: use_build_context_synchronously
                        CustomSnackBar(context, const Text('User not found.'));
                        loading = false;
                        setState(() {});
                      } else if (e.code == "invalid-email") {
                        // ignore: use_build_context_synchronously
                        CustomSnackBar(context, const Text('Invalid Email.'));
                        loading = false;
                        setState(() {});
                      }
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      CustomSnackBar(context,
                          const Text('No Connection  , please try again.'));
                      loading = false;
                      setState(() {});
                    }
                    loading = false;
                    setState(() {});
                    // ignore: use_build_context_synchronously
                  } else {
                    autoValidateMode = AutovalidateMode.always;
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  void CustomSnackBar(context, content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: content));
  }
}
