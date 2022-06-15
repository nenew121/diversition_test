import 'package:diversition_test/compoment/bodypage.dart';
import 'package:diversition_test/pages/selectpayment.dart';
import 'package:flutter/material.dart';
import 'package:diversition_test/models/product.dart';

import '../compoment/compo.dart';

class InputAddress extends StatefulWidget {
  final Product product;
  const InputAddress({Key? key, required this.product}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputAddress();
}

class _InputAddress extends State<InputAddress> {
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerProvince = TextEditingController();
  final TextEditingController _controllerCity = TextEditingController();
  final TextEditingController _controllerDistrict = TextEditingController();
  final TextEditingController _controllerCode = TextEditingController();
  final TextEditingController _controllerFullName = TextEditingController();
  final TextEditingController _controllerNumPhone = TextEditingController();

  bool _isDisable = false;
  bool isvaliAddress = false;
  bool isvaliProvince = false;
  bool isvaliCity = false;
  bool isvaliDistrict = false;
  bool isvaliCode = false;
  bool isvaliFullName = false;
  bool isvaliNumPhone = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  backPage() {
    Navigator.pop(context);
  }

  confrim() async {
    _isDisable = true;
    setState(() {});
    // if (validate()) {
    widget.product.city = _controllerCity.text;
    widget.product.postalCode = _controllerCode.text;
    widget.product.phoneNumber = _controllerNumPhone.text;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => SelectPayment(product: widget.product)),
      ),
    );
    // }
    _isDisable = false;
    setState(() {});
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

  validate() {
    isvaliAddress = _controllerAddress.text == '' ? true : false;
    isvaliProvince = _controllerProvince.text == '' ? true : false;
    isvaliCity = _controllerCity.text == '' ? true : false;
    isvaliDistrict = _controllerDistrict.text == '' ? true : false;
    isvaliCode = _controllerCode.text == '' ? true : false;
    isvaliFullName = _controllerFullName.text == '' ? true : false;
    isvaliNumPhone = _controllerNumPhone.text == '' ? true : false;
    return !(isvaliAddress ||
        isvaliProvince ||
        isvaliCity ||
        isvaliDistrict ||
        isvaliCode ||
        isvaliFullName ||
        isvaliNumPhone);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets media = MediaQuery.of(context).viewPadding;

    return Body().page(
      title: 'กรอกรายละเอียดการจัดส่ง',
      context: context,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            SizedBox(
              height: size.height - 150 - media.bottom,
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // text ที่อยู่
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                      width: size.width,
                      child: const Text(
                        'ที่อยู่',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // รายละเอียดที่อยู่
                    formInput(
                      controller: _controllerAddress,
                      text: 'รายละเอียดที่อยู่',
                      isVali: isvaliAddress,
                    ),
                    // จังหวัด
                    formInput(
                      controller: _controllerProvince,
                      text: 'จังหวัด',
                      isVali: isvaliProvince,
                    ),
                    // เขต/อำเภอ
                    formInput(
                      controller: _controllerCity,
                      text: 'เขต/อำเภอ',
                      isVali: isvaliCity,
                    ),
                    // ตำบล
                    formInput(
                      controller: _controllerDistrict,
                      text: 'ตำบล',
                      isVali: isvaliDistrict,
                    ),
                    // รหัสไปรษณีย์
                    formInput(
                      controller: _controllerCode,
                      text: 'รหัสไปรษณีย์',
                      type: TextInputType.number,
                      isVali: isvaliCode,
                    ),
                    // text ช่องทางติดต่อ
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                      width: size.width,
                      child: const Text(
                        'ช่องทางติดต่อ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // ชื่อ - นามสกุล
                    formInput(
                      controller: _controllerFullName,
                      text: 'ชื่อ - นามสกุล',
                      isVali: isvaliFullName,
                    ),
                    // หมายเลขโทรศัพท์
                    formInput(
                      controller: _controllerNumPhone,
                      text: 'หมายเลขโทรศัพท์',
                      type: TextInputType.number,
                      isVali: isvaliNumPhone,
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
                    onPressed: () => _isDisable ? null : confrim(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
