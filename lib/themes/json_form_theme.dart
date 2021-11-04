import 'package:flutter/material.dart';

// For internal usage only. Use values from theme itself.

/// See [JsonFormTheme.userAvatarNameColors]
const colors = [
  Color(0xffff6767),
  Color(0xff66e0da),
  Color(0xfff5a2d9),
  Color(0xfff0c722),
  Color(0xff6a85e5),
  Color(0xfffd9a6f),
  Color(0xff92db6e),
  Color(0xff73b8e5),
  Color(0xfffd7590),
  Color(0xffc78ae5),
];

const backgroundColor = Color(0xff1A1A1A);

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

const inactiveToggleTextColor = Color(0xffE8EAED);

const inactiveToggleBgColor = Color(0xff2B2B2B);

const inactiveToggleActiveBgColor = Color(0xffFD5C14);
//

/// Base chat theme containing all required properties to make a theme.
/// Extend this class if you want to create a custom theme.
@immutable
abstract class JsonFormTheme {
  /// Creates a new chat theme based on provided colors and text styles.
  const JsonFormTheme(
      {required this.headerContainerPadding,
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
      required this.backgroundColor});

  /// Global container params///

  final EdgeInsets nameContainerPadding;

  final EdgeInsets linePadding;

  final BoxDecoration linePaDecoration;


  final BoxDecoration linePaDecorationAboveHeader;

  final BoxDecoration nameContainerDecoration;

  final TextStyle nameTextStyle;

  final TextStyle descriptionTextStyle;

  final Color backgroundColor;

  ///Header section//////

  //HeaderBoxPadding
  final EdgeInsets headerContainerPadding;

  final BoxDecoration headerContainerDecoration;

  final TextStyle headerTextStyle;

  final TextStyle titleTextStyle;

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

  ///////////////////////////////

  /// DropDown Widget ////

  final Widget? dropDownIcon;

  final Widget? underLineWidget;
}

/// Default chat theme which extends [JsonFormTheme]
@immutable
class DefaultTheme extends JsonFormTheme {
  /// Creates a default chat theme. Use this constructor if you want to
  /// override only a couple of properties, otherwise create a new class
  /// which extends [JsonFormTheme]
  const DefaultTheme({
    Widget? attachmentButtonIcon,
    TextStyle descriptionTextStyle = const TextStyle(
      color: neutral2,
      fontFamily: 'Avenir',
      fontSize: 12,
      fontWeight: FontWeight.w800,
      height: 1.333,
    ),
    Widget? deliveredIcon,
    Widget? documentIcon,
    TextStyle emptyChatPlaceholderTextStyle = const TextStyle(
      color: neutral2,
      fontFamily: 'Avenir',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    Color errorColor = error,
    Widget? errorIcon,
    Color inputBackgroundColor = neutral0,
    BorderRadius inputBorderRadius = const BorderRadius.vertical(
      top: Radius.circular(20),
    ),
    EdgeInsetsGeometry inputPadding = EdgeInsets.zero,
    Color inputTextColor = neutral7,
    Color? inputTextCursorColor,
    InputDecoration inputTextDecoration = const InputDecoration(
      border: InputBorder.none,
      contentPadding: EdgeInsets.zero,
      isCollapsed: true,
    ),
    TextStyle staticTextStyle = const TextStyle(
      fontFamily: 'Avenir',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xffE8EAED),
      height: 1.5,
    ),
    double messageBorderRadius = 20,
    double messageInsetsHorizontal = 20,
    double messageInsetsVertical = 16,
    Color primaryColor = primary,
    TextStyle receivedMessageBodyTextStyle = const TextStyle(
      color: neutral0,
      fontFamily: 'Avenir',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    TextStyle receivedMessageCaptionTextStyle = const TextStyle(
      color: neutral2,
      fontFamily: 'Avenir',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.333,
    ),
    Color receivedMessageDocumentIconColor = primary,
    TextStyle receivedMessageLinkDescriptionTextStyle = const TextStyle(
      color: neutral0,
      fontFamily: 'Avenir',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.428,
    ),
    TextStyle receivedMessageLinkTitleTextStyle = const TextStyle(
      color: neutral0,
      fontFamily: 'Avenir',
      fontSize: 16,
      fontWeight: FontWeight.w800,
      height: 1.375,
    ),
    Color secondaryColor = secondary,
    Widget? seenIcon,
    Widget? sendButtonIcon,
    Widget? sendingIcon,
    TextStyle sentMessageBodyTextStyle = const TextStyle(
      color: neutral7,
      fontFamily: 'Avenir',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    TextStyle sentMessageCaptionTextStyle = const TextStyle(
      color: neutral7WithOpacity,
      fontFamily: 'Avenir',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.333,
    ),
    Color sentMessageDocumentIconColor = neutral7,
    TextStyle sentMessageLinkDescriptionTextStyle = const TextStyle(
      color: neutral7,
      fontFamily: 'Avenir',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.428,
    ),
    TextStyle nameTextStyle = const TextStyle(
      color: neutral7,
      fontFamily: 'Avenir',
      fontSize: 16,
      fontWeight: FontWeight.w800,
      height: 1.375,
    ),
    Color userAvatarImageBackgroundColor = Colors.transparent,
    List<Color> userAvatarNameColors = colors,
    TextStyle userAvatarTextStyle = const TextStyle(
      color: neutral7,
      fontFamily: 'Avenir',
      fontSize: 12,
      fontWeight: FontWeight.w800,
      height: 1.333,
    ),
    TextStyle headerTextStyle = const TextStyle(
      fontFamily: 'Avenir',
      fontSize: 13,
      color: Color(0xffA9AAAD),
      fontWeight: FontWeight.w400,
      height: 1.333,
    ),
    TextStyle titleTextStyle = const TextStyle(
      fontFamily: 'Avenir',
      fontSize: 16,
      color: Color(0xffE8EAED),
      fontWeight: FontWeight.w400,
      height: 1.333,
    ),
    BoxDecoration headerContainerDecoration = const BoxDecoration(
        color: Color(0xff0D0D0D),
        border: Border(
          top: BorderSide(width: 0.0, color: Color(0xFF8A8B8F)),
          left: BorderSide.none,
          right: BorderSide.none,
          bottom: BorderSide(width: 0.0, color: Color(0xFF8A8B8F)),
        )),
    BoxDecoration linePaDecoration = const BoxDecoration(
        border: Border(
      top: BorderSide.none,
      left: BorderSide.none,
      right: BorderSide.none,
      bottom: BorderSide(width: 0.0, color: Color(0xFF8A8B8F)),
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
  }) : super(
            linePaDecoration: linePaDecoration,
            linePadding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            backgroundColor: backgroundColor,
            headerContainerPadding:
                const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
            headerContainerDecoration: headerContainerDecoration,
            headerTextStyle: headerTextStyle,
            titleTextStyle: titleTextStyle,
            toggleMinWidth: 50,
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
            linePaDecorationAboveHeader: linePaDecorationAboveHeader);
}
