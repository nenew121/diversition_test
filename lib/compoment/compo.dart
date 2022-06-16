import 'package:flutter/material.dart';

class Compo {
  Widget test(
      {String? text, required BuildContext context, required Widget wid}) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        (text != null)
            ? Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                width: size.width,
                child: Text(
                  text,
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
