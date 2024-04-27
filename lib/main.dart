// ignore_for_file: unnecessary_import

import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:online_note_app/constant.dart';
import 'package:online_note_app/cubits/theme_cubit/theme_cubit.dart';
import 'package:online_note_app/firebase_options.dart';
import 'package:online_note_app/models/user_information_model.dart';
import 'package:online_note_app/views/home_view.dart';
import 'package:online_note_app/views/auth/login_view.dart';
import 'package:path_provider/path_provider.dart';

bool dark = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory path = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(path.path);
  Hive.registerAdapter(UserInformationModelAdapter());
  await Hive.openBox<UserInformationModel>(kUserInformationBox);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => BlocProvider(
        create: (context) => ThemeCubit(),
        child: MaterialApp(
          theme: theme,
          darkTheme: darkTheme,
          home: FirebaseAuth.instance.currentUser == null
              ? const LoginView()
              : HomeView(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
