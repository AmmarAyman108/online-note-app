import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_note_app/views/note/edit_note.dart';

// ignore: must_be_immutable
class NoteItem extends StatelessWidget {
  NoteItem({
    super.key,
    required this.note,
    required this.docId,
    required this.date,
    required this.content,
    required this.categoryId,
    required this.oldNote,
    this.onTapIcon,
  });
  String note, content, oldNote, docId, categoryId;
  String date;
  void Function()? onTapIcon;

  @override
  Widget build(BuildContext context) {
    CollectionReference category = FirebaseFirestore.instance
        .collection('category')
        .doc(categoryId)
        .collection('Notes');
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditNote(
            categoryId: categoryId,
            docId: docId,
            oldNote: oldNote,
            oldContent: content,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(.3),
                  offset: const Offset(2, 2))
            ],
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                note,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              subtitle: Text(
                content,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black.withOpacity(.4),
                ),
              ),
              trailing: IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () async => await category.doc(docId).delete(),
                icon: const Icon(
                  Icons.delete,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              date,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
