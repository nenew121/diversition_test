import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:omise_flutter/omise_flutter.dart';

import '../layouts/forminput.dart';
import '../layouts/formtext.dart';
import '../models/credit.dart';
import '../models/product.dart';

import 'package:http/http.dart' as http;

import '../resources/resources.dart';

class Page1 extends StatefulWidget {
  final Product product;
  final Function onLoad;
  final Function nevPage;
  final Function dialogFail;

  const Page1(
      {Key? key,
      required this.product,
      required this.onLoad,
      required this.nevPage,
      required this.dialogFail})
      : super(key: key);

  @override
  State<Page1> createState() => _Page1();
}

class _Page1 extends State<Page1> {
  final TextEditingController _controllerFullName = TextEditingController();
  final TextEditingController _controllerCardID = TextEditingController();
  final TextEditingController _controllerMonth = TextEditingController();
  final TextEditingController _controllerYear = TextEditingController();
  final TextEditingController _controllerCVC = TextEditingController();

  bool isValidateName = false;
  bool isValidateCard = false;
  bool isValidateMonth = false;
  bool isValidateYear = false;
  bool isValidateCVC = false;

  String sumStr = '0';

  Credit credit = Credit();

  static const publicKey = "pkey_test_5s52k7h4ybker66gcxi";
  OmiseFlutter omise = OmiseFlutter(publicKey);

  @override
  void initState() {
    super.initState();

    credit.fullName = 'ชื่อทดสอบ นามสกุลทดสอบ';
    credit.cardID = 4242424242424242;
    credit.month = 9;
    credit.year = 2022;
    credit.cvc = 123;

    _controllerFullName.text = credit.fullName!;
    _controllerCardID.text = credit.cardID.toString();
    _controllerMonth.text = credit.month.toString();
    _controllerYear.text = credit.year.toString();
    _controllerCVC.text = credit.cvc.toString();

    sumStr = ((widget.product.amount! * widget.product.num!)).toString();
  }

  getTokenAndChargeOmise() async {
    bool isSuscess = false;
    await omise.token
        .create(
      _controllerFullName.text,
      _controllerCardID.text,
      _controllerMonth.text,
      _controllerYear.text,
      _controllerCVC.text,
      city: widget.product.city,
      postalCode: widget.product.postalCode,
      phoneNumber: widget.product.phoneNumber,
    )
        .then(
      (value) async {
        String token = value.id.toString();
        Map<String, dynamic> data = {};
        data['amount'] =
            (widget.product.amount! * widget.product.num!).toString();
        data['currency'] = 'thb';
        data['card'] = token;

        http.Response reponse = await Resources().postCharges(data);

        var result = json.decode(reponse.body);
        print(result);
        isSuscess = true;
      },
    ).catchError((value) {
      isSuscess = false;
      print(value);
      widget.dialogFail();
    });
    return isSuscess;
  }

  validate() {
    isValidateName = _controllerFullName.text == '' ? true : false;
    isValidateCard = _controllerCardID.text == '' ? true : false;
    isValidateMonth = _controllerMonth.text == '' ? true : false;
    isValidateYear = _controllerYear.text == '' ? true : false;
    isValidateCVC = _controllerCVC.text == '' ? true : false;
    setState(() {});
    return !(isValidateName ||
        isValidateCard ||
        isValidateMonth ||
        isValidateYear ||
        isValidateCVC);
  }

  confrim() async {
    widget.onLoad(true);
    if (await getTokenAndChargeOmise()) {
      widget.nevPage();
    }
  }

  dialogConfrim() async {
    return await Dialogs.materialDialog(
      barrierDismissible: false,
      title: "ยืนยัน",
      msg: 'ใช้ Credit ในการชำระเงิน',
      color: Colors.white,
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          text: 'ยกเลิก',
          iconData: Icons.cancel_outlined,
          textStyle: const TextStyle(color: Colors.grey),
          iconColor: Colors.grey,
        ),
        IconsButton(
          onPressed: () {
            Navigator.of(context).pop();
            confrim();
          },
          text: 'ยืนยัน',
          iconData: Icons.check_circle,
          color: Colors.green,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ],
    );
  }

  body() {
    Size size = MediaQuery.of(context).size;
    EdgeInsets media = MediaQuery.of(context).viewPadding;
    return Stack(
      children: [
        SizedBox(
          height: size.height - 150 - media.bottom,
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // รายละเอียดบัตร
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                  width: size.width,
                  child: const Text(
                    'รายละเอียดบัตร',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // ชื่อ - นามสกุล
                FormInput(
                  controller: _controllerFullName,
                  text: 'ชื่อ - นามสกุล',
                  isVali: isValidateName,
                ),
                // เลขบัตร
                FormInput(
                  controller: _controllerCardID,
                  text: 'เลขบัตร',
                  type: TextInputType.number,
                  isVali: isValidateCard,
                ),
                // เดือนหมดอายุ
                FormInput(
                  controller: _controllerMonth,
                  text: 'เดือนหมดอายุ',
                  type: TextInputType.number,
                  isVali: isValidateMonth,
                ),
                // ปีหมดอายุ
                FormInput(
                  controller: _controllerYear,
                  text: 'ปีหมดอายุ',
                  type: TextInputType.number,
                  isVali: isValidateYear,
                ),
                // CVC
                FormInput(
                  controller: _controllerCVC,
                  text: 'CVC',
                  type: TextInputType.number,
                  isVali: isValidateCVC,
                ),
                // ยอดชำระ
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                  width: size.width,
                  child: Text(
                    'ยอดชำระ : $sumStr บาท',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // btn
        Positioned(
          bottom: 0,
          height: 50,
          child: FormText(
            wid: Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              width: size.width,
              child: ElevatedButton(
                child: const Text('ยืนยัน'),
                onPressed: () => validate() ? dialogConfrim() : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }
}
