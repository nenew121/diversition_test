import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final Widget body;

  const Loading({Key? key, required this.body}) : super(key: key);

  Widget _loadCenter(Widget child) {
    return Container(
      alignment: AlignmentDirectional.center,
      decoration: const BoxDecoration(
        color: Colors.black54,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        body,
        _loadCenter(
          const SpinKitFadingCircle(
            color: Colors.white,
            size: 100,
          ),
        ),
        _loadCenter(
          const Text(
            'loading..',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
