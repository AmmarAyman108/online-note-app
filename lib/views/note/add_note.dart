import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:online_note_app/constant.dart';
import 'package:online_note_app/widgets/custom_button.dart';
import 'package:online_note_app/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class AddNote extends StatefulWidget {
  AddNote({super.key, required this.categoryId});
  String categoryId;
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController noteController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    CollectionReference category = FirebaseFirestore.instance
        .collection('category')
        .doc(widget.categoryId)
        .collection('Notes');
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
            'Add Note',
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
                  hint: 'Note Name',
                  contentPadding: const EdgeInsets.all(19),
                  controller: noteController,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  hint: 'Content',
                  contentPadding: const EdgeInsets.all(19),
                  controller: contentController,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(
                  title: 'Add',
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    await category.add({
                      'note': noteController.text,
                      'content': contentController.text,
                      'time':
                          '${DateTime.now().day}\\${DateTime.now().month}\\${DateTime.now().year}',
                    });
                    noteController.clear();

                    setState(() {
                      loading = false;
                    });
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
}
