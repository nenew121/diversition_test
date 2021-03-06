import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import '../layouts/body.dart';
import '../layouts/loading.dart';
import '../models/product.dart';
import 'confrimpayment.dart';
import 'tab1.dart';
import 'tab2.dart';

class SelectPayment extends StatefulWidget {
  final Product product;

  const SelectPayment({super.key, required this.product});

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    onLoad(false);
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
      (route) => false,
    );
  }

  Widget body() {
    return Body(
      isShowBack: true,
      title: 'เลือกวิธีชำระเงิน',
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(text: 'Credit'),
                    Tab(text: 'Bank'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
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
                  ],
                ),
              ),
            ],
          ),
        ),
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
