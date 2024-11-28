import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CommonWidgets {
  static Color primaryColor = const Color(0xFFA02058);

  static Widget commonUnderLineTextField(
      {List<TextInputFormatter>? inputFormatters,
        TextInputAction? textInputAction,
      required String labelText,
      required bool useMobileLayout,
      bool? readOnly,
      String? hintText,
      bool? isObscure,
      TextEditingController? controller,
      Function(String)? onChanged,
      Widget? prefix,
      String? helperText = "",
      Widget? suffixIcon,
      TextInputType? keyboardType,
      String? Function(String?)? validator,
      Color? themeColor,
      FocusNode? focusNode,
      Function()? onTap,
      int? maxlength}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
          focusNode: focusNode,
          validator: validator ?? (p0) {
            return null;
          },
/*
          onSaved: (newValue) {
            print("onSaved::${newValue}");
          },
          onEditingComplete: () {
            print("Editing complete");
          },
          onTapOutside: (event) {
            print("tap outside");
          },*/
          onTap: onTap,
          controller: controller,
          readOnly: readOnly ?? false,
          maxLength: maxlength,
          keyboardType: keyboardType,
          obscureText: isObscure ?? false,
          cursorColor: themeColor ?? primaryColor,
          inputFormatters: inputFormatters,
          style: TextStyle(color: Colors.black, fontSize: useMobileLayout ? 15 : 19, fontWeight: FontWeight.w400,),
          onChanged: onChanged,
          textInputAction: textInputAction??TextInputAction.next,
          decoration: InputDecoration(
              constraints: useMobileLayout ? null : const BoxConstraints(minHeight: 52),
              helperText: helperText,
              hintText: hintText,
              counterText: "",
              contentPadding: const EdgeInsets.only(bottom: 3),

              prefix: prefix,
              suffixIcon: suffixIcon ?? const SizedBox(),
              suffixIconConstraints: const BoxConstraints.tightFor(),
              alignLabelWithHint: true,errorStyle: TextStyle( fontSize: useMobileLayout ? 10 : 15),
              labelStyle: TextStyle(
                fontSize: useMobileLayout ? 12 : 19,
                color: const Color(0xFF000000).withOpacity(0.5),
              ),
              labelText: labelText,
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFF000000).withOpacity(0.3), width: 1.5)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFF000000).withOpacity(0.3), width: 1.5)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFF000000).withOpacity(0.3), width: 1.5)),
              focusedBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: themeColor ?? primaryColor, width: 1.5)),
              disabledBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: const Color(0xFF000000).withOpacity(0.3))))),
    );
  }

  static Widget commonTextField(
      {required String labelText,
      Widget? prefix,
      TextEditingController? controller,
      Function(String)? onChanged,
      Widget? suffixIcon,
      Color? themeColor,
      bool? obscure,
      bool? readOnly}) {
    return TextFormField(
        obscureText: obscure ?? false,
        cursorColor: themeColor ?? primaryColor,
        readOnly: readOnly ?? false,
        style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
            helperText: "",
            contentPadding: const EdgeInsets.only(left: 12),
            alignLabelWithHint: true,
            labelStyle: TextStyle(
              color: const Color(0xFF000000).withOpacity(0.5),
            ),
            suffixIcon: suffixIcon ?? const SizedBox(),
            suffixIconConstraints: const BoxConstraints.tightFor(),
            labelText: labelText,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: const Color(0xFFDDDDDD).withOpacity(0.3), width: 1.5),
                borderRadius: BorderRadius.circular(10)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: const Color(0xFFDDDDDD).withOpacity(0.3), width: 1.5),
                borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: const Color(0xFFDDDDDD).withOpacity(0.3), width: 1.5),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: themeColor ?? primaryColor, width: 1.5),
                borderRadius: BorderRadius.circular(10)),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: const Color(0xFFDDDDDD).withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10))));
  }
}
