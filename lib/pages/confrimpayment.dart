import 'package:diversition_test/pages/list.dart';
import 'package:flutter/material.dart';
import '../layouts/body.dart';
import '../layouts/formtext.dart';
import '../models/product.dart';

class ConfrimPayment extends StatefulWidget {
  final Product product;

  const ConfrimPayment({super.key, required this.product});

  @override
  State<ConfrimPayment> createState() => _ConfrimPaymentState();
}

class _ConfrimPaymentState extends State<ConfrimPayment> {
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

  confrim() {
    debugPrint('Confrim');
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: ((context) => const ListInfo())),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets media = MediaQuery.of(context).viewPadding;

    return Body(
      title: 'ชำระเงิน',
      body: Stack(
        children: [
          SizedBox(
            height: size.height - 150 - media.bottom,
            width: size.width,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      size: 150,
                      color: Colors.green,
                    ),
                    Text(
                      'เสร็จสิ้นรายการ',
                      style: TextStyle(fontSize: 28, color: Colors.green),
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
                  onPressed: () => confrim(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
