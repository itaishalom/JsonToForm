import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/themes/json_form_theme.dart';

const backgroundColor = Color(0xff1A1A1A);
const orangeTheme = Color(0xffFE753C);
const textColorHeader = Color(0xffE8EAED);
const Color darkGrey = Color(0xFFA9AAAD);


/// Dark
const dark = Color(0xff1f1c38);

/// Error
const error = Color(0xffff6767);

/// N0
const neutral0 = Color(0xff1d1c21);

/// N2
const neutral2 = Color(0xff9e9cab);

/// N7
const neutral7 = Color(0xffffffff);

/// N7 with opacity
const neutral7WithOpacity = Color(0x80ffffff);

/// Primary
const primary = Color(0xff6f61e8);

/// Secondary
const secondary = Color(0xfff5f5f7);

/// Secondary dark
const secondaryDark = Color(0xff2b2250);

const inactiveToggleTextColor = textColorHeader;

const inactiveToggleBgColor = Color(0xff2B2B2B);

const inactiveToggleActiveBgColor = Color(0xff8F4220);

const clinicalTemplateDateColor = Color(0xff6A8A9A);

@immutable
class AidocTheme extends JsonFormTheme {
  /// Creates a default chat theme. Use this constructor if you want to
  /// override only a couple of properties, otherwise create a new class
  /// which extends [JsonFormTheme]
  ///
  final double editTextWidthValue;
  final bool setOverflow;
  final MainAxisAlignment mainAxisAlignment;
  final double editTextWidthOfHeaderValue;
  final double staticTextWidthOfHeaderValue;
  final double staticValueWidthValue;
  final BoxDecoration headerContainerDecoration;
  final EdgeInsets headerContainerPadding;
  final TextStyle titleTextStyle;

  const AidocTheme(
      {this.titleTextStyle = const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        color: textColorHeader,
        fontWeight: FontWeight.w400,
        height: 1.333,
      ),
        this.mainAxisAlignment = MainAxisAlignment.start,
        this.editTextWidthValue = 75,
        this.staticValueWidthValue = 30,
        this.staticTextWidthOfHeaderValue = 65,
        this.editTextWidthOfHeaderValue = 65,
        this.setOverflow = true,
        this.headerContainerDecoration = const BoxDecoration(
            color: Color(0xff0D0D0D),
            border: Border(
              top: BorderSide(width: 0.0, color: Color(0xFF303030)),
              left: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide(width: 0.0, color: Color(0xFF303030)),
            )),
        this.headerContainerPadding = const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 6),
        TextStyle descriptionTextStyle = const TextStyle(
          color: neutral2,
          fontFamily: 'Roboto',
          fontSize: 12,
          fontWeight: FontWeight.w800,
          height: 1.333,
        ),
        TextStyle staticTextStyle = const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColorHeader,
          height: 1.5,
        ),
        TextStyle nameTextStyle = const TextStyle(
          color: neutral7,
          fontFamily: 'Roboto',
          fontSize: 16,
          fontWeight: FontWeight.w800,
          height: 1.375,
        ),
        TextStyle headerTextStyle = const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 13,
          color: darkGrey,
          fontWeight: FontWeight.w400,
          height: 1.6,
        ),
        BoxDecoration linePaDecoration = const BoxDecoration(
            border: Border(
              top: BorderSide.none,
              left: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide(width: 0.0, color: Color(0xFF303030)),
            )),
        BoxDecoration linePaDecorationAboveHeader = const BoxDecoration(
            border: Border(
              top: BorderSide.none,
              left: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide.none,
            )),
        BoxDecoration nameContainerDecoration = const BoxDecoration(
          color: Colors.transparent,
        ),
        EdgeInsets lineMargins = const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
        EdgeInsets staticTextPadding = const EdgeInsets.fromLTRB(20, 10, 5, 10),
        TextStyle editTextStyle = const TextStyle(color: textColorHeader, height: 1, fontSize: 16),
        Color editTextCursorColor = orangeTheme,
        OutlineInputBorder editTextEnabledBorder = const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xff383839), width: 2.0)),
        InputDecoration inputDecoration = const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Color(0xff383839), width: 2.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: orangeTheme, width: 2.0)),
        ),
        editTextHeight = 35.0,
        TextStyle editTextStyleFocus = const TextStyle(color: Colors.white, height: 1),
        editTextLongMargins = const EdgeInsets.only(top: 10),
        editTextMargins = const EdgeInsets.only(),
        InputDecoration inputDecorationReadOnly = const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
        ),
        BoxDecoration staticContainerDecoration = const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border(
              top: BorderSide.none,
              left: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide.none,
            ))})
      : super(
      itemMinHeight: 9 ,
      mainAxisAlignmentOfName: mainAxisAlignment,
      dropDownWith: 39.5,
      overflow: setOverflow,
      keyboardTypeShort: const TextInputType.numberWithOptions(decimal: true),
      keyboardTypeLong:  TextInputType.multiline,
      inputDecorationReadOnly: inputDecorationReadOnly,
      editTextLongMargins: editTextLongMargins,
      editTextMargins: editTextMargins,
      editTextStyleFocus: editTextStyleFocus,
      editTextWidth: editTextWidthValue,
      staticContainerDecoration: staticContainerDecoration,
      editTextHeight: editTextHeight,
      inputDecoration: inputDecoration,
      editTextCursorColor: editTextCursorColor,
      editTextStyle: editTextStyle,
      staticTextPadding: staticTextPadding,
      lineMargins: lineMargins,
      linePaDecoration: linePaDecoration,
      linePadding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      backgroundColor: backgroundColor,
      headerContainerPadding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 6),
      headerContainerMargins: const EdgeInsets.only(left: 0),
      headerContainerDecoration: headerContainerDecoration,
      headerTextStyle: headerTextStyle,
      titleTextStyle: titleTextStyle,
      toggleMinWidth: 75,
      toggleMinHeight: 35,
      toggleFontSize: 14,
      toggleActiveColor: inactiveToggleActiveBgColor,
      toggleActiveTextColor: inactiveToggleTextColor,
      toggleInactiveColor: inactiveToggleBgColor,
      toggleInactiveTextColor: inactiveToggleTextColor,
      dropDownIcon: null,
      underLineWidget: null,
      nameTextStyle: nameTextStyle,
      nameContainerPadding: const EdgeInsets.all(0),
      nameContainerDecoration: nameContainerDecoration,
      descriptionTextStyle: descriptionTextStyle,
      staticTextStyle: staticTextStyle,
      linePaDecorationAboveHeader: linePaDecorationAboveHeader,
      debounceTime: 500,
      toggleWidthOfHeader: 45,
      editTextWidthOfHeader: editTextWidthOfHeaderValue,
      dropDownWidthOfHeader: 55,
      staticTextWidthOfHeader: staticTextWidthOfHeaderValue,
      staticValueWidth: staticValueWidthValue,
      activeToggleBorder: const Border(
        top: BorderSide(width: 1.0, color: Color(0xFFFD5C14)),
        left: BorderSide(width: 1.0, color: Color(0xFFFD5C14)),
        right: BorderSide(width: 1.0, color: Color(0xFFFD5C14)),
        bottom: BorderSide(width: 1.0, color: Color(0xFFFD5C14)),
      ));
}
