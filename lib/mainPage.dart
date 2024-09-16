// import 'dart:io';

// import 'package:demo_sadad/commonwIdgets.dart';
// import 'package:demo_sadad/mainpagecontroller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PaymentScreen extends StatefulWidget {
//   Color? themeColor;
//   Color? paymentButtonColor;
//   TextStyle? paymentButtonTextStyle;
//   WalletType? walletType;
//   List<PaymentType>? paymentTypes;
//   PaymentScreen(
//       {super.key,
//       this.themeColor = const Color(0xFFA02058),
//       this.walletType = WalletType.applePay,
//       this.paymentButtonColor,
//       this.paymentButtonTextStyle,
//       this.paymentTypes = const [PaymentType.creditCard, PaymentType.debitCard, PaymentType.sadadPay]});

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   Color primaryColor = const Color(0xFFA02058);
//   MainPageController controller = Get.put(MainPageController());

//   @override
//   void initState() {
//     super.initState();
//     primaryColor = widget.themeColor!;
//     if (widget.paymentTypes!.isEmpty) {
//       widget.paymentTypes = [PaymentType.creditCard, PaymentType.debitCard, PaymentType.sadadPay];
//     } else {
//       controller.selectedPaymentMethod = widget.paymentTypes!.first;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder(
//         init: MainPageController(),
//         builder: (MainPageController controller) {
//           return Scaffold(
//               backgroundColor: const Color(0xFFFAFAFA),
//               body: SafeArea(
//                   child: SingleChildScrollView(
//                 child: Column(
//                   children: [topContainer(), middleContainer(), bottomContainer()],
//                 ),
//               )));
//         });
//   }

//   Widget middleContainer() {
//     MainPageController controller = Get.find<MainPageController>();
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         children: [
//           Row(
//             children: const [
//               Expanded(
//                 child: Divider(
//                   endIndent: 15,
//                   indent: 15,
//                   thickness: 2,
//                   height: 10,
//                   color: Color(0xFFE4E4E4),
//                 ),
//               ),
//               Text("Or Pay Using", style: TextStyle(color: Color(0xFF000000), fontSize: 12)),
//               Expanded(
//                 child: Divider(
//                   endIndent: 15,
//                   indent: 15,
//                   thickness: 2,
//                   height: 10,
//                   color: Color(0xFFE4E4E4),
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               if (widget.paymentTypes!.contains(PaymentType.creditCard))
//                 cardContainer(
//                     text: "Credit Card", type: PaymentType.creditCard, imagePath: "assets/icons/credit_card.png"),
//               if (widget.paymentTypes!.contains(PaymentType.debitCard))
//                 cardContainer(text: "Debit Card", type: PaymentType.debitCard, imagePath: "assets/icons/card_naps.png"),
//               if (widget.paymentTypes!.contains(PaymentType.sadadPay))
//                 cardContainer(text: "Sadad Pay", type: PaymentType.sadadPay, imagePath: "assets/icons/sadad_wallet.png")
//             ],
//           ),
//           const SizedBox(height: 12),
//          getSelectedPaymentMethod(selectedMethod: controller.selectedPaymentMethod)
//         ],
//       ),
//     );
//   }

//   Widget topContainer() {
//     return SizedBox(
//       height: Get.height * 0.25,
//       width: double.infinity,
//       child: Stack(children: [
//         Container(
//           height: Get.height * 0.24,
//           decoration: BoxDecoration(
//               color: primaryColor,
//               borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60))),
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Expanded(
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Icon(
//                         Icons.arrow_back_ios_new_outlined,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       Image.asset("assets/icons/sadad_icon.png", height: 30),
//                       const SizedBox(height: 5),
//                       const Text(
//                         "Sadad Payment solutions",
//                         style: TextStyle(color: Colors.white, fontSize: 12),
//                       )
//                     ],
//                   ),
//                   Expanded(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: const [
//                         Text("Eng", style: TextStyle(color: Colors.white, fontSize: 12)),
//                         Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white)
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//               Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
//                   height: 40,
//                   child: Row(mainAxisSize: MainAxisSize.min, children: const [
//                     Text(
//                       "Select an option to Pay ",
//                       style: TextStyle(color: Colors.white, fontSize: 12),
//                     ),
//                     Text("QAR 25555", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900))
//                   ])),
//               const SizedBox(height: 25)
//             ]),
//           ),
//         ),
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: widget.walletType == WalletType.applePay
//               ? Container(
//                   decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
//                   height: 55,
//                   margin: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Center(child: Image.asset("assets/icons/apple_pay.png", height: 22)),
//                 )
//               : Container(
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(5),
//                       boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, blurStyle: BlurStyle.outer)]),
//                   height: 55,
//                   margin: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Center(child: Image.asset("assets/icons/gpay.png", height: 22)),
//                 ),
//         )
//       ]),
//     );
//   }

//   Widget cardContainer({required String text, required String imagePath, required PaymentType type}) {
//     MainPageController controller = Get.find<MainPageController>();
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           controller.selectedPaymentMethod = type;
//           controller.update();
//         },
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 10),
//           clipBehavior: Clip.hardEdge,
//           foregroundDecoration: BoxDecoration(borderRadius: BorderRadius.circular(5), boxShadow: const [
//             BoxShadow(color: Color(0x0000000D), offset: Offset(0, 3), blurStyle: BlurStyle.inner, blurRadius: 5)
//           ]),
//           height: 60,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               color: Colors.white,
//               boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, blurStyle: BlurStyle.outer)]),
//           child: Stack(
//             alignment: Alignment.bottomCenter,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 8, right: 8, top: 6),
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ImageIcon(AssetImage(imagePath),
//                           size: 25, color: controller.selectedPaymentMethod == type ? primaryColor : Colors.grey),
//                       Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
//                       Container(height: 8)
//                     ]),
//               ),
//               Container(height: 8, color: controller.selectedPaymentMethod == type ? primaryColor : Colors.transparent)
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   getSelectedPaymentMethod({required PaymentType selectedMethod}) {
//     switch (selectedMethod) {
//       case PaymentType.creditCard:
//         return creditCardContainer();
//       case PaymentType.debitCard:
//         return debitCardContainer();
//       case PaymentType.sadadPay:
//         return sadadPayContainer();
//     }
//   }

//   Widget creditCardContainer() {
//     return Container(
//       margin: const EdgeInsets.all(10),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           color: Colors.white,
//           border: Border.all(color: const Color(0xFFF7F7F7)),
//           boxShadow: const [
//             BoxShadow(color: Colors.black12, offset: Offset(0, 0), blurRadius: 5, blurStyle: BlurStyle.outer)
//           ]),
//       child: Column(children: [
//         Row(
//           children: [
//             ImageIcon(const AssetImage("assets/icons/credit_card.png"), color: widget.themeColor),
//             const SizedBox(width: 8),
//             Text(
//               "Credit Card",
//               style: TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         CommonWidgets.commonUnderLineTextField(
//             labelText: "Card Holder Name",
//             prefix: const Text(
//               "+91",
//               style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
//             )),
//         CommonWidgets.commonUnderLineTextField(
//             labelText: "Card Number", suffixIcon: Image.asset("assets/icons/card_2.png", height: 19)),
//         Row(
//           children: [
//             Expanded(
//               child: CommonWidgets.commonUnderLineTextField(labelText: "Expiry / Validity"),
//             ),
//             const SizedBox(width: 15),
//             Expanded(
//               child: CommonWidgets.commonUnderLineTextField(
//                   labelText: "CVV", suffixIcon: Image.asset("assets/icons/card_1.png", height: 26)),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             SizedBox(
//                 height: 24.0,
//                 width: 24.0,
//                 child: Checkbox(
//                   value: true,
//                   onChanged: (value) {},
//                   activeColor: const Color(0xFF1E8803),
//                 )),
//             const SizedBox(width: 8),
//             Text(
//               "Remember me",
//               style: TextStyle(fontSize: 10, color: const Color(0xFF000000).withOpacity(0.5)),
//             )
//           ],
//         ),
//         const SizedBox(height: 15),
//         paymentButton(),
//         const SizedBox(height: 15),
//         Row(
//           children: [
//             Image.asset("assets/icons/lock.png", height: 12),
//             const SizedBox(width: 3),
//             const Text(
//               "Payment is Secured with 256bit SSL encryption ",
//               style: TextStyle(fontSize: 10, color: Color(0xFF757575)),
//             ),
//             Text(
//               "(You are safe)",
//               style: TextStyle(fontSize: 10, color: primaryColor),
//             )
//           ],
//         )
//       ]),
//     );
//   }

//   Widget sadadPayContainer() {
//     return Container(
//       margin: const EdgeInsets.all(10),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           color: Colors.white,
//           border: Border.all(color: const Color(0xFFF7F7F7)),
//           boxShadow: const [
//             BoxShadow(color: Colors.black12, offset: Offset(0, 0), blurRadius: 5, blurStyle: BlurStyle.outer)
//           ]),
//       child: Column(children: [
//         Row(
//           children: [
//             ImageIcon(const AssetImage("assets/icons/sadad_wallet.png"), color: widget.themeColor),
//             const SizedBox(width: 8),
//             Text(
//               "Sadad Pay",
//               style: TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         const SizedBox(height: 15),
//         CommonWidgets.commonTextField(
//             labelText: "Card Holder Name",
//             prefix: const Text(
//               "+91",
//               style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
//             )),
//         CommonWidgets.commonTextField(
//             labelText: "Card Number", suffixIcon: Icon(Icons.credit_card, color: primaryColor)),
//         const SizedBox(height: 15),
//         paymentButton(),
//         const SizedBox(height: 15),
//         Row(
//           children: [
//             Icon(Icons.security, color: primaryColor, size: 20),
//             const SizedBox(width: 3),
//             const Text(
//               "Payment is Secured with 256bit SSL encryption ",
//               "Payment is Secured with 256bit SSL encryption ",
//               style: TextStyle(fontSize: 10, color: Color(0xFF757575)),
//             ),
//             Text(
//               "(You are safe)",
//               style: TextStyle(fontSize: 10, color: primaryColor),
//             )
//           ],
//         )
//       ]),
//     );
//   }

//   Widget debitCardContainer() {
//     return Container(
//       margin: const EdgeInsets.all(10),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           color: Colors.white,
//           border: Border.all(color: const Color(0xFFF7F7F7)),
//           boxShadow: const [
//             BoxShadow(color: Colors.black12, offset: Offset(0, 0), blurRadius: 5, blurStyle: BlurStyle.outer)
//           ]),
//       child: Column(children: [
//         Row(
//           children: [
//             ImageIcon(const AssetImage("assets/icons/card_naps.png"), color: widget.themeColor),
//             const SizedBox(width: 8),
//             Text(
//               "Debit Card",
//               style: TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         const SizedBox(height: 15),
//         const Text(
//           "When you choose to complete your payment using a debit card issued in Qatar, you will be temporarily redirected to the QPay website. Once the transaction is completed, you'll be taken back to the Sadad to view your confirmation.",
//           style: TextStyle(fontFamily: "openSans", fontSize: 12, fontWeight: FontWeight.w400),
//         ),
//         const SizedBox(height: 30),
//         paymentButton(),
//         const SizedBox(height: 15),
//         Row(
//           children: [
//             Icon(Icons.security, color: primaryColor, size: 20),
//             const SizedBox(width: 3),
//             const Text(
//               "Payment is Secured with 256bit SSL encryption ",
//               style: TextStyle(fontSize: 10, color: Color(0xFF757575)),
//             ),
//             Text(
//               "(You are safe)",
//               style: TextStyle(fontSize: 10, color: primaryColor),
//             )
//           ],
//         )
//       ]),
//     );
//   }

//   bottomContainer() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Column(
//         children: [
//           Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//             securityContainer("assets/icons/mcafee.png"),
//             securityContainer("assets/icons/comodo_secure.png"),
//             securityContainer("assets/icons/symantec.png"),
//             securityContainer("assets/icons/pci_dss.png")
//           ]),
//           const SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset("assets/icons/lock.png", height: 12),
//               const SizedBox(width: 3),
//               const Text(
//                 "100% secured Payment  ",
//                 style: TextStyle(fontSize: 10, color: Color(0xFF757575)),
//               ),
//               Text(
//                 "Powered by Sadad",
//                 style: TextStyle(fontSize: 10, color: primaryColor),
//               )
//             ],
//           ),
//           const SizedBox(height: 15)
//         ],
//       ),
//     );
//   }

//   Widget securityContainer(String imagepath) {
//     return Container(
//       height: 50,
//       padding: EdgeInsets.all(5),
//       decoration: BoxDecoration(color: Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(5)),
//       child: Image.asset(
//         imagepath,
//         width: Get.width * 0.20,
//       ),
//     );
//   }

//   Widget paymentButton() {
//     return Container(
//       decoration: BoxDecoration(
//           color: widget.paymentButtonColor ?? primaryColor,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: const Color(0xFFDADCE0))),
//       height: 50,
//       child: Center(
//           child: Text(
//         "Pay QAR 950",
//         style: widget.paymentButtonTextStyle ??
//             const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
//       )),
//     );
//   }
// }

// enum WalletType { applePay, googlePay }

// enum PaymentType { creditCard, debitCard, sadadPay }
