import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/parsers/edit_text_parser.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';

import '../json_to_form_with_theme.dart';
import 'line_wrapper.dart';
import 'name_description_widget.dart';

class SaveableEditTextValue extends StatefulWidget  implements Saveble {
  final OnValueChanged? onValueChanged;
  final DateBuilderMethod? dateBuilder;
  final SaveBarBuilderMethod? savebarBuilder;
  late Function(bool isFoucs, Saveble item)? whenFoucsed;

  final EditTextValueModel model;

   SaveableEditTextValue({
    Key? key,
    required  this.model,
    required this.onValueChanged,
    required this.savebarBuilder,
    this.dateBuilder,
  }) : super(key: key);

   late _SaveableEditTextValueState state;

  @override
  _SaveableEditTextValueState createState() {
    state = _SaveableEditTextValueState();
    return state;
  }

  @override
  void reset() {
    state.reset();
  }

  @override
  void save() {
    state.save();
  }
}
abstract class Saveble{
  void save();
  void reset();
}

class _SaveableEditTextValueState extends State<SaveableEditTextValue> with TickerProviderStateMixin implements Saveble{
  final TextEditingController _controller = TextEditingController();
  late FocusNode _focusNode;
  final ValueNotifier<int?> thisTime = ValueNotifier<int?>(null);
  PersistentBottomSheetController<void>? _bottomSheetController = null;

  @override
  void didChangeDependencies() {
    UpdateStreamWidget.of(context)?.dataClassStream.listen(_onRemoteValueChanged);
    _controller.text = generatefinalText(widget.model.chosenValue);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    thisTime.value = widget.model.time;

    if (!widget.model.isReadOnly) {
      _focusNode = FocusNode();
      _focusNode.addListener(() {
        print("focus: ${_focusNode.hasFocus}");
        widget.whenFoucsed?.call(_focusNode.hasFocus, this);
        if (_focusNode.hasFocus) {
           updateControllerToOriginalText();
           enableBottomSheet(context);
        }else{
            _controller.text = generatefinalText(widget.model.chosenValue);
            closeBottomSheet();
         }
      });
    }
    super.initState();
  }

  void updateControllerToOriginalText() {
    _controller.text = widget.model.chosenValue;
    // _controller.selection =
        // TextSelection.fromPosition(
        // TextPosition(offset: _controller.text.length));
  }

  void enableBottomSheet(BuildContext context) {

    if (widget.savebarBuilder == null || widget.model.isReadOnly) {
      return;
    }

    _bottomSheetController = showBottomSheet(
        context: context,
        enableDrag: false,

        transitionAnimationController: AnimationController(duration: const Duration(seconds: 0), vsync: this),
        builder: (BuildContext context) {
          return  widget.savebarBuilder!(onSave: () {
            applaySave(context);
          }, onClose: () {
            closeBottomSheet();
          });
        });


    _bottomSheetController?.closed.then((value)  {
          unfocusThis(context);
    });

  }

  void closeBottomSheet() {
    _bottomSheetController?.close();
    _bottomSheetController = null;
  }

  void unfocusThis(BuildContext context) {
    if(_focusNode.hasFocus) {
       FocusScope.of(context).unfocus();
    }
  }

  void applaySave(BuildContext context) {
    changeValue(widget.model.id, _controller.text);
    if(!widget.model.hasNext){
      closeBottomSheet();
      FocusScope.of(context).unfocus();
    }
    else {
      if(!FocusScope.of(context).nextFocus()){
        FocusScope.of(context).unfocus();
      }
    }
  }

  void _onRemoteValueChanged(DataClass event) {
    if(event.id != widget.model.id){
      return;
    }

    if (mounted) {
      setState(() {
        _controller.text = generatefinalText(widget.model.chosenValue);
        thisTime.value = widget.model.time;
      });
    }
  }

  void changeValue(String id, dynamic value)  {
    if (widget.model.chosenValue != value) {
      widget.model.chosenValue = value;
      if (widget.onValueChanged != null) {
        widget.onValueChanged!(id, value);
      }
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    closeBottomSheet();
    if (!widget.model.isReadOnly) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  requestFocus(BuildContext context) {
    if (!widget.model.isReadOnly) {
      updateControllerToOriginalText();
      FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  resetText(){
    _controller.text = generatefinalText(widget.model.chosenValue);
  }
  String generatefinalText(String longText) {
    if(_shouldCutLight() && longText.length > 5) {
      return longText.substring(0, 5) + ".." ;
    }
    return longText;
  }

  bool _shouldCutLight() {
    return !widget.model.long && InheritedJsonFormTheme.of(context).theme.overflow;
  }

  @override
  Widget build(BuildContext context) {

    Widget text = Container(
        margin: widget.model.long
            ? InheritedJsonFormTheme.of(context).theme.editTextLongMargins
            : InheritedJsonFormTheme.of(context).theme.editTextMargins,

        child: TextField(
          scrollPadding: const EdgeInsets.only(bottom: 100),
          focusNode: widget.model.isReadOnly ? null : _focusNode,
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
          textInputAction:  widget.model.long ? TextInputAction.newline: widget.model.hasNext?  TextInputAction.next : TextInputAction.done ,
          onSubmitted: (s)=> applaySave(context),
          style: !widget.model.isReadOnly
              ? (_focusNode.hasFocus
                  ? InheritedJsonFormTheme.of(context).theme.editTextStyleFocus
                  : InheritedJsonFormTheme.of(context).theme.editTextStyle)
              : InheritedJsonFormTheme.of(context).theme.editTextStyle,
          cursorColor:
              InheritedJsonFormTheme.of(context).theme.editTextCursorColor,
          decoration:
          widget.model.isReadOnly
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
    return  Container(
      constraints: BoxConstraints(minHeight: InheritedJsonFormTheme.of(context).theme.itemMinHeight),
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

  @override
  void reset() {
    resetText();
  }

  @override
  void save() {
    applaySave(context);
  }
}
