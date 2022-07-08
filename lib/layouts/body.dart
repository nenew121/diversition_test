import 'package:flutter/material.dart';

import 'appbar.dart';
import 'loading.dart';

class Body extends StatefulWidget {
  final String title;
  final Widget body;
  final bool isShowBack;
  final bool isShowDrawer;
  final bool isLoading;
  final bool isPadTop;

  const Body({
    Key? key,
    required this.title,
    required this.body,
    this.isShowBack = false,
    this.isShowDrawer = false,
    this.isLoading = false,
    this.isPadTop = true,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  double heightAppbar = 50;

  Widget drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Header'),
          ),
          ListTile(
            title: const Text('test 1'),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('test 2'),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget body(BuildContext context) {
    double padTop = MediaQuery.of(context).viewPadding.top;
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            color: Colors.black12,
            height: size.height,
            width: size.width,
            padding: EdgeInsets.only(
                top: (heightAppbar + (widget.isPadTop ? padTop : 0))),
            child: widget.body,
          ),
        ),
        Appbar(
          title: widget.title,
          heightAppbar: heightAppbar,
          isShowBack: widget.isShowBack,
          isShowDrawer: widget.isShowDrawer,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: drawer(),
      body: widget.isLoading ? Loading(body: body(context)) : body(context),
    );
  }
}
