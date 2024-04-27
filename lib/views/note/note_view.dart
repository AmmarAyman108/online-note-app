import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:online_note_app/constant.dart';
import 'package:online_note_app/views/note/add_note.dart';
import 'package:online_note_app/widgets/back.dart';
import 'package:online_note_app/widgets/custom_text.dart';
import 'package:online_note_app/widgets/note_item.dart';

// ignore: must_be_immutable
class NoteView extends StatefulWidget {
  NoteView({super.key, required this.categoryId, required this.categoryName});
  String categoryId, categoryName;
  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> collectionStream = FirebaseFirestore.instance
        .collection('category')
        .doc(widget.categoryId)
        .collection('Notes')
        .orderBy('time', descending: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        leading: const Back(),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: text(
          title: widget.categoryName,
          fontSize: 30,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: StreamBuilder<QuerySnapshot>(
          stream: collectionStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Expanded(
                  child: NoteItem(
                    categoryId: widget.categoryId,
                    note: snapshot.data!.docs[index]['note'],
                    content: snapshot.data!.docs[index]['content'],
                    docId: snapshot.data!.docs[index].id,
                    oldNote: snapshot.data!.docs[index]['note'],
                    date: snapshot.data!.docs[index]['time'],
                  ),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNote(categoryId: widget.categoryId),
              ));
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
