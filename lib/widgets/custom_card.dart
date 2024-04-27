import 'package:flutter/material.dart';
import 'package:online_note_app/constant.dart';

// ignore: must_be_immutable
class CustomCard extends StatefulWidget {
  CustomCard(
      {super.key,
      required this.title,
      this.onPressedEditIcon,
      required this.onPressedDeleteIcon,
      this.onPressed});
  String title;
  Function()? onPressedEditIcon;
  Function()? onPressedDeleteIcon;
  Function()? onPressed;
  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 5, 5, 7),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(.2),
                  offset: const Offset(2, 2))
            ]),
        child: Padding(
          padding: const EdgeInsets.only(),
          child: ClipRRect(
            borderRadius:
                const BorderRadius.only(bottomRight: Radius.circular(20)),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Image.asset('assets/images/logo.jpg',
                            fit: BoxFit.fill)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            widget.title.length > 10
                                ? widget.title.substring(0, 10)
                                : widget.title,
                            style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Positioned(
                  right: -40,
                  bottom: -60,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(20)),
                    child: CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      radius: 55,
                    ),
                  ),
                ),
                Positioned(
                    right: -10,
                    bottom: 0,
                    child: IconButton(
                        onPressed: widget.onPressedDeleteIcon,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ))),
                Positioned(
                    right: 20,
                    bottom: 0,
                    child: IconButton(
                        onPressed: widget.onPressedEditIcon,
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
