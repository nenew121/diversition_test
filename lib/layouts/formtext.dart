import 'package:flutter/material.dart';

class FormText extends StatelessWidget {
  final String? text;
  final Widget wid;

  const FormText({
    Key? key,
    this.text,
    required this.wid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        (text != null)
            ? Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                width: size.width,
                child: Text(
                  text ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Container(),
        wid,
      ],
    );
  }
}
