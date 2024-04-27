import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:online_note_app/constant.dart';
import 'package:online_note_app/widgets/custom_button.dart';
import 'package:online_note_app/widgets/custom_text_field.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  TextEditingController categoryController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          leading: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 30,
                color: Colors.white,
              )),
          title: const Text(
            'Add Category',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: loading,
          child: Padding(
            padding: const EdgeInsets.only(top: 100, left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  hint: 'Category',
                  contentPadding: const EdgeInsets.all(19),
                  controller: categoryController,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(
                  title: 'Add',
                  onTap: () async {
                    loading = true;
                    setState(() {});
                    await category.add({
                      'category': categoryController.text,
                      'id': FirebaseAuth.instance.currentUser!.uid,
                    });
                    categoryController.clear();
                    loading = false;
                    setState(() {});
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ));
  }
}
