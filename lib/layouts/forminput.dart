import 'package:flutter/material.dart';

class FormInput extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final TextInputType type;
  final bool isVali;

  const FormInput({
    Key? key,
    required this.controller,
    required this.text,
    this.type = TextInputType.text,
    this.isVali = false,
  }) : super(key: key);

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          widget.controller.text == ''
              ? Container(
                  padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                  child: Text(
                    widget.text,
                    style: const TextStyle(color: Colors.black38),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: TextField(
              controller: widget.controller,
              keyboardType: widget.type,
              onChanged: (text) => setState(() {}),
              decoration: InputDecoration(
                errorText: widget.controller.text == '' && widget.isVali
                    ? 'กรุณากรอกข้อมูล $widget.text '
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
