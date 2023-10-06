import 'package:flutter/material.dart';
import 'package:workout_app/utils/global_variables.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final bool thatGoodShit;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    this.thatGoodShit = false,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: bodyTextStyle,
      controller: textEditingController,
      decoration: InputDecoration(
        hintStyle: GoogleFonts.oswald(
            fontWeight: FontWeight.w600, fontSize: 20, color: textColor),
        hintText: hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(roundBoxRadius),
            borderSide: BorderSide(color: textColor, width: 1)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundBoxRadius),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundBoxRadius),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        filled: true,
        fillColor: interactColor,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
      inputFormatters: thatGoodShit
          ? [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ]
          : null,
    );
  }
}

class TextFieldInputSecondStyle extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInputSecondStyle({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UnderlineInputBorder underLineInputBorder = UnderlineInputBorder(
        borderSide: BorderSide(color: interactColor, width: 3));
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: TextField(
        style: bodyTextStyle,
        controller: textEditingController,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.oswald(
              fontWeight: FontWeight.w600, fontSize: 20, color: textColor),
          hintText: hintText,
          border: underLineInputBorder,
          focusedBorder: underLineInputBorder,
          enabledBorder: underLineInputBorder,
          contentPadding: const EdgeInsets.only(
              bottom: 0), // Adjust this value to get desired spacing.
        ),
        keyboardType: textInputType,
        obscureText: isPass,
      ),
    );
  }
}

class MultiLineTextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  const MultiLineTextFieldInput({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      expands: true,
      maxLines: null,
      textAlignVertical: TextAlignVertical.top,
      style: bodyTextStyle,
      controller: textEditingController,
      decoration: InputDecoration(
        hintStyle: GoogleFonts.oswald(
            fontWeight: FontWeight.w600, fontSize: 20, color: textColor),
        hintText: hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(roundBoxRadius),
            borderSide: BorderSide(color: textColor, width: 1)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundBoxRadius),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundBoxRadius),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        filled: true,
        fillColor: interactColor,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: TextInputType.multiline,
      obscureText: isPass,
    );
  }
}

class TextFieldInputNumbers extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  const TextFieldInputNumbers({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: bodyTextStyle,
      controller: textEditingController,
      decoration: InputDecoration(
        hintStyle: GoogleFonts.oswald(
            fontWeight: FontWeight.w600, fontSize: 20, color: textColor),
        hintText: hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(roundBoxRadius),
            borderSide: BorderSide(color: textColor, width: 1)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundBoxRadius),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(roundBoxRadius),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        filled: true,
        fillColor: interactColor,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: const TextInputType.numberWithOptions(
          decimal: true), // It's set to allow both numbers and decimal points
      obscureText: isPass,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(
            r'^\d*\.?\d{0,2}')), // Only allows non-negative numbers and a single decimal point with up to two decimal places
      ],
    );
  }
}

class TextFieldInputSecondStyleNumbers extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  const TextFieldInputSecondStyleNumbers({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UnderlineInputBorder underLineInputBorder = UnderlineInputBorder(
        borderSide: BorderSide(color: interactColor, width: 3));
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: TextField(
        textAlign: TextAlign.center,
        style: headingTextStyle,
        controller: textEditingController,
        decoration: InputDecoration(
          hintStyle: headingTextStyle,
          hintText: hintText,
          border: underLineInputBorder,
          focusedBorder: underLineInputBorder,
          enabledBorder: underLineInputBorder,
          contentPadding: const EdgeInsets.only(
              bottom: 0), // Adjust this value to get desired spacing.
        ),
        keyboardType: const TextInputType.numberWithOptions(
            decimal: true), // It's set to allow both numbers and decimal points
        obscureText: isPass,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(
              r'^\d*\.?\d{0,2}')), // Only allows non-negative numbers and a single decimal point with up to two decimal places
        ],
      ),
    );
  }
}
