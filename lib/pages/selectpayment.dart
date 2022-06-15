import 'package:diversition_test/pages/tab1.dart';
import 'package:diversition_test/pages/tab2.dart';
import 'package:diversition_test/pages/tab3.dart';
import 'package:flutter/material.dart';
import '../compoment/bodypage.dart';
import '../models/product.dart';

class SelectPayment extends StatefulWidget {
  final Product product;

  const SelectPayment({super.key, required this.product});

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
  List<Widget> widgetOptions = <Widget>[];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widgetOptions = [
      Page1(product: widget.product),
      Page2(product: widget.product),
      Page3(product: widget.product),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Body().page(
      title: 'เลือกวิธีชำระเงิน',
      context: context,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: widgetOptions[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.credit_card,
            ),
            label: 'Credit',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.money,
            ),
            label: 'Bank',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.wallet,
            ),
            label: 'TrueMoney',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        onTap: ((value) {
          setState(() {
            selectedIndex = value;
          });
        }),
      ),
    );
  }
}
