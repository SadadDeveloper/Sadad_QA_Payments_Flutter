import 'dart:convert';

import 'package:demo_sadad/sucess.dart';
import 'package:flutter/material.dart';
import 'package:sadad_qa_payments/sadad_qa_payments.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

List<ProductDetail> productList = [
  ProductDetail(
      name: "Mobile Phgfgone",
      price: 10.45,
      imageUrl:
          "https://images.pexels.com/photos/1092644/pexels-photo-1092644.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      quantity: 0),
  ProductDetail(
      name: "Headphone",
      price: 5.3,
      imageUrl:
          "https://images.pexels.com/photos/1649771/pexels-photo-1649771.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      quantity: 0),
  ProductDetail(
      name: "Cars",
      price: 18.56456,
      imageUrl: "https://images.pexels.com/photos/1545743/pexels-photo-1545743.jpeg?auto=compress&cs=tinysrgb&w=800",
      quantity: 0),
  ProductDetail(
      name: "Bike",
      price: 10,
      imageUrl: "https://images.pexels.com/photos/2393835/pexels-photo-2393835.jpeg?auto=compress&cs=tinysrgb&w=800",
      quantity: 0),
  ProductDetail(
      name: "Cycle",
      price: 5,
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

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SadadLoginPage());
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
  bool _isSwitchOn = false;
  bool _isServerSwitchOn = false;

  String env = "Live";
  String server = "Preprod";

  Map<String, dynamic>? receivedData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    receivedData =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  }

  void _toggleSwitch(bool value) {
    setState(() {
      _isSwitchOn = value;
      env = _isSwitchOn ? "Sandbox" : "Live";
    });
  }

  void _servertoggleSwitch(bool value) {
    setState(() {
      _isServerSwitchOn = value;
      server = _isSwitchOn ? "Preprod" : "Production";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sadad Internal",
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: isApiCalling
          ? const SizedBox()
          : InkWell(
              onTap: () async {
                String? token = await GenerateToken();
                if (token != null) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return PaymentScreen(
                        orderId: "fdsgcfmgjd43424342g",
                        productDetail: [
                          {"test": "jhjkkk", "test2": "dfdsf"}
                        ],
                        customerName: "Sadad Internal",
                        amount: total(),
                        email: receivedData!["email"],
                        mobile: receivedData!["mobile"],
                        token: token,
                        packageMode: _isSwitchOn ? PackageMode.debug : PackageMode.release,
                        isWalletEnabled: true,
                        paymentTypes: [PaymentType.creditCard, PaymentType.debitCard, PaymentType.sadadPay],
                        image: Image.asset("assets/sadad-logo.png"),
                        titleText: "Sadad Demo",
                        paymentButtonColor: Colors.black,
                        paymentButtonTextColor: Colors.white,
                        themeColor: Colors.green,
                        googleMerchantID: 'BCR2DN6TR6Y7Z2CJ',
                        googleMerchantName: 'Sadad Payment Solutions');
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
                      Column(
                        children: [
                          /// Environment Switch
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.grey.shade50,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Environment",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _isSwitchOn ? "Sandbox" : "Live",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Transform.scale(
                                  scale: 0.9,
                                  child: Switch(
                                    activeColor: Colors.green,
                                    value: _isSwitchOn,
                                    onChanged: _toggleSwitch,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /// Server Switch
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.grey.shade50,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Server",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _isServerSwitchOn ? "Pre-Production" : "Production",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Transform.scale(
                                  scale: 0.9,
                                  child: Switch(
                                    activeColor: Colors.green,
                                    value: _isServerSwitchOn,
                                    onChanged: _servertoggleSwitch,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: productList.length,
                            itemBuilder: (context, index) => _ProductTile(
                              isAddToCart: false,
                              productDetail: productList[index],
                              onRemove: () {
                                setState(() {
                                  if (productList[index].quantity > 0) {
                                    productList[index].quantity =
                                    --productList[index].quantity;
                                  }
                                });
                              },
                              onAdd: () {
                                setState(() {
                                  productList[index].quantity =
                                  ++productList[index].quantity;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: ListView(
                            children: [
                              Center(
                                child: Text(response.toString() == "" ? "Transaction Response will Come here." : response.toString()),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
      ),
    );
  }


  Future<String?> GenerateToken() async {
    response = "Transaction Response will Come here.";
    setState(() {

    });
    //String? token = await LoginAPI();
    final  url = Uri.parse(
      _isServerSwitchOn ? 'https://aks-api.sadadqatar.com/api-v5/userbusinesses/getsdktoken' : 'https://api.sadadqatar.com/api-v5/userbusinesses/getsdktoken',//Prod
    );
    final body = json.encode({
      "sadadId": receivedData!["sadadId"],

      "secretKey": _isSwitchOn
          ? receivedData!["sandboxsecretKey"]
          : receivedData!["livesecretKey"],

      "domain": _isSwitchOn
          ? receivedData!["sandboxdomain"]
          : receivedData!["livedomain"],

      "isTest": _isSwitchOn ? 1 : 0,
    });
    Map<String, String> header = {'Content-Type': 'application/json'};
    var result = await http.post(
        url,
        headers: header, body: body
    );
    print(result.body);
    if (result.statusCode == 200) {
      var token = jsonDecode(result.body);
      setState(() {
        isApiCalling = false;
      });
      return token['accessToken'];
    } else {
      response = "Invalid credentials !";
      setState(() {
        isApiCalling = false;
      });
    }
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
  final bool isAddToCart;

  const _ProductTile({
    super.key,
    required this.productDetail,
    required this.onAdd,
    required this.onRemove,
    required this.isAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListTile(
      leading: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  SuccessView()));
        },
        child: Image.network(
          productDetail.imageUrl,
          width: size.width * .25,
          height: size.width * .25,
          fit: BoxFit.cover,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(productDetail.name),
          Text("Price : ${productDetail.price}"),
        ],
      ),
      trailing: !isAddToCart ? Row(mainAxisSize: MainAxisSize.min, children: [
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
      ]) : Container(
        height: 50,
        width: 80,
        child: Center(
            child: Text(
              "Add to cart",
              style: TextStyle(color: Colors.white),
            )),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
      ),
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

// class AddToCart extends StatefulWidget {
//   const AddToCart({super.key});
//
//   @override
//   State<AddToCart> createState() => _AddToCartState();
// }
//
// class _AddToCartState extends State<AddToCart> {
//
//   Map<String, dynamic>? receivedData;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//
//     receivedData =
//     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//   }
//
//   bool isApiCalling = false;
//   String response = "";
//   bool _isSwitchOn = false;
//   String env = "production";
//
//   Future<String?> getAccessToken() async {
//     setState(() {
//       isApiCalling = true;
//     });
//     final url = Uri.parse(
//       //'https://sadad.de/sadadSDKTestConfig/index.php',// Dev Server Live Mode
//       //'https://sadad.de/sadadSDKTestConfig/sandbox_index.php', //Dev Server Sandbox mode
//       'https://sadad.de/sadadSDKTestConfig/index2.php', //Preprod Live Mode
//       //'https://sadad.de/sadadSDKTestConfig/preprod_sandbox_index2.php',//Preprod Sandbox mode
//       //'https://sadad.de/sadadSDKLiveConfig/sadadSDKLiveConfig/index.php',//Production Server Live
//       //'https://sadad.de/sadadSDKLiveConfig/sadadSDKLiveConfig/sandbox_index.php',
//     );
//     //https://sadad.de/sadadSDKTestConfig/index2.php//Preprod Token
//     //https://sadad.de/sadadSDKTestConfig/index.php//dev
//     //'https://sadadpay.com/sdk_access_token_dev.php'
//     Map<String, String> header = {'Content-Type': 'application/json'};
//     var result = await http.post(
//       url,
//       headers: header,
//     );
//     print(result.body);
//     if (result.statusCode == 200) {
//       var token = jsonDecode(result.body);
//       setState(() {
//         isApiCalling = false;
//       });
//       return token['accessToken'];
//     }
//     setState(() {
//       isApiCalling = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Products",
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       bottomNavigationBar: isApiCalling
//           ? const SizedBox()
//           : InkWell(
//         onTap: () async {
//          Navigator.push(context, MaterialPageRoute(builder: (context) =>  const HomePage()));
//         },
//         child: Container(
//           height: 50,
//           child: Center(
//               child: Text(
//                 "Go To Cart",
//                 style: TextStyle(color: Colors.white),
//               )),
//           margin: EdgeInsets.all(10),
//           decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//       body: SafeArea(
//         child: isApiCalling
//             ? const CircularProgressIndicator()
//             : ListView.builder(
//               padding: EdgeInsets.zero,
//                                     shrinkWrap: false,
//                                     physics: const AlwaysScrollableScrollPhysics(),
//                                     itemCount: productList.length,
//                                     itemBuilder: (context, index) => _ProductTile(
//             isAddToCart: true,
//             productDetail: productList[index],
//             onRemove: () {
//               setState(() {
//                 if (productList[index].quantity > 0) {
//                   productList[index].quantity = --productList[index].quantity;
//                 }
//               });
//             },
//             onAdd: () {
//               setState(() {
//                 productList[index].quantity = ++productList[index].quantity;
//               });
//             },
//                                     ),
//                                   ),
//       ),
//     );
//   }
// }



class SadadLoginPage extends StatefulWidget {
  const SadadLoginPage({Key? key}) : super(key: key);

  @override
  State<SadadLoginPage> createState() => _SadadLoginPageState();
}

class _SadadLoginPageState extends State<SadadLoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController sadadIdController = TextEditingController();
  final TextEditingController sandBoxsecretKeyController = TextEditingController();
  final TextEditingController sandBoxdomainController = TextEditingController();
  final TextEditingController livesecretKeyController = TextEditingController();
  final TextEditingController livedomainController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();

  String environment = "Sandbox";

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  /// Load saved values
  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    sadadIdController.text = prefs.getString("sadadId") ?? "";
    sandBoxsecretKeyController.text = prefs.getString("sandboxsecretKey") ?? "";
    sandBoxdomainController.text = prefs.getString("sandboxdomain") ?? "";
    livesecretKeyController.text = prefs.getString("livesecretKey") ?? "";
    livedomainController.text = prefs.getString("livedomain") ?? "";
    emailController.text = prefs.getString("email") ?? "";
    mobileNoController.text = prefs.getString("mobile") ?? "";
  }

  /// Save values
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("sadadId", sadadIdController.text);
    await prefs.setString("sandboxsecretKey", sandBoxsecretKeyController.text);
    await prefs.setString("sandboxdomain", sandBoxdomainController.text);
    await prefs.setString("livesecretKey", livesecretKeyController.text);
    await prefs.setString("livedomain", livedomainController.text);
    await prefs.setString("email", emailController.text);
    await prefs.setString("mobile", mobileNoController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Sadad Payment Solution",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B0000),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: sadadIdController,
                decoration: const InputDecoration(
                  labelText: "Sadad ID",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter Sadad ID" : null,
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter Email" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: mobileNoController,
                decoration: const InputDecoration(
                  labelText: "Mobile No.",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter Mobile No." : null,
              ),

              const SizedBox(height: 16),

              const Text(
                "Sandbox",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: sandBoxsecretKeyController,
                decoration: const InputDecoration(
                  labelText: "Secret Key",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter Secret Key" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: sandBoxdomainController,
                decoration: const InputDecoration(
                  labelText: "Domain",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter Domain" : null,
              ),

              const SizedBox(height: 16),

              const Text(
                "Live",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: livesecretKeyController,
                decoration: const InputDecoration(
                  labelText: "Secret Key",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter Secret Key" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: livedomainController,
                decoration: const InputDecoration(
                  labelText: "Domain",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter Domain" : null,
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {

                    /// Save data
                    await saveData();

                    Map<String, dynamic> data = {
                      "environment": environment,
                      "sadadId": sadadIdController.text,
                      "sandboxsecretKey": sandBoxsecretKeyController.text,
                      "sandboxdomain": sandBoxdomainController.text,
                      "livesecretKey": livesecretKeyController.text,
                      "livedomain": livedomainController.text,
                      "email": emailController.text,
                      "mobile": mobileNoController.text,
                    };

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomePage(),
                        settings: RouteSettings(arguments: data),
                      ),
                    );
                    print(data);
                  }
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}