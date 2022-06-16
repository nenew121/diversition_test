import 'package:flutter/material.dart';

class Body {
  Widget page({
    required String title,
    required BuildContext context,
    required Widget body,
    Widget? bottomNavigationBar,
    bool isLoading = false,
  }) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets media = MediaQuery.of(context).viewPadding;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          // fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.orange[400],
      ),
      body: Container(
        color: Colors.grey[200],
        height: size.height,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, media.bottom),
          child: body,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
