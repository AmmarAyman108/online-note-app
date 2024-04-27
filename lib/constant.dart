import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

// ignore: unnecessary_const
const Color kPrimaryColor = Color.fromARGB(255, 1, 74, 85);
// ignore: unnecessary_const
const Color kColor = const Color(0xff1D2733);
const String users = 'users';
const String kCategory = 'category';
const String notes = 'notes';
const String note = 'note';
const String content = 'content';
const String kUserInformationBox = 'user_information';
final String kUserId = FirebaseAuth.instance.currentUser!.uid;
