import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:online_note_app/constant.dart';
import 'package:online_note_app/cubits/theme_cubit/theme_cubit.dart';
import 'package:online_note_app/models/list_tile_model.dart';
import 'package:online_note_app/models/user_information_model.dart';
import 'package:online_note_app/views/auth/login_view.dart';
import 'package:online_note_app/widgets/custom_list_tile.dart';
import 'package:online_note_app/widgets/custom_text.dart';

// ignore: must_be_immutable
class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Query users = FirebaseFirestore.instance
      .collection('users')
      .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
  String? name, email;
  @override
  void initState() {
    super.initState();
    var box = Hive.box<UserInformationModel>(kUserInformationBox);
    name = box.get('user')!.name;
    email = box.get('user')!.email;
  }

  @override
  Widget build(BuildContext context) {
    List<ListTileModel> listTileData = [
      ListTileModel(
          title: 'Dark Mode',
          trailing: Switch(
            value: !BlocProvider.of<ThemeCubit>(context).lightTheme,
            onChanged: (value) {
              BlocProvider.of<ThemeCubit>(context).theme(context);
            },
          )),
      ListTileModel(
        title: 'Log Out',
        trailing: IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ),
                (route) => false);
          },
          icon: const Icon(Icons.logout_rounded),
        ),
      )
    ];
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: kPrimaryColor),
            currentAccountPicture: const Padding(
              padding: EdgeInsets.only(bottom: 5, right: 5),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(
                  'assets/images/xm.jpg',
                ),
              ),
            ),
            accountName: text(
              title: name!,
              fontSize: 16,
            ),
            accountEmail: text(
              title: email!,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) => CustomListTile(
                      listTileData: listTileData[index],
                    ),
                separatorBuilder: (context, index) => Divider(
                      color: Colors.grey.withOpacity(.5),
                      endIndent: 30,
                      indent: 30,
                      height: 1,
                    ),
                itemCount: listTileData.length),
          ),
        ],
      ),
    );
  }
}
