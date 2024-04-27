import 'package:flutter/material.dart';
import 'package:online_note_app/models/list_tile_model.dart';
import 'package:online_note_app/widgets/custom_text.dart';

// ignore: must_be_immutable
class CustomListTile extends StatelessWidget {
  CustomListTile({
    super.key,
    required this.listTileData,
  });
  ListTileModel listTileData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: text(
          title: listTileData.title,
        ),
        trailing: listTileData.trailing);
  }
}
