// import 'package:flutter/material.dart';

// class CommonWidgets {
//   static Color primaryColor = const Color(0xFFA02058);
//   static Widget commonUnderLineTextField({required String labelText, Widget? prefix, Widget? suffixIcon}) {
//     return TextFormField(
//         cursorColor: primaryColor,
//         style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
//         decoration: InputDecoration(
//             helperText: "",
//             contentPadding: const EdgeInsets.only(bottom: 3),
//             prefix: prefix,
//             suffixIcon: suffixIcon ?? SizedBox(),
//             suffixIconConstraints: BoxConstraints.tightFor(),
//             alignLabelWithHint: true,
//             labelStyle: TextStyle(
//               color: const Color(0xFF000000).withOpacity(0.5),
//             ),
//             labelText: labelText,
//             border: UnderlineInputBorder(
//                 borderSide: BorderSide(color: const Color(0xFF000000).withOpacity(0.3), width: 1.5)),
//             errorBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(color: const Color(0xFF000000).withOpacity(0.3), width: 1.5)),
//             enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(color: const Color(0xFF000000).withOpacity(0.3), width: 1.5)),
//             focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 1.5)),
//             disabledBorder:
//                 UnderlineInputBorder(borderSide: BorderSide(color: const Color(0xFF000000).withOpacity(0.3)))));
//   }

//   static Widget commonTextField({required String labelText, Widget? prefix, Widget? suffixIcon}) {
//     return TextFormField(
//         cursorColor: primaryColor,
//         style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
//         decoration: InputDecoration(
//             helperText: "",
//             contentPadding: const EdgeInsets.only(left: 12),
//             suffixIconConstraints: BoxConstraints.tightFor(),
//             alignLabelWithHint: true,
//             labelStyle: TextStyle(
//               color: const Color(0xFF000000).withOpacity(0.5),
//             ),
//             labelText: labelText,
//             border: OutlineInputBorder(
//                 borderSide: BorderSide(color: const Color(0xFFDDDDDD).withOpacity(0.3), width: 1.5),
//                 borderRadius: BorderRadius.circular(10)),
//             errorBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: const Color(0xFFDDDDDD).withOpacity(0.3), width: 1.5),
//                 borderRadius: BorderRadius.circular(10)),
//             enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: const Color(0xFFDDDDDD).withOpacity(0.3), width: 1.5),
//                 borderRadius: BorderRadius.circular(10)),
//             focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: primaryColor, width: 1.5), borderRadius: BorderRadius.circular(10)),
//             disabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: const Color(0xFFDDDDDD).withOpacity(0.3)),
//                 borderRadius: BorderRadius.circular(10))));
//   }
// }
