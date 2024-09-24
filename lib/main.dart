import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sadad_payment_flutter/sadad_payment_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isApiCalling = false;
  String response = "";

  List<ProductDetail> productList = [
    ProductDetail(
        name: "Mobile Phgfgone",
        price: 150.154,
        imageUrl:
            "https://images.pexels.com/photos/1092644/pexels-photo-1092644.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        quantity: 0),
    ProductDetail(
        name: "Headphone",
        price: 200.546,
        imageUrl:
            "https://images.pexels.com/photos/1649771/pexels-photo-1649771.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        quantity: 0),
    ProductDetail(
        name: "Cars",
        price: 148,
        imageUrl: "https://images.pexels.com/photos/1545743/pexels-photo-1545743.jpeg?auto=compress&cs=tinysrgb&w=800",
        quantity: 0),
    ProductDetail(
        name: "Bike",
        price: 260,
        imageUrl: "https://images.pexels.com/photos/2393835/pexels-photo-2393835.jpeg?auto=compress&cs=tinysrgb&w=800",
        quantity: 0),
    ProductDetail(
        name: "Cycle",
        price: 987,
        imageUrl:
            "https://images.pexels.com/photos/38296/cycling-bicycle-riding-sport-38296.jpeg?auto=compress&cs=tinysrgb&w=800",
        quantity: 0),
    ProductDetail(
        name: "rishbh test",
        price: 3,
        imageUrl:
        "https://images.pexels.com/photos/38296/cycling-bicycle-riding-sport-38296.jpeg?auto=compress&cs=tinysrgb&w=800",
        quantity: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isApiCalling
          ? const SizedBox()
          : InkWell(
              onTap: () async {
                String? token = await getAccessToken();
                if (token != null) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return PaymentScreen(
                          orderId: "fdsgcfmgjd43424342g",
                          productDetail: [{"test":"jhjkkk","test2":"dfdsf"}],
                          customerName: "demo",
                          amount: 3,
                          email: "demo@gmail.com",
                          mobile: "98989898",
                          token: token,
                          packageMode: PackageMode.release,
                          isWalletEnabled: true,
                          paymentTypes: [PaymentType.creditCard,PaymentType.debitCard,PaymentType.sadadPay],
                          image: Image.asset("assets/sample-Logo.jpg"),
                          titleText: "Lorem Ipsum",
                          paymentButtonColor: Colors.black,
                          paymentButtonTextColor: Colors.white,
                          themeColor: Colors.green);
                    },
                  )).then((value) {
                    setState(() {
                      response = value.toString().replaceAll(",", "\n");
                    });
                    print("back value :: ${value}");
                  });
                }
              },
              child: Container(
                height: 50,
                child: Center(
                    child: Text(
                  "Pay : ${total()}",
                  style: TextStyle(color: Colors.white),
                )),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
              ),
            ),
      body: SafeArea(
        child: Center(
            child: isApiCalling
                ? const CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: productList.length,
                        itemBuilder: (context, index) => _ProductTile(
                          productDetail: productList[index],
                          onRemove: () {
                            setState(() {
                              if (productList[index].quantity > 0) {
                                productList[index].quantity = --productList[index].quantity;
                              }
                            });
                          },
                          onAdd: () {
                            setState(() {
                              productList[index].quantity = ++productList[index].quantity;
                            });
                          },
                        ),
                      )),
                      // ElevatedButton(
                      //     onPressed: () async {
                      //       String? token = await getAccessToken();
                      //       if (token != null) {
                      //         Navigator.push(context, MaterialPageRoute(
                      //           builder: (context) {
                      //             return PaymentScreen(
                      //                 productDetail: [],
                      //                 customerName: "demo",
                      //                 amount: 100.45,
                      //                 email: "demo@gmail.com",
                      //                 mobile: "9898989898",
                      //                 image: Image.asset("assets/meera.jpg"),
                      //                 titleText: "AL Meera Hyper Market",
                      //                 token: token,
                      //                 packageMode: PackageMode.debug,
                      //                 paymentTypes: [
                      //                   PaymentType.creditCard,
                      //                   PaymentType.wallet,
                      //                   PaymentType.debitCard,
                      //                   PaymentType.sadadPay
                      //                 ],
                      //                 paymentButtonColor: const Color(0xFF8D913C),
                      //                 paymentButtonTextColor: Colors.white,
                      //                 themeColor: const Color(0xFF8D993C));
                      //           },
                      //         )).then((value) {
                      //           setState(() {
                      //             response = value.toString().replaceAll(",", "\n");
                      //           });
                      //           print("back value :: ${value}");
                      //         });
                      //       }
                      //     },
                      //     child: const Text("Go to paymentscreen")),
                      Expanded(
                        child: ListView(
                          children: [
                            Center(child: Text(response.toString())),
                          ],
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }

  Future<String?> getAccessToken() async {
    setState(() {
      isApiCalling = true;
    });
    final url = Uri.parse(
      //'https://sadad.de/sadadSDKTestConfig/index.php',// Dev Server Live Mode
      //'https://sadad.de/sadadSDKTestConfig/sandbox_index.php', //Dev Server Sandbox mode
      'https://sadad.de/sadadSDKTestConfig/index2.php',//Preprod Live Mode
      //'https://sadad.de/sadadSDKTestConfig/preprod_sandbox_index2.php',//Preprod Sandbox mode
      //'https://sadad.de/sadadSDKLiveConfig/sadadSDKLiveConfig/index.php',//Production Server Live
      //'https://sadad.de/sadadSDKLiveConfig/sadadSDKLiveConfig/sandbox_index.php',
    );
    //https://sadad.de/sadadSDKTestConfig/index2.php//Preprod Token
    //https://sadad.de/sadadSDKTestConfig/index.php//dev
    //'https://sadadpay.com/sdk_access_token_dev.php'
    Map<String, String> header = {'Content-Type': 'application/json'};
    var result = await http.post(
      url,
      headers: header,
    );
    print(result.body);
    if (result.statusCode == 200) {
      var token = jsonDecode(result.body);
      setState(() {
        isApiCalling = false;
      });
      return token['accessToken'];
    }
    setState(() {
      isApiCalling = false;
    });
  }

  double total() {
    double total = 0;
    productList.forEach((element) {
      total = total + (element.quantity * element.price);
    });
    return total;
  }
}

class _ProductTile extends StatelessWidget {
  final ProductDetail productDetail;
  final Function() onAdd;
  final Function() onRemove;

  const _ProductTile({super.key, required this.productDetail, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListTile(
      leading: Image.network(
        productDetail.imageUrl,
        width: size.width * .25,
        height: size.width * .25,
        fit: BoxFit.cover,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(productDetail.name),
          Text("Price : ${productDetail.price}"),
        ],
      ),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        InkWell(
          onTap: onRemove,
          child: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.black,
              child: Icon(
                Icons.remove,
                color: Colors.white,
                size: 12,
              )),
        ),
        Text("   ${productDetail.quantity}   "),
        InkWell(
          onTap: onAdd,
          child: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.black,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 12,
              )),
        )
      ]),
    );
  }
}

class ProductDetail {
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  ProductDetail({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });
}
