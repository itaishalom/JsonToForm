import 'package:flutter/cupertino.dart';
import 'package:json_to_form/parsers/widget_parser.dart';
import 'package:json_to_form/widgets/header.dart';
import 'package:json_to_form/widgets/toggle.dart';

import '../json_to_form.dart';

class HeaderParser implements WidgetParser{
  HeaderParser(
      this.name){

  }


  final String name;



  HeaderParser.fromJson(Map<String, dynamic> json)
      : name = json['name'];

  Map<String, dynamic> toJson() => {
        'name': name,
      };


  Widget getWidget() {
    return Header(
        name: name);
  }
}
