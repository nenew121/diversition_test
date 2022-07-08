import 'package:diversition_test/pages/info.dart';
import 'package:flutter/material.dart';

import '../layouts/body.dart';
import '../models/product.dart';

class ListInfo extends StatefulWidget {
  const ListInfo({Key? key}) : super(key: key);

  @override
  State<ListInfo> createState() => _ListInfoState();
}

class _ListInfoState extends State<ListInfo> {
  Product item = Product();
  List<Product> productList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= 15; i++) {
      item = new Product();
      item.productId = i;
      item.amount = 500 + (10 * i);
      item.num = 1;
      item.detail =
          'รายละเอียดสินค้า ProductId: ${item.productId} ราคา ${(500 + (10 * i)).toString()} บาท';
      productList.add(item);
    }
  }

  nav(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => Info(
              id: id,
              productList: productList,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Body(
      isShowDrawer: true,
      isPadTop: false,
      title: 'สินค้าทั้งหมด',
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, i) {
          Product data = productList[i];
          return InkWell(
            onTap: () => nav(data.productId ?? 0),
            child: Card(
              child: ListTile(
                title: Text("ProductID: ${data.productId ?? 0}"),
                leading: CircleAvatar(
                  child: Text(
                    "${data.productId ?? 0}",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                trailing: Text("${data.amount} Baht"),
              ),
            ),
          );
        },
      ),
    );
  }
}
