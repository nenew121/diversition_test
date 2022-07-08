import 'package:flutter/material.dart';

class Appbar extends StatefulWidget {
  final String title;
  final double heightAppbar;
  final bool isShowBack;
  final bool isShowDrawer;

  const Appbar({
    Key? key,
    required this.title,
    required this.heightAppbar,
    required this.isShowBack,
    required this.isShowDrawer,
  }) : super(key: key);

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  Future<void> back() async {
    debugPrint('Back');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double padTop = MediaQuery.of(context).viewPadding.top;
    double sizeWidth = MediaQuery.of(context).size.width;
    double height = widget.heightAppbar;

    return Container(
      width: sizeWidth,
      padding: EdgeInsets.only(top: padTop),
      color: Colors.lightBlueAccent,
      child: Container(
        height: height,
        child: Stack(
          children: [
            // title
            Container(
              padding: EdgeInsets.fromLTRB(height, 12, height, 0),
              height: height,
              width: sizeWidth,
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // icon back
            widget.isShowBack
                ? GestureDetector(
                    onTap: back,
                    child: Container(
                      height: height,
                      width: height,
                      child: const Icon(
                        Icons.arrow_back_sharp,
                        size: 28,
                      ),
                    ),
                  )
                : Container(),
            // icon menu
            widget.isShowDrawer
                ? InkWell(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Container(
                      height: height,
                      width: height,
                      child: const Icon(Icons.menu),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
