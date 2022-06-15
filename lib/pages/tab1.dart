import 'dart:convert';

import 'package:diversition_test/pages/confrimpayment.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:omise_flutter/omise_flutter.dart';

import '../compoment/compo.dart';
import '../models/product.dart';

import 'package:http/http.dart' as http;

class Page1 extends StatefulWidget {
  final Product product;

  const Page1({Key? key, required this.product}) : super(key: key);

  @override
  State<Page1> createState() => _Page1();
}

class _Page1 extends State<Page1> {
  final TextEditingController _controllerFullName = TextEditingController();
  final TextEditingController _controllerCardID = TextEditingController();
  final TextEditingController _controllerMonth = TextEditingController();
  final TextEditingController _controllerYear = TextEditingController();
  final TextEditingController _controllerCVC = TextEditingController();

  bool _isDisable = false;
  bool isValidateName = false;
  bool isValidateCard = false;
  bool isValidateMonth = false;
  bool isValidateYear = false;
  bool isValidateCVC = false;

  String sumStr = '0';

  /// Get your public key on Omise Dashboard
  static const publicKey = "pkey_test_5s52k7h4ybker66gcxi";
  OmiseFlutter omise = OmiseFlutter(publicKey);

  @override
  void initState() {
    super.initState();
    _controllerFullName.text = 'ชื่อทดสอบ นามสกุลทดสอบ';
    _controllerCardID.text = '4242424242424242';
    _controllerMonth.text = '9';
    _controllerYear.text = '2022';
    _controllerCVC.text = '123';

    sumStr = ((widget.product.amount! * widget.product.num!) / 100).toString();
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
        String secreKey = 'skey_test_5s52k7ilttrvp6n4owa';
        String urlAPI = 'https://api.omise.co/charges';
        String basicAuth = 'Basic ${base64Encode(utf8.encode("$secreKey:"))}';

        Map<String, String> headerMap = {};
        headerMap['authorization'] = basicAuth;
        headerMap['Cache-Control'] = 'no-cache';
        headerMap['Content-Type'] = 'application/x-www-form-urlencoded';

        Map<String, dynamic> data = {};
        data['amount'] =
            (widget.product.amount! * widget.product.num!).toString();
        data['currency'] = 'thb';
        data['card'] = token;

        Uri uri = Uri.parse(urlAPI);
        http.Response reponse = await http.post(
          uri,
          headers: headerMap,
          body: data,
        );

        var result = json.decode(reponse.body);
        isSuscess = true;
        print(result);
      },
    ).catchError((value) {
      isSuscess = false;
      print(value);
    });
    return isSuscess;
  }

  validate() {
    isValidateName = _controllerFullName.text == '' ? true : false;
    isValidateCard = _controllerCardID.text == '' ? true : false;
    isValidateMonth = _controllerMonth.text == '' ? true : false;
    isValidateYear = _controllerYear.text == '' ? true : false;
    isValidateCVC = _controllerCVC.text == '' ? true : false;
    return !(isValidateName ||
        isValidateCard ||
        isValidateMonth ||
        isValidateYear ||
        isValidateCVC);
  }

  confrim() async {
    _isDisable = true;
    setState(() {});
    if (validate() && await getTokenAndChargeOmise()) {
      await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: ((context) => ConfrimPayment(product: widget.product)),
          ),
          (route) => false);
    }
    _isDisable = false;
    setState(() {});
  }

  dialogConfrim() async {
    return await Dialogs.materialDialog(
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
        ]);
  }

  backPage() {
    Navigator.pop(context);
  }

  formInput({
    required TextEditingController controller,
    required String text,
    TextInputType type = TextInputType.text,
    bool isVali = false,
  }) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          controller.text == ''
              ? Container(
                  padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.black38),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: TextField(
              controller: controller,
              keyboardType: type,
              onChanged: (text) => setState(() {}),
              decoration: InputDecoration(
                errorText: controller.text == '' && isVali
                    ? 'กรุณากรอกข้อมูล $text '
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                formInput(
                  controller: _controllerFullName,
                  text: 'ชื่อ - นามสกุล',
                  isVali: isValidateName,
                ),
                // เลขบัตร
                formInput(
                  controller: _controllerCardID,
                  text: 'เลขบัตร',
                  type: TextInputType.number,
                  isVali: isValidateCard,
                ),
                // เดือนหมดอายุ
                formInput(
                  controller: _controllerMonth,
                  text: 'เดือนหมดอายุ',
                  type: TextInputType.number,
                  isVali: isValidateMonth,
                ),
                // ปีหมดอายุ
                formInput(
                  controller: _controllerYear,
                  text: 'ปีหมดอายุ',
                  type: TextInputType.number,
                  isVali: isValidateYear,
                ),
                // CVC
                formInput(
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
          child: Compo().test(
            context: context,
            wid: Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              width: size.width,
              child: ElevatedButton(
                child: const Text('ยืนยัน'),
                onPressed: () => _isDisable ? null : dialogConfrim(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
