import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';

import '../json_to_form_with_theme.dart';
import '../stream_cache.dart';
import 'line_wrapper.dart';
import 'name_description_widget.dart';

class EditTextValue extends StatefulWidget {
  final String? description;
  final String name;
  final String id;
  String chosenValue;
  final bool isBeforeHeader;
  final OnValueChanged? onValueChanged;
  final Widget Function(int date)? dateBuilder;
  int? time;
  final bool isReadOnly;
  final bool long;
  StreamController<String?>? streamUpdates;
  StreamController<bool?>? streamRefresh;

  EditTextValue({
    Key? key,
    required this.name,
    required this.id,
    required this.isBeforeHeader,
    this.description,
    required this.onValueChanged,
    required this.chosenValue,
    this.isReadOnly = false,
    this.long = false,
    this.dateBuilder,
    this.time,
  }) : super(key: key) {
    streamUpdates = StreamCache.getStream(id);
    streamRefresh = StreamCache.getStreamRefresh(id);
  }

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
  late final StreamSubscription<String?>? _valueChange;
  bool forceRefresh = false;
  String notCutValue = "";

  @override
  void initState() {
    widget.streamUpdates?.stream
        .asBroadcastStream()
        .listen(_onRemoteValueChanged);
    widget.streamRefresh?.stream.asBroadcastStream().listen((event) {
      if (mounted) {
        setState(() {
          forceRefresh = true;
        });
      }
    });
    notCutValue = widget.chosenValue;
    thisTime = widget.time;
    initialText = widget.chosenValue;
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
    if (shouldCut(widget.chosenValue)) {
      _controller ??=
          TextEditingController(text: generateDottedText(widget.chosenValue));
    } else {
      _controller ??= TextEditingController(text: (widget.chosenValue));
    }
    _controller?.addListener(notifyValue);
  }

  bool cutIgnore = false;
  bool justLostFocus = false;
  bool updateFromRemote = false;
  bool setPositionRemote = false;

  void _onRemoteValueChanged(String? event) {
    updateFromRemote = true;
    setPositionRemote = true;
    notCutValue = event ?? "";
    if (mounted) {
      setState(() {
        if (shouldCut(notCutValue)) {
          _controller?.text = generateDottedText(notCutValue);
        } else {
          _controller?.text = notCutValue;
        }
        _controller?.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller!.text.length));
        thisTime = DateTime.now().millisecondsSinceEpoch;
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
        (!firstTime || _controller!.text != widget.chosenValue)) {
      if (_debounce?.isActive ?? false) {
        _debounce?.cancel();
      }
      if (debounceTime != null && debounceTime! > 0) {
        _debounce = Timer(Duration(milliseconds: debounceTime!), () async {
          if (widget.onValueChanged != null) {
            bool res =
                await widget.onValueChanged!(widget.id, _controller!.text);
            if (res && mounted) {
              setState(() {
                thisTime = DateTime.now().millisecondsSinceEpoch;
              });
            }
          }
        });
      } else {
        bool res = await widget.onValueChanged!(widget.id, _controller!.text);
        if (res && mounted) {
          setState(() {
            thisTime = DateTime.now().millisecondsSinceEpoch;
          });
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
    StreamCache.closeStream(widget.id);
    StreamCache.closeRefreshStream(widget.id);
    super.dispose();
  }

  void startController() {
    if (!widget.isReadOnly) {
      if (shouldCut(widget.chosenValue)) {
        notCutValue = widget.chosenValue;
        _controller!.text = generateDottedText(widget.chosenValue);
      } else {
        _controller!.text = (widget.chosenValue);
      }
      thisTime = widget.time;
    }
    _controller?.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller!.text.length));
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
      thisTime = widget.time;
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
