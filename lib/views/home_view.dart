import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:online_note_app/constant.dart';
import 'package:online_note_app/views/category/add_category_view.dart';
import 'package:online_note_app/views/category/edit_category.dart';
import 'package:online_note_app/views/note/note_view.dart';
import 'package:online_note_app/widgets/custom_card.dart';
import 'package:online_note_app/widgets/custom_drawer.dart';
import 'package:online_note_app/widgets/custom_text.dart';

// ignore: must_be_immutable
class HomeView extends StatefulWidget {
  HomeView({super.key, this.id});
  String? id;
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool loading = false;
  Stream<QuerySnapshot> collectionStream = FirebaseFirestore.instance
      .collection('category')
      .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: const text(
          title: 'Note App',
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
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                  mainAxisSpacing: 15,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: CustomCard(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteView(
                              categoryId: snapshot.data!.docs[index].id,
                              categoryName: snapshot.data!.docs[index]
                                  ['category'],
                            ),
                          ));
                    },
                    title: snapshot.data!.docs[index]['category'],
                    onPressedEditIcon: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditCategory(
                              id: snapshot.data!.docs[index].id,
                              oldName: snapshot.data!.docs[index]['category'],
                            ),
                          ));
                    },
                    onPressedDeleteIcon: () {
                      loading = true;
                      setState(() {});
                      FirebaseFirestore.instance
                          .collection('category')
                          .doc(snapshot.data!.docs[index].id)
                          .delete();
                      loading = false;
                      setState(() {});
                    },
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
                builder: (context) => const AddCategory(),
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
