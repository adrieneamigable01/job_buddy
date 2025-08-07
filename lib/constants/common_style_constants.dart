import 'package:flutter/material.dart';

/// Button styles (login)
BorderRadius kButtonLoginBorderRadius = BorderRadius.all(Radius.circular(15.0));

BoxDecoration kLoginEnabledButton = BoxDecoration(
  borderRadius: kButtonLoginBorderRadius,
  color: Color(0xFF273788),
);

BoxDecoration kLoginDisabledButton = BoxDecoration(
  borderRadius: kButtonLoginBorderRadius,
  color: Color(0xFF273799),
);

/// TextField styles
BorderRadius kTextFieldBorderRadius = BorderRadius.all(Radius.circular(15.0));

InputDecoration kTextFieldInputDecorationAccountReg(
        {String? labelText,
        bool isPassword = false,
        Color? borderSideErrorColor,
        Color? borderSideColor,
        Color fillColor = Colors.white10,
        double? helperFontSize,
        Widget? prefixIcon,
        Widget? suffixIcon,
        String? hintText,
        String? helperText,
        TextStyle? helperStyle}) =>
    InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      filled: true,
      fillColor: fillColor,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        borderSide: BorderSide(
          color: Color(0xffE0E0E0), // Border color
          width: 1.0, // Border width
        ),
      ),
      enabledBorder: const OutlineInputBorder(
       borderSide: BorderSide(
          color: Color(0xffE0E0E0), // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
          color: Color(0xffE0E0E0), // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            5.0,
          ),
        ),
      ),
      helperStyle: helperStyle,
      helperText: helperText == '' || helperText == null ? null : helperText,
    );


  InputDecoration kDropdownSearchDecorationAccountReg(
        {String? labelText,
        bool isPassword = false,
        Color? borderSideErrorColor,
        Color? borderSideColor,
        Color fillColor = Colors.white10,
        double? helperFontSize,
        Widget? prefixIcon,
        Widget? suffixIcon,
        String? hintText,
        String? helperText,
        TextStyle? helperStyle}) =>
    InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: labelText,
      filled: true,
      fillColor: fillColor,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
     border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        borderSide: BorderSide(
          color: Color(0xffE0E0E0), // Border color
          width: 1.0, // Border width
        ),
      ),
      enabledBorder: const OutlineInputBorder(
       borderSide: BorderSide(
          color: Color(0xffE0E0E0), // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
          color: Color(0xffE0E0E0), // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            5.0,
          ),
        ),
      ),
      helperStyle: helperStyle,
      helperText: helperText,
    );
