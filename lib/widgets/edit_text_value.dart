import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/parsers/edit_text_parser.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';
import 'package:sizer/sizer.dart';

import '../json_to_form_with_theme.dart';
import 'line_wrapper.dart';
import 'name_description_widget.dart';

class EditTextValue extends StatefulWidget {
  
 final OnValueChanged? onValueChanged;

  final Widget Function(int date, String id)? dateBuilder;
  EditTextValueModel model;
  EditTextValue({
    Key? key,
    required  this.model,
    required this.onValueChanged,
    this.dateBuilder,
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
  String? initialText = "";
  bool forceRefresh = false;
  String notCutValue = "";
  final ValueNotifier<int?> thisTime = ValueNotifier<int?>(null);
  @override
  void didChangeDependencies() {
    UpdateStreamWidget.of(context)?.dataClassStream.listen(_onRemoteValueChanged);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant EditTextValue oldWidget) {
    super.didUpdateWidget(oldWidget);
    forceRefresh = true;
  }

  @override
  void initState() {
    notCutValue = widget.model.chosenValue;
    thisTime.value = widget.model.time;
    initialText = widget.model.chosenValue;
    if (!widget.model.isReadOnly) {
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
    return !widget.model.long && InheritedJsonFormTheme.of(context).theme.overflow;
  }

  bool shouldCut(String text) {
    bool res = (shouldCutLight() && text.length > 5);
    if (res) {
      cutIgnore = true;
    }
    return res;
  }

  initTextController() {
    if (shouldCut(widget.model.chosenValue)) {
      _controller ??=
          TextEditingController(text: generateDottedText(widget.model.chosenValue));
    } else {
      _controller ??= TextEditingController(text: (widget.model.chosenValue));
    }
    _controller?.addListener(notifyValue);
  }

  bool cutIgnore = false;
  bool justLostFocus = false;
  bool updateFromRemote = false;
  bool setPositionRemote = false;

  void _onRemoteValueChanged(DataClass event) {
    if(event.id != widget.model.id){
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
        thisTime.value = widget.model.time;
        initialText = _controller?.text;
      });
    }
  }

  bool controllerLoaded = false;
  Future<bool> changeValue(String id, dynamic value)
         async{
        if (widget.model.chosenValue != value) {
          widget.model.chosenValue = value;
          if (widget.onValueChanged != null) {
            return await widget.onValueChanged!(id, value);
          }
        }
        return false;
  }

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
        (!firstTime || _controller!.text != widget.model.chosenValue)) {
      if (_debounce?.isActive ?? false) {
        _debounce?.cancel();
      }
      if (debounceTime != null && debounceTime! > 0) {
        _debounce = Timer(Duration(milliseconds: debounceTime!), () async {
          if (widget.onValueChanged != null) {
            bool res =
                await changeValue(widget.model.id, _controller!.text);
            if (res) {
              thisTime.value = DateTime
                  .now()
                  .millisecondsSinceEpoch;
              widget.model.time = thisTime.value!;
            }
          }
        });
      } else {
        bool res = await changeValue(widget.model.id, _controller!.text);

        if (res) {
          thisTime.value = DateTime.now().millisecondsSinceEpoch;
          widget.model.time = thisTime.value!;
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
    if (!widget.model.isReadOnly) {
      myFocusNode.dispose();
    }
    super.dispose();
  }


  void startController() {
    if (!widget.model.isReadOnly) {
      if (shouldCut(widget.model.chosenValue)) {
        notCutValue = widget.model.chosenValue;
        _controller!.text = generateDottedText(widget.model.chosenValue);
      } else {
        notCutValue = widget.model.chosenValue;
        updateFromRemote = true;
        _controller!.text = (widget.model.chosenValue);
      }
      thisTime.value = widget.model.time;
    }
    setPositionRemote = true;
    _controller?.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller!.text.length));
    initialText = notCutValue;
  }

  //  _controller?.addListener(notifyValue);

  requestFocus(BuildContext context) {
    //WidgetsBinding.instance?.addPostFrameCallback((_) => _controller?.text = (_controller!.text));
    if (!widget.model.isReadOnly) {
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
      thisTime.value = widget.model.time;
    }
    Widget text = Container(
        margin: widget.model.long
            ? InheritedJsonFormTheme.of(context).theme.editTextLongMargins
            : InheritedJsonFormTheme.of(context).theme.editTextMargins,

        child: TextField(
          onTap: () => requestFocus(context),
          focusNode: widget.model.isReadOnly ? null : myFocusNode,
          autofocus: false,
          clipBehavior: Clip.antiAlias,
          readOnly: widget.model.isReadOnly,
          maxLines: widget.model.long ? 10 : 1,
          minLines: 1,
          keyboardType: widget.model.long
              ? InheritedJsonFormTheme.of(context).theme.keyboardTypeLong
              : InheritedJsonFormTheme.of(context).theme.keyboardTypeShort,
          inputFormatters: widget.model.long
              ? []
              : [
                  LengthLimitingTextInputFormatter(12),
                ],
          textAlign: widget.model.long ? TextAlign.start : TextAlign.center,
          obscureText: false,
          controller: _controller,
          style: !widget.model.isReadOnly
              ? (myFocusNode.hasFocus
                  ? InheritedJsonFormTheme.of(context).theme.editTextStyleFocus
                  : InheritedJsonFormTheme.of(context).theme.editTextStyle)
              : InheritedJsonFormTheme.of(context).theme.editTextStyle,
          cursorColor:
              InheritedJsonFormTheme.of(context).theme.editTextCursorColor,
          //
          decoration: widget.model.isReadOnly
              ? InheritedJsonFormTheme.of(context).theme.inputDecorationReadOnly
              : InheritedJsonFormTheme.of(context).theme.inputDecoration,
        ));

    List<Widget> innerWidgets = [
      ValueListenableBuilder<int?>(
          valueListenable: thisTime,
          builder: (context, time, _) {
            return   NameWidgetDescription(
              name: widget.model.name,
              id: widget.model.id,
              width: InheritedJsonFormTheme.of(context).theme.editTextWidthOfHeader,
              description: widget.model.description,
              dateBuilder: widget.dateBuilder,
              time: time,
              componentSameLine: !widget.model.long,
            );
          })
    ,
    ];
    if (widget.model.long) {
      innerWidgets.add(text);
    } else {
      innerWidgets.add(SizedBox(
          height: InheritedJsonFormTheme.of(context).theme.editTextHeight,
          width: InheritedJsonFormTheme.of(context).theme.editTextWidth,
          child: text));
    }
    return Container(
      constraints: BoxConstraints(minHeight: InheritedJsonFormTheme.of(context).theme.itemMinHeight.h),
      child: LineWrapper(
        isBeforeHeader: widget.model.isBeforeHeader,
        child: widget.model.long
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
      ),
    );
  }
}
