import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:online_note_app/constant.dart';
import 'package:online_note_app/widgets/back.dart';
import 'package:online_note_app/widgets/custom_button.dart';
import 'package:online_note_app/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class EditNote extends StatefulWidget {
  EditNote({
    super.key,
    required this.oldNote,
    required this.docId,
    required this.oldContent,
    required this.categoryId,
  });
  String oldNote, oldContent, docId, categoryId;
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController noteController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool loading = false;
  @override
  void initState() {
    noteController.text = widget.oldNote;
    contentController.text = widget.oldContent;
    super.initState();
  }

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
          leading: const Back(),
          title: const Text(
            'Edit Note ',
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
                  hint: 'Edit Note',
                  contentPadding: const EdgeInsets.all(19),
                  controller: noteController,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  hint: 'Edit Content',
                  controller: contentController,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(
                  title: 'Update',
                  onTap: () async {
                    loading = true;
                    setState(() {});
                    await category.doc(widget.docId).update({
                      'note': noteController.text,
                      'content': contentController.text,
                      'time':
                          '${DateTime.now().day}\\${DateTime.now().month}\\${DateTime.now().year}',
                    });
                    noteController.clear();
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

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
}
