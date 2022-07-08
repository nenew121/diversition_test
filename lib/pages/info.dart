import 'package:flutter/material.dart';

import '../layouts/body.dart';
import '../layouts/formtext.dart';
import '../models/product.dart';
import 'inputaddress.dart';

class Info extends StatefulWidget {
  final int id;
  final List<Product> productList;

  const Info({Key? key, required this.id, required this.productList})
      : super(key: key);

  @override
  State<Info> createState() => _MainpageState();
}

class _MainpageState extends State<Info> {
  final TextEditingController _controllerNumProduct = TextEditingController();

  Product product = Product();
  bool _isDisable = false;

  @override
  void initState() {
    super.initState();
    List<Product> list =
        widget.productList.where((e) => e.productId == widget.id).toList();
    if (list.isNotEmpty) {
      product = list[0];
      _controllerNumProduct.text = product.num.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  int checkZero(int value) {
    return value = (value >= 1 ? value : 1);
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
    FocusScope.of(context).requestFocus(FocusNode());
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
    return Body(
      isShowBack: true,
      title: 'รายละเอียดสินค้า',
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Container(
              height: size.height - 200 - media.bottom,
              width: size.width,
              child: Column(
                children: [
                  // Image
                  FormText(
                    text: 'รูปสินค้า',
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
                  FormText(
                    text: 'รายละเอียด',
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
            Positioned(
              bottom: 0,
              height: h2 * 2,
              child: Column(
                children: [
                  // num
                  FormText(
                    wid: SizedBox(
                      height: h2,
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            splashRadius: 20,
                            icon: const Icon(Icons.remove),
                            onPressed: removeNum,
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
                            onPressed: addNum,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // btn
                  FormText(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
