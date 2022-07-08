import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:omise_flutter/omise_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../layouts/formtext.dart';
import '../models/product.dart';

import 'package:http/http.dart' as http;

import '../resources/resources.dart';

class Page2 extends StatefulWidget {
  final Product product;
  final Function onLoad;
  final Function nevPage;
  final Function dialogFail;

  const Page2(
      {Key? key,
      required this.product,
      required this.onLoad,
      required this.nevPage,
      required this.dialogFail})
      : super(key: key);

  @override
  State<Page2> createState() => _Page1();
}

class _Page1 extends State<Page2> {
  String sumStr = '0';

  /// Get your public key on Omise Dashboard
  static const publicKey = "pkey_test_5s52k7h4ybker66gcxi";
  OmiseFlutter omise = OmiseFlutter(publicKey);

  @override
  void initState() {
    super.initState();

    sumStr = ((widget.product.amount! * widget.product.num!)).toString();
  }

  getTokenAndChargeOmise() async {
    bool isSuscess = false;
    int amount = (widget.product.amount! * widget.product.num!);
    String currency = 'thb';
    await omise.source.create(amount, currency, "internet_banking_bay").then(
      (value) async {
        print(value.id);
        String sourceID = value.id.toString();
        Map<String, dynamic> data = {};
        data['amount'] = amount.toString();
        data['currency'] = currency;
        data['source'] = sourceID;
        data['return_uri'] = 'https://www.google.com/';

        http.Response reponse = await Resources().postCharges(data);

        var result = json.decode(reponse.body);

        String authorizeURI = result['authorize_uri'];
        print('authorizeURI : $authorizeURI');

        launchUrl(Uri.parse(authorizeURI),
            mode: LaunchMode.externalApplication);

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
      ],
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
                        fontSize: 24,
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
          height: 50,
          child: FormText(
            wid: Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              width: size.width,
              child: ElevatedButton(
                child: const Text('ยืนยัน'),
                onPressed: () => dialogConfrim(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
