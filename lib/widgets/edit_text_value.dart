import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';

import '../json_to_form_with_theme.dart';
import 'line_wrapper.dart';
import 'name_description_widget.dart';

class EditTextValue extends StatefulWidget {
  final String? description;
  final String name;
  final String id;
  String chosenValue;
  final bool isBeforeHeader;
  final OnValueChanged? onValueChanged;
  final Function getUpdatedValue;
  final Function getUpdatedTime;
  final Widget Function(int date)? dateBuilder;
  int? time;
  final bool isReadOnly;
  final bool long;
  Function(int) onTimeUpdated;

  EditTextValue({
    Key? key,
    required this.name,
    required this.onTimeUpdated,
    required this.id,
    required this.isBeforeHeader,
    this.description,
    required this.getUpdatedTime,
    required this.onValueChanged,
    required this.getUpdatedValue,
    required this.chosenValue,

    this.isReadOnly = false,
    this.long = false,
    this.dateBuilder,

    this.time,
  }) : super(key: key);

  @override
  _EditTextValueState createState() => _EditTextValueState();
}

class _EditTextValueState extends State<EditTextValue> {
  TextEditingController? _controller;
  Timer? _debounce;
  bool firstTime = true;
  late FocusNode myFocusNode;
  int? debounceTime;
  int? thisTime;
  String? initialText = "";
  bool forceRefresh = false;
  String notCutValue = "";

  @override
  void didChangeDependencies() {
    UpdateStreamWidget.of(context)!.dataClassStream.listen(_onRemoteValueChanged);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant EditTextValue oldWidget) {
    super.didUpdateWidget(oldWidget);
    forceRefresh = true;
  }

  @override
  void initState() {
    notCutValue = widget.getUpdatedValue();
    thisTime = widget.getUpdatedTime();
    initialText = widget.getUpdatedValue();
    if (!widget.isReadOnly) {
      myFocusNode = FocusNode();
      myFocusNode.addListener(() {
        if (!myFocusNode.hasFocus) {
          justLostFocus = true;
          if (mounted) {
            notCutValue = _controller!.text;
            if (shouldCut(_controller!.text)) {
              setState(() {
                _controller!.text = generateDottedText(_controller!.text);
              });
            }
          }
        } else {
          if (shouldCut(notCutValue)) {
            setState(() {
              _controller!.text = notCutValue;
            });
          } else {
            notCutValue = _controller!.text;
          }
        }
      });
    }
    super.initState();
  }

  String generateDottedText(String longText) {
    if(longText.length > 5) {
      return longText.substring(0, 5) + ".." ;
    }
    return longText;
  }

  bool shouldCutLight() {
    return !widget.long && InheritedJsonFormTheme.of(context).theme.overflow;
  }

  bool shouldCut(String text) {
    bool res = (shouldCutLight() && text.length > 5);
    if (res) {
      cutIgnore = true;
    }
    return res;
  }

  initTextController() {
    if (shouldCut(widget.getUpdatedValue())) {
      _controller ??=
          TextEditingController(text: generateDottedText(widget.getUpdatedValue()));
    } else {
      _controller ??= TextEditingController(text: (widget.getUpdatedValue()));
    }
    _controller?.addListener(notifyValue);
  }

  bool cutIgnore = false;
  bool justLostFocus = false;
  bool updateFromRemote = false;
  bool setPositionRemote = false;

  void _onRemoteValueChanged(DataClass event) {
    if(event.id != widget.id){
      return;
    }
    updateFromRemote = true;
    setPositionRemote = true;
    notCutValue = event.value ?? "";
    if (mounted) {
      setState(() {
        if (!myFocusNode.hasFocus && shouldCut(notCutValue)) {
          _controller?.text = generateDottedText(notCutValue);
        } else {
          _controller?.text = notCutValue;
        }
        _controller?.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller!.text.length));
        thisTime = widget.getUpdatedTime();
        initialText = _controller?.text;
      });
    }
  }

  bool controllerLoaded = false;

  Future<void> notifyValue() async {
    if (cutIgnore) {
      cutIgnore = false;
      return;
    }

    if (updateFromRemote) {
      updateFromRemote = false;
      return;
    }
    if (setPositionRemote) {
      setPositionRemote = false;
      return;
    }
    if (initialText == _controller?.text) {
      return;
    }
    if (shouldCutLight()) {
      if ((initialText == notCutValue) &&
          (_controller?.text == generateDottedText(notCutValue))) {
        return;
      }
    }
    initialText = _controller?.text;
    if (widget.onValueChanged != null &&
        (!firstTime || _controller!.text != widget.getUpdatedValue())) {
      if (_debounce?.isActive ?? false) {
        _debounce?.cancel();
      }
      if (debounceTime != null && debounceTime! > 0) {
        _debounce = Timer(Duration(milliseconds: debounceTime!), () async {
          if (widget.onValueChanged != null) {
            bool res =
                await widget.onValueChanged!(widget.id, _controller!.text);
            if (res) {
              thisTime = DateTime
                  .now()
                  .millisecondsSinceEpoch;
              widget.onTimeUpdated(thisTime!);
              if(mounted) {
                setState(() {
                  thisTime;
                });
              }
            }
          }
        });
      } else {
        bool res = await widget.onValueChanged!(widget.id, _controller!.text);

        if (res) {
          thisTime = DateTime.now().millisecondsSinceEpoch;
          widget.onTimeUpdated(thisTime!);
          if(mounted) {
            setState(() {
              thisTime;
            });
          }
        }
      }
    }
    firstTime = false;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _controller?.dispose();
    if (!widget.isReadOnly) {
      myFocusNode.dispose();
    }
    super.dispose();
  }


  void startController() {
    if (!widget.isReadOnly) {
      if (shouldCut(widget.getUpdatedValue())) {
        notCutValue = widget.getUpdatedValue();
        _controller!.text = generateDottedText(widget.getUpdatedValue());
      } else {
        notCutValue = widget.getUpdatedValue();
        updateFromRemote = true;
        _controller!.text = (widget.getUpdatedValue());
      }
      thisTime = widget.getUpdatedTime();
    }
    setPositionRemote = true;
    _controller?.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller!.text.length));
    initialText = notCutValue;
  }

  //  _controller?.addListener(notifyValue);

  requestFocus(BuildContext context) {
    //WidgetsBinding.instance?.addPostFrameCallback((_) => _controller?.text = (_controller!.text));
    if (!widget.isReadOnly) {
      FocusScope.of(context).requestFocus(myFocusNode);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controllerLoaded) {
      initTextController();
      controllerLoaded = true;
    }
    debounceTime = InheritedJsonFormTheme.of(context).theme.debounceTime;
    if (forceRefresh) {
      forceRefresh = false;
      startController();
      thisTime = widget.getUpdatedTime();
    }
    Widget text = Container(
        margin: widget.long
            ? InheritedJsonFormTheme.of(context).theme.editTextLongMargins
            : InheritedJsonFormTheme.of(context).theme.editTextMargins,
        child: TextField(
          onTap: () => requestFocus(context),
          focusNode: widget.isReadOnly ? null : myFocusNode,
          autofocus: false,
          clipBehavior: Clip.antiAlias,
          readOnly: widget.isReadOnly,
          maxLines: widget.long ? 10 : 1,
          minLines: 1,
          keyboardType: widget.long
              ? InheritedJsonFormTheme.of(context).theme.keyboardTypeLong
              : InheritedJsonFormTheme.of(context).theme.keyboardTypeShort,
          inputFormatters: widget.long
              ? []
              : [
                  LengthLimitingTextInputFormatter(12),
                ],
          textAlign: widget.long ? TextAlign.start : TextAlign.center,
          obscureText: false,
          controller: _controller,
          style: !widget.isReadOnly
              ? (myFocusNode.hasFocus
                  ? InheritedJsonFormTheme.of(context).theme.editTextStyleFocus
                  : InheritedJsonFormTheme.of(context).theme.editTextStyle)
              : InheritedJsonFormTheme.of(context).theme.editTextStyle,
          cursorColor:
              InheritedJsonFormTheme.of(context).theme.editTextCursorColor,
          //
          decoration: widget.isReadOnly
              ? InheritedJsonFormTheme.of(context).theme.inputDecorationReadOnly
              : InheritedJsonFormTheme.of(context).theme.inputDecoration,
        ));

    List<Widget> innerWidgets = [
      NameWidgetDescription(
        name: widget.name,
        description: widget.description,
        dateBuilder: widget.dateBuilder,
        time: thisTime,
        componentSameLine: !widget.long,
      ),
    ];
    if (widget.long) {
      innerWidgets.add(text);
    } else {
      innerWidgets.add(SizedBox(
          height: InheritedJsonFormTheme.of(context).theme.editTextHeight,
          width: InheritedJsonFormTheme.of(context).theme.editTextWidth,
          child: text));
    }
    return LineWrapper(
      isBeforeHeader: widget.isBeforeHeader,
      child: widget.long
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.ltr,
              children: <Widget>[...innerWidgets],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.ltr,
              children: <Widget>[...innerWidgets],
            ),
    );
  }
}
