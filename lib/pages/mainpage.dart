import 'package:diversition_test/compoment/bodypage.dart';
import 'package:diversition_test/compoment/compo.dart';
import 'package:diversition_test/models/product.dart';
import 'package:diversition_test/pages/inputaddress.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  final TextEditingController _controllerNumProduct = TextEditingController();

  Product product = Product();
  bool _isDisable = false;

  @override
  void initState() {
    super.initState();
    _controllerNumProduct.text = '1';

    product.productId = 1;
    product.amount = 5000;
    product.num = 1;
    product.image = '';
    product.detail = 'รายละเอียดสินค้าทดสอบ ราคา 50 บาท';
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkZero(int value) {
    return value = (value >= 0 ? value : 0);
  }

  addNum() {
    _controllerNumProduct.text =
        (int.parse(_controllerNumProduct.text) + 1).toString();
    setState(() {});
  }

  removeNum() {
    _controllerNumProduct.text =
        checkZero(int.parse(_controllerNumProduct.text) - 1).toString();
    setState(() {});
  }

  clickBuy() async {
    _isDisable = true;
    product.productId = 1;
    product.num = int.parse(_controllerNumProduct.text);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => InputAddress(product: product)),
      ),
    );
    _isDisable = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets media = MediaQuery.of(context).viewPadding;
    double h1 = 300;
    double h2 = 50;

    return Body().page(
      title: 'รายละเอียดสินค้า',
      context: context,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            SizedBox(
              height: size.height - 200 - media.bottom,
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Image
                    Compo().test(
                      text: 'รูปสินค้า',
                      context: context,
                      wid: Container(
                        height: h1,
                        width: size.width,
                        color: Colors.white,
                        child: Image.asset(
                          'assets/image.png',
                        ),
                      ),
                    ),
                    // Detail
                    Compo().test(
                      text: 'รายละเอียด',
                      context: context,
                      wid: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(15),
                        width: size.width,
                        child: Text(
                          product.detail!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                height: h2 * 2,
                child: Column(
                  children: [
                    // num
                    Compo().test(
                      context: context,
                      wid: SizedBox(
                        height: h2,
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              splashRadius: 20,
                              icon: const Icon(Icons.remove),
                              onPressed: () => removeNum(),
                            ),
                            Container(
                              width: 90,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: TextField(
                                controller: _controllerNumProduct,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(),
                                onChanged: (text) => setState(() {
                                  _controllerNumProduct.text =
                                      checkZero(int.parse(text)).toString();
                                }),
                              ),
                            ),
                            IconButton(
                              splashRadius: 20,
                              icon: const Icon(Icons.add),
                              onPressed: () => addNum(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // btn
                    Compo().test(
                      context: context,
                      wid: Container(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        width: size.width,
                        child: ElevatedButton(
                          child: const Text('ซื้อ'),
                          onPressed: () => _isDisable ? null : clickBuy(),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
