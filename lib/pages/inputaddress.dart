import 'package:flutter/material.dart';

import '../layouts/body.dart';
import '../layouts/forminput.dart';
import '../layouts/formtext.dart';
import '../models/product.dart';
import 'selectpayment.dart';

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

    widget.product.address = 'ที่อยู่ทดสอบ';
    widget.product.province = 'จังหวัดทดสอบ';
    widget.product.city = 'เขต/อำเภอทดสอบ';
    widget.product.district = 'ตำบลทดสอบ';
    widget.product.postalCode = '12345';
    widget.product.fullName = 'ชื่อทดสอบ นามสกุลทดสอบ';
    widget.product.phoneNumber = '0987654321';

    _controllerAddress.text = widget.product.fullName!;
    _controllerProvince.text = widget.product.province!;
    _controllerCity.text = widget.product.city!;
    _controllerDistrict.text = widget.product.district!;
    _controllerCode.text = widget.product.postalCode!;
    _controllerFullName.text = widget.product.fullName!;
    _controllerNumPhone.text = widget.product.phoneNumber!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  confrim() async {
    FocusScope.of(context).requestFocus(FocusNode());
    _isDisable = true;
    setState(() {});
    if (validate()) {
      widget.product.address = _controllerAddress.text;
      widget.product.province = _controllerProvince.text;
      widget.product.city = _controllerCity.text;
      widget.product.district = _controllerDistrict.text;
      widget.product.postalCode = _controllerCode.text;
      widget.product.fullName = _controllerFullName.text;
      widget.product.phoneNumber = _controllerNumPhone.text;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => SelectPayment(product: widget.product)),
        ),
      );
    }
    _isDisable = false;
    setState(() {});
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

    return Body(
      isShowBack: true,
      isLoading: false,
      title: 'กรอกรายละเอียดการจัดส่ง',
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            SizedBox(
              height: size.height - 150 - media.bottom,
              width: size.width,
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
                  FormInput(
                    controller: _controllerAddress,
                    text: 'รายละเอียดที่อยู่',
                    isVali: isvaliAddress,
                  ),
                  // จังหวัด
                  FormInput(
                    controller: _controllerProvince,
                    text: 'จังหวัด',
                    isVali: isvaliProvince,
                  ),
                  // เขต/อำเภอ
                  FormInput(
                    controller: _controllerCity,
                    text: 'เขต/อำเภอ',
                    isVali: isvaliCity,
                  ),
                  // ตำบล
                  FormInput(
                    controller: _controllerDistrict,
                    text: 'ตำบล',
                    isVali: isvaliDistrict,
                  ),
                  // รหัสไปรษณีย์
                  FormInput(
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
                  FormInput(
                    controller: _controllerFullName,
                    text: 'ชื่อ - นามสกุล',
                    isVali: isvaliFullName,
                  ),
                  // หมายเลขโทรศัพท์
                  FormInput(
                    controller: _controllerNumPhone,
                    text: 'หมายเลขโทรศัพท์',
                    type: TextInputType.number,
                    isVali: isvaliNumPhone,
                  ),
                ],
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
