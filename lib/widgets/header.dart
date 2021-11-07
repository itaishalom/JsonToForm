import 'package:flutter/widgets.dart';
import 'package:json_to_form/themes/inherited_json_form_theme.dart';

class Header extends StatelessWidget  {
  final String name;
  final int id;
  const Header({Key? key, required this.name, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(

      padding: InheritedJsonFormTheme.of(context).theme.headerContainerPadding,
      decoration: InheritedJsonFormTheme.of(context).theme.headerContainerDecoration,
      child: Text(
        name,
        style: InheritedJsonFormTheme.of(context).theme.headerTextStyle,
      ),
    );
  }


  @override
  void onNewValue(value) {
    // TODO: implement onNewValue
  }

  @override
  set id(int _id) {
    // TODO: implement id
  }
}
