import 'dart:convert';

import 'package:diversition_test/pages/confrimpayment.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:omise_flutter/omise_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../compoment/compo.dart';
import '../models/product.dart';

import 'package:http/http.dart' as http;

class Page2 extends StatefulWidget {
  final Product product;

  const Page2({Key? key, required this.product}) : super(key: key);

  @override
  State<Page2> createState() => _Page1();
}

class _Page1 extends State<Page2> {
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

    sumStr = ((widget.product.amount! * widget.product.num!) / 100).toString();
  }

  getTokenAndChargeOmise() async {
    bool isSuscess = false;
    int amount = (widget.product.amount! * widget.product.num!);
    String currency = 'thb';
    await omise.source.create(amount, currency, "internet_banking_bay").then(
      (value) async {
        print(value.id);
        String sourceID = value.id.toString();
        String secreKey = 'skey_test_5s52k7ilttrvp6n4owa';
        String urlAPI = 'https://api.omise.co/charges';
        String basicAuth = 'Basic ${base64Encode(utf8.encode("$secreKey:"))}';

        Map<String, String> headerMap = {};
        headerMap['authorization'] = basicAuth;
        headerMap['Cache-Control'] = 'no-cache';
        headerMap['Content-Type'] = 'application/x-www-form-urlencoded';

        Map<String, dynamic> data = {};
        data['amount'] = amount.toString();
        data['currency'] = currency;
        data['source'] = sourceID;
        data['return_uri'] = 'http://example.com/orders/345678/complete';

        Uri uri = Uri.parse(urlAPI);
        http.Response reponse = await http.post(
          uri,
          headers: headerMap,
          body: data,
        );

        var result = json.decode(reponse.body);

        String authorizeURI = result['authorize_uri'];
        print('authorizeURI : $authorizeURI');

        launchUrl(Uri.parse(authorizeURI));

        print(result);
        isSuscess = true;
      },
    ).catchError((value) {
      isSuscess = false;
      print(value);
    });
    ;
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
    if (/*validate() && */ await getTokenAndChargeOmise()) {
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
        msg: 'ใช้ Bank ในการชำระเงิน',
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ยอดชำระ
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    width: size.width,
                    child: Text(
                      'ยอดชำระ : $sumStr บาท',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
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
