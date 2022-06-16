import 'package:diversition_test/pages/tab1.dart';
import 'package:diversition_test/pages/tab2.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import '../compoment/bodypage.dart';
import '../compoment/loading.dart';
import '../models/product.dart';
import 'confrimpayment.dart';

class SelectPayment extends StatefulWidget {
  final Product product;

  const SelectPayment({super.key, required this.product});

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
  List<Widget> widgetOptions = <Widget>[];

  int selectedIndex = 0;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    widgetOptions = [
      Page1(
        product: widget.product,
        onLoad: onLoad,
        nevPage: nevPage,
        dialogFail: dialogFail,
      ),
      Page2(
        product: widget.product,
        onLoad: onLoad,
        nevPage: nevPage,
        dialogFail: dialogFail,
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  onLoad(value) {
    isLoading = value;
    setState(() {});
  }

  dialogFail() async {
    return await Dialogs.materialDialog(
      barrierDismissible: false,
      title: "ผิดพลาด",
      msg: 'กรุณากรอกข้อมูล / ตรวจสอบข้อมูลใหม่ อีกครั้ง',
      color: Colors.white,
      context: context,
      actions: [
        IconsButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: 'ตกลง',
          // iconData: Icons.check_circle,
          color: Colors.blue,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  nevPage() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: ((context) => ConfrimPayment(product: widget.product)),
        ),
        (route) => false);
  }

  body() {
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

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Material(
            child: Loading(
              body: body(),
            ),
          )
        : body();
  }
}
