import 'package:flutter/material.dart';

const backgroundColor = Color(0xff0e9cab);

/// Dark
const dark = Color(0xff1f1c38);

/// Error
const error = Color(0xffff6767);

/// N0
const neutral0 = Color(0xffad1c21);

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
const secondaryDark = Color(0xff6a2250);

const inactiveToggleTextColor = Color(0xffE8EAED);

const inactiveToggleBgColor = Color(0x2ffB2B2B);

const inactiveToggleActiveBgColor = Color(0xffaD5C14);
//

/// Base chat theme containing all required properties to make a theme.
/// Extend this class if you want to create a custom theme.
@immutable
abstract class JsonFormTheme {
  /// Creates a new chat theme based on provided colors and text styles.
  const JsonFormTheme(
      {required this.headerContainerPadding,
      required this.inputDecoration,
      required this.editTextHeight,
      required this.editTextStyle,
      required this.staticTextPadding,
      required this.lineMargins,
      required this.staticContainerDecoration,
      required this.titleTextStyle,
      required this.headerContainerDecoration,
      required this.headerTextStyle,
      required this.toggleMinWidth,
      required this.toggleMinHeight,
      required this.toggleFontSize,
      required this.toggleActiveColor,
      required this.toggleActiveTextColor,
      required this.toggleInactiveColor,
      required this.toggleInactiveTextColor,
      required this.dropDownIcon,
      required this.underLineWidget,
      required this.nameTextStyle,
      required this.nameContainerPadding,
      required this.nameContainerDecoration,
      required this.descriptionTextStyle,
      required this.staticTextStyle,
      required this.linePadding,
      required this.linePaDecoration,
      required this.linePaDecorationAboveHeader,
      required this.editTextCursorColor,
      required this.editTextWidth,
      required this.backgroundColor,
      required this.editTextStyleFocus,
      required this.inputDecorationReadOnly,
      required this.editTextMargins,
      required this.editTextLongMargins,
      required this.headerContainerMargins,
      required this.debounceTime,
      this.overflow = false,
      required this.dropDownWith,
      required this.keyboardTypeLong,
      required this.keyboardTypeShort,
      required this.toggleWidthOfHeader,
      required this.editTextWidthOfHeader,
      required this.dropDownWidthOfHeader,
      required this.staticTextWidthOfHeader,
      required this.staticValueWidth,
      this.mainAxisAlignmentOfName = MainAxisAlignment.start});

  /// Global container params///

  final EdgeInsets nameContainerPadding;

  final EdgeInsets linePadding;

  final EdgeInsets lineMargins;

  final BoxDecoration linePaDecoration;

  final BoxDecoration linePaDecorationAboveHeader;

  final BoxDecoration nameContainerDecoration;

  final TextStyle nameTextStyle;

  final TextStyle descriptionTextStyle;

  final Color backgroundColor;

  ///Header section//////

  //HeaderBoxPadding
  final EdgeInsets headerContainerPadding;

  final EdgeInsets headerContainerMargins;

  final BoxDecoration headerContainerDecoration;

  final TextStyle headerTextStyle;

  final TextStyle titleTextStyle;

  final MainAxisAlignment mainAxisAlignmentOfName;

  //////////////////////////////////

  ////// Toggle Section /////

  final double toggleMinWidth;
  final double toggleMinHeight;
  final double toggleFontSize;
  final Color toggleActiveColor;
  final Color toggleActiveTextColor;
  final Color toggleInactiveColor;
  final Color toggleInactiveTextColor;

  ///// Static Text ////
  final TextStyle staticTextStyle;

  final EdgeInsets staticTextPadding;

  final BoxDecoration staticContainerDecoration;

  final double staticValueWidth;

  final double toggleWidthOfHeader;

  ///////////////////////////////

  /// Edit Text ///

  final TextStyle editTextStyle;

  final TextStyle editTextStyleFocus;

  final Color editTextCursorColor;

  final double editTextHeight;

  final double editTextWidth;

  final InputDecoration inputDecoration;

  final InputDecoration inputDecorationReadOnly;

  final EdgeInsets editTextLongMargins;

  final EdgeInsets editTextMargins;

  final double editTextWidthOfHeader;

  final double staticTextWidthOfHeader;

  /////////////////

  /// DropDown Widget ////

  final Widget? dropDownIcon;

  final Widget? underLineWidget;

  final int? debounceTime;

  final TextInputType? keyboardTypeShort;

  final TextInputType? keyboardTypeLong;

  final bool overflow;

  final double dropDownWith;

  final double dropDownWidthOfHeader;
}

/// Default chat theme which extends [JsonFormTheme]
@immutable
class DefaultTheme extends JsonFormTheme {
  /// Creates a default chat theme. Use this constructor if you want to
  /// override only a couple of properties, otherwise create a new class
  /// which extends [JsonFormTheme]
  const DefaultTheme(
      {TextStyle descriptionTextStyle = const TextStyle(
        color: neutral2,
        fontFamily: 'Avenir',
        fontSize: 12,
        fontWeight: FontWeight.w800,
        height: 1.333,
      ),
      TextStyle staticTextStyle = const TextStyle(
        fontFamily: 'Avenir',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xffE8EAED),
        height: 1.5,
      ),
      TextStyle nameTextStyle = const TextStyle(
        color: neutral7,
        fontFamily: 'Avenir',
        fontSize: 16,
        fontWeight: FontWeight.w800,
        height: 1.375,
      ),
      TextStyle headerTextStyle = const TextStyle(
        fontFamily: 'Avenir',
        fontSize: 13,
        color: Color(0xffA9AAAD),
        fontWeight: FontWeight.w400,
        height: 1.6,
      ),
      TextStyle titleTextStyle = const TextStyle(
        fontFamily: 'Avenir',
        fontSize: 16,
        color: Color(0xffE8EAED),
        fontWeight: FontWeight.w400,
        height: 1.333,
      ),
      BoxDecoration headerContainerDecoration = const BoxDecoration(
          color: Color(0xff0Da20D),
          border: Border(
            top: BorderSide(width: 0.0, color: Color(0xFF8A666F)),
            left: BorderSide.none,
            right: BorderSide.none,
            bottom: BorderSide(width: 0.0, color: Color(0xFF628B8F)),
          )),
      BoxDecoration linePaDecoration = const BoxDecoration(
          border: Border(
        top: BorderSide.none,
        left: BorderSide.none,
        right: BorderSide.none,
        bottom: BorderSide(width: 0.0, color: Color(0xFF8233F)),
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
      TextStyle editTextStyle = const TextStyle(color: Color(0xffaa7420), height: 1),
      TextStyle editTextStyleFocus = const TextStyle(color: Color(0xff007420), height: 1),
      Color editTextCursorColor = const Color(0xff9E753C),
      OutlineInputBorder editTextEnabledBorder = const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Color(0xffa22839), width: 2.0)),
      InputDecoration inputDecoration = const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xffa03839), width: 2.0)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Color(0xff51753C), width: 2.0)),
      ),
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
      editTextLongMargins = const EdgeInsets.only(top: 10),
      editTextMargins = const EdgeInsets.only(),
      editTextHeight = 35.0,
      BoxDecoration staticContainerDecoration = const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border(
            top: BorderSide.none,
            left: BorderSide.none,
            right: BorderSide.none,
            bottom: BorderSide.none,
          ))})
      : super(
      staticValueWidth: 20,
            dropDownWith: 30,
            overflow: true,
            keyboardTypeLong: null,
            keyboardTypeShort: const TextInputType.numberWithOptions(decimal: true),
            editTextStyleFocus: editTextStyleFocus,
            editTextWidth: 70,
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
            headerContainerPadding: const EdgeInsets.only(left: 20, right: 10, top: 14, bottom: 8),
            headerContainerMargins: const EdgeInsets.only(left: 0),
            headerContainerDecoration: headerContainerDecoration,
            headerTextStyle: headerTextStyle,
            titleTextStyle: titleTextStyle,
            toggleMinWidth: 70,
            toggleMinHeight: 35,
            toggleFontSize: 18,
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
            inputDecorationReadOnly: inputDecorationReadOnly,
            editTextMargins: editTextMargins,
            editTextLongMargins: editTextLongMargins,
            debounceTime: null,
            toggleWidthOfHeader: 45,
            editTextWidthOfHeader: 65,
            dropDownWidthOfHeader: 55,
            staticTextWidthOfHeader: 65);
}
