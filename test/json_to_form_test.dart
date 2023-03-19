import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_form_with_theme/exceptions/parsing_exception.dart';

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/themes/json_form_theme.dart';

import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/widgets/drop_down_widget.dart';
import 'package:json_to_form_with_theme/widgets/edit_text_value.dart';
import 'package:json_to_form_with_theme/widgets/saveable_edit_text_value.dart';
import 'package:json_to_form_with_theme/widgets/header.dart';
import 'package:json_to_form_with_theme/widgets/static_text_value.dart';
import 'package:json_to_form_with_theme/widgets/toggle.dart';

void main() {

  Widget saveBarBuilder({required Function onSave, required Function onClose}) {
    return Row(
          children: [
            ElevatedButton(
              key: ValueKey("closeButton"),
                onPressed: ()=> onClose(),
                child: Text("close")),

            ElevatedButton(
                key: ValueKey("saveButton"),
                onPressed: ()=> onSave(),
                child: Text("save")),
          ]
    );
  }

  group("Widget tests:", () {
    int yearInMilliseconds = 31556952000;
    int monthInMilliseconds = 2629800000;
    int weekInMilliseconds = 604800000;
    int dayInMilliseconds = 86400000;
    int hourInMilliseconds = 3600000;
    int minuteInMilliseconds = 60000;

    String buildDaysString(int diff) {
      int days = diff ~/ dayInMilliseconds;
      return "${days}d";
    }


    String buildMonthString(DateTime dateTime) {
      return DateFormat.MMMd().format(dateTime);
    }


    String build24String(int diff) {
      int hours = diff ~/ hourInMilliseconds;
      int minutes = (diff - (hours * hourInMilliseconds)) ~/ minuteInMilliseconds;
      return "${hours}h ${minutes}m";
    }

    String buildDate(DateTime dateTime) {
      final now = DateTime.now();
      int diff = now.millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch;

      if (diff < dayInMilliseconds) {
        return build24String(diff);
      } else if (diff >= dayInMilliseconds && diff < monthInMilliseconds) {
        return buildDaysString(diff);
      } else if (diff >= monthInMilliseconds && diff < yearInMilliseconds) {
        return buildMonthString(dateTime);
      }
      return dateTime.year.toString();
    }





    Widget dateBuilder(int date, String id) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
      return Text(buildDate(dateTime));
    }

    testWidgets('Verify toggle', (WidgetTester tester) async {
       Map<String, dynamic> json = {
        "widgets": [
          {
            "id": "1",
            "name": "Toggle",
            "type": "toggle",
            "time": DateTime.now().subtract( const Duration(minutes: 5)).millisecondsSinceEpoch,

            "values": ["On", "Off"],
            "chosen_value": "Off"
          },
        ]
      };

       MaterialApp app =  MaterialApp(
         home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).setDateBuilderMethod(dateBuilder).build()),
       );

      await tester.pumpWidget(
          app
      );
      // Trigger a frame.
      await tester.pump();

      expect(find.byType(Toggle), findsOneWidget);
       expect(find.textContaining("On"), findsNWidgets(1));
       expect(find.textContaining("0h 5m"), findsNWidgets(1));

       expect(find.byType(EditTextValue), findsNothing);
      expect(find.byType(SaveableEditTextValue), findsNothing);
      expect(find.byType(Header), findsNothing);
      expect(find.byType(DropDownWidget), findsNothing);



        json = {
          "widgets": [
            {
              "time": DateTime.now().millisecondsSinceEpoch,
              "id": "1",
              "name": "Toggle",
              "type": "toggle",
              "values": ["Good", "Bad"],
              "chosen_value": "Good"
            },
          ]
        };
        app =  MaterialApp(
         home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).setDateBuilderMethod(dateBuilder).build()),
       );
       await tester.pumpWidget(
           app
       );
       // Trigger a frame.
       await tester.pump();
       expect(find.byType(Toggle), findsOneWidget);
       expect(find.textContaining("Good"), findsNWidgets(1));

       expect(find.textContaining("0h 0m"), findsNWidgets(1));




    });
    testWidgets('Verify edit text', (WidgetTester tester) async {
       Map<String, dynamic> json = {
        "widgets": [
          {
            "id": "3",
            "name": "Edit text",
            "type": "edit_text",
            "chosen_value": "kuzu",
            "description": "(edit description..)",
          }
        ]
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).build()),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      expect(find.byType(Toggle), findsNothing);
      expect(find.textContaining("kuzu"), findsNWidgets(1));
      expect(find.byType(EditTextValue), findsOneWidget);
      expect(find.byType(SaveableEditTextValue), findsNothing);
      expect(find.byType(Header), findsNothing);
      expect(find.byType(DropDownWidget), findsNothing);

       json = {
         "widgets": [
           {
             "id": "3",
             "name": "Edit text",
             "type": "edit_text",
             "chosen_value": "refresh123",
             "description": "(edit description..)",
           }
         ]
       };
       await tester.pumpWidget(
         MaterialApp(
           home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).build()),
         ),
       );
       // Trigger a frame.
       await tester.pump();
       debugDumpApp();
       expect(find.textContaining("refresh.."), findsNWidgets(1));

    });

    testWidgets('Verify save able edit text', (WidgetTester tester) async {
      final Map<String, dynamic> json = {
        "widgets": [
          {
            "id": "3",
            "name": "Edit text",
            "type": "edit_text",
            "chosen_value": "edit value",
            "description": "(edit description..)",
          }
        ]
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).setSaveBarBuilderMethod(saveBarBuilder).build()),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      expect(find.byType(Toggle), findsNothing);
      expect(find.byType(EditTextValue), findsNothing);
      expect(find.byType(SaveableEditTextValue), findsOneWidget);
      expect(find.byType(Header), findsNothing);
      expect(find.byType(DropDownWidget), findsNothing);
    });

    testWidgets('Verify  static text', (WidgetTester tester) async {
      final Map<String, dynamic> json = {
        "widgets": [
          {
            "id": "2",
            "name": "Static text",
            "type": "static_text",
            "chosen_value": "value",
            "description": "(description..)",
          },
        ]
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).build()),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      expect(find.byType(Toggle), findsNothing);
      expect(find.byType(EditTextValue), findsNothing);
      expect(find.byType(SaveableEditTextValue), findsNothing);
      expect(find.byType(Header), findsNothing);
      expect(find.byType(StaticTextValue), findsOneWidget);
      expect(find.byType(DropDownWidget), findsNothing);
    });
    testWidgets('Verify dropdown', (WidgetTester tester) async {
       Map<String, dynamic> json = {
        "widgets": [
          {
            "id": "4",
            "name": "Drop down",
            "type": "drop_down",
            "values": ["Low-Intermediate", "Medium", "High"],
            "chosen_value": "Low-Intermediate"
          },
        ]
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).build()),
        ),
      );
      await tester.pump();
      expect(find.byType(Toggle), findsNothing);
      expect(find.byType(EditTextValue), findsNothing);
      expect(find.byType(SaveableEditTextValue), findsNothing);
      expect(find.byType(Header), findsNothing);
      expect(find.byType(StaticTextValue), findsNothing);
      expect(find.byType(DropDownWidget), findsOneWidget);

      expect(find.textContaining("Low"), findsNWidgets(3));
       expect(find.textContaining("High"), findsNothing);

      json = {
        "widgets": [
          {
            "id": "4",
            "name": "Drop down",
            "type": "drop_down",
            "values": ["Low-Intermediate", "Medium", "High"],
            "chosen_value": "High"
          },
        ]
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).build()),
        ),
      );
       await tester.pump();
       expect(find.textContaining("Low"), findsNothing);

       expect(find.textContaining("High"), findsNWidgets(3));

    });
    testWidgets('Throws exception on same id twice', (WidgetTester tester) async {
      final Map<String, dynamic> json = {
        "widgets": [
          {
            "id": "4",
            "name": "Drop down",
            "type": "drop_down",
            "values": ["Low-Intermediate", "Medium", "High"],
            "chosen_value": "Low-Intermediate"
          },
          {
            "id": "4",
            "name": "Drop down",
            "type": "drop_down",
            "values": ["Low-Intermediate", "Medium", "High"],
            "chosen_value": "Low-Intermediate"
          },
        ]
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).build()),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      expect(tester.takeException(), isInstanceOf<ParsingException>());
    });

    testWidgets('Throws exception on same id twice', (WidgetTester tester) async {
      final Map<String, dynamic> json = {
        "widgets": [
          {
            "name": "Drop down",
            "type": "drop_down",
            "values": ["Low-Intermediate", "Medium", "High"],
            "chosen_value": "Low-Intermediate"
          },
        ]
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).build()),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      expect(tester.takeException(), isInstanceOf<ParsingException>());
    });

    testWidgets('Expect onValueChanged:', (WidgetTester tester) async {
      String valueAfterChange = "";
      final Map<String, dynamic> json = {
        "widgets": [
          {
            "id": "3",
            "name": "Edit text",
            "type": "edit_text",
            "chosen_value": "edit value",
            "description": "(edit description..)",
          }
        ]
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).setOnValueChanged((String id, dynamic value){
            valueAfterChange = value;
            return Future.value(true);
          }).build()),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      await tester.enterText(find.byKey(const ValueKey("3")), "test");
      final findText = find.text('test');
      expect(findText, findsOneWidget);
      expect(valueAfterChange, "test");
      await tester.enterText(find.byKey(const ValueKey("3")), "edit value");
      expect(valueAfterChange, "edit value");
    });

    testWidgets('Saveable Edit text Expect onValueChanged:', (WidgetTester tester) async {
      String valueAfterChange = "";
      final Map<String, dynamic> json = {
        "widgets": [
          {
            "id": "3",
            "name": "Edit text",
            "type": "edit_text",
            "chosen_value": "start",
            "description": "(edit description..)",
          }
        ]
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json)
              .setSaveBarBuilderMethod(saveBarBuilder)
              .setOnValueChanged((String id, dynamic value){
            valueAfterChange = value;
            return Future.value(true);
          }).build()),
        ),
      );
      // Trigger a frame.
      await tester.pump();

      final findText = find.text('start');
      expect(findText, findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey("3")), "test");
      expect(find.text('test'), findsOneWidget);

      FocusScope.of(tester.element(find.byType(TextField))).requestFocus();
      await tester.idle();
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("saveButton")));
      await tester.pump();

      expect(valueAfterChange, "test");
    });

    testWidgets('Saveable Edit text reverted on close', (WidgetTester tester) async {
      final Map<String, dynamic> json = {
        "widgets": [
          {
            "id": "3",
            "name": "Edit text",
            "type": "edit_text",
            "chosen_value": "start",
            "description": "(edit description..)",
          }
        ]
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json)
              .setSaveBarBuilderMethod(saveBarBuilder)
              .build()),
        ),
      );
      // Trigger a frame.
      await tester.pump();

      final findText = find.text('start');
      expect(findText, findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey("3")), "test");
      expect(find.text('test'), findsOneWidget);

      FocusScope.of(tester.element(find.byType(TextField))).requestFocus();
      await tester.idle();
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey("closeButton")));
      await tester.pump();

      expect(find.text('test'), findsNothing);
      expect(find.text('start'), findsOneWidget);
    });


    testWidgets('Expect onValueChanged: - not changed, read only short', (WidgetTester tester) async {
      String valueAfterChange = "";
      String intialValue = "edit";
      final Map<String, dynamic> json = {
        "widgets": [
          {
            "id": "3",
            "name": "Edit text",
            "type": "edit_text",
            "chosen_value": intialValue,
            "description": "(edit description..)",
            "read_only": true
          }
        ]
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).setOnValueChanged((String id, dynamic value){
            valueAfterChange = value;
            return Future.value(true);
          }).build(),),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      await tester.enterText(find.byKey(const ValueKey("3")), "test");
      final findText = find.text('test');
      expect(findText, findsNothing);
      expect(valueAfterChange, "");
      await tester.enterText(find.byKey(const ValueKey("3")), intialValue);
      expect(valueAfterChange, "");
    });

    testWidgets('Expect onValueChanged: - not changed, read only long', (WidgetTester tester) async {
      String valueAfterChange = "";
      String intialValue = "edit-value";
      String intialValueCut = "edit-..";
      final Map<String, dynamic> json = {
        "widgets": [
          {
            "id": "3",
            "name": "Edit text",
            "type": "edit_text",
            "chosen_value": intialValue,
            "description": "(edit description..)",
            "read_only": true
          }
        ]
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).setOnValueChanged((String id, dynamic value){
            valueAfterChange = value;
            return Future.value(true);
          }).build(),),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      await tester.enterText(find.byKey(const ValueKey("3")), "test");
      final findText = find.text('test');
      expect(findText, findsNothing);
      expect(valueAfterChange, "");
      await tester.enterText(find.byKey(const ValueKey("3")), intialValueCut);
      expect(valueAfterChange, "");
    });

    testWidgets('Change value from outside - short Text', (WidgetTester tester) async {

      Stream<Map<String, dynamic>>? onValueChangeStream;
      final StreamController<Map<String, dynamic>> _onUserController =
      StreamController<Map<String, dynamic>>();
      onValueChangeStream = _onUserController.stream.asBroadcastStream();
      String valueAfterChange = "Moro";
      final Map<String, dynamic> json = {
        "widgets": [
          {
            "id": "3",
            "name": "Edit text",
            "type": "edit_text",
            "chosen_value": "zoro",
            "description": "(edit description..)",
          }
        ]
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).setStreamUpdates(onValueChangeStream).build()),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      _onUserController.add({}..["3"] =
          valueAfterChange); // toggle


      await tester.pump(const Duration(seconds: 5));
      final findText = find.text(valueAfterChange);
      //debugDumpApp();
      expect(findText, findsOneWidget);
    });

    testWidgets('Change value from outside - long Text', (WidgetTester tester) async {

      Stream<Map<String, dynamic>>? onValueChangeStream;
      final StreamController<Map<String, dynamic>> _onUserController =
      StreamController<Map<String, dynamic>>();
      onValueChangeStream = _onUserController.stream.asBroadcastStream();
      String valueAfterChange = "MoroDorop";
      String valueAfterChangeCut = "MoroDor..";
      final Map<String, dynamic> json = {
        "widgets": [
          {
            "id": "3",
            "name": "Edit text",
            "type": "edit_text",
            "chosen_value": "zoroLoro",
            "description": "(edit description..)",
          }
        ]
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).setStreamUpdates(onValueChangeStream).build()),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      _onUserController.add({}..["3"] =
          valueAfterChange); // toggle


      await tester.pump(const Duration(seconds: 5));
      final findText = find.text(valueAfterChangeCut);
      expect(findText, findsOneWidget);
    });

    testWidgets('Change value from outside - long list with scroll', (WidgetTester tester) async {

      Stream<Map<String, dynamic>>? onValueChangeStream;
      final StreamController<Map<String, dynamic>> _onUserController =
      StreamController<Map<String, dynamic>>();
      onValueChangeStream = _onUserController.stream.asBroadcastStream();
      final Map<String, dynamic> json= {};
      json["widgets"] = [];
      for(int i = 0; i < 50; i++){
        json["widgets"].add ( {
          "id": "abc"+i.toString(),
          "name": "Edit text",
          "type": "edit_text",
          "chosen_value": i.toString(),
          "description": "(edit description..)",
        });
      }


      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json).setStreamUpdates(onValueChangeStream).build()),
        ),
      );
      // Trigger a frame.
      await tester.pump();

      _onUserController.add({}..["abc0"] =
          "zzz"); // toggle


      await tester.pump(const Duration(seconds: 5));

      expect(find.text("zzz"), findsOneWidget);

      _onUserController.add({}..["abc49"] =
          "51"); // toggle

      expect(find.text("51"), findsNothing);
      await tester.drag(find.byKey(Key('scrollView')), const Offset(0.0, -6000));
      await tester.pump(const Duration(seconds: 5));

      expect(find.text("51"), findsOneWidget);
      await tester.drag(find.byKey(Key('scrollView')), const Offset(0.0, 6000));
      await tester.pump(const Duration(seconds: 5));
      expect(find.text("zzz"), findsOneWidget);
    });


    testWidgets('Change value from outside - long list with scroll and change from the inside', (WidgetTester tester) async {
      String  testId = "abc0";
      Key scrollKey = const Key('scrollView');
      Stream<Map<String, dynamic>>? onValueChangeStream;
      final StreamController<Map<String, dynamic>> _onUserController =
      StreamController<Map<String, dynamic>>();
      onValueChangeStream = _onUserController.stream.asBroadcastStream();
      final Map<String, dynamic> json= {};
      json["widgets"] = [];
      for(int i = 0; i < 50; i++){
        json["widgets"].add ( {
          "id": "abc"+i.toString(),
          "name": "Edit text",
          "type": "edit_text",
          "chosen_value": i.toString(),
          "description": "(edit description..)",
        });
      }

    String valueAfterChange ="";
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json)
              .setStreamUpdates(onValueChangeStream)
              .setOnValueChanged((String id, dynamic value){
                valueAfterChange = value;
                return Future.value(true);
            }).build()
          ),
        ),
      );
      // Trigger a frame.
      await tester.pump();

      _onUserController.add({}..[testId] =
          "zzz"); // toggle


      await tester.pump(const Duration(seconds: 5));
      expect(find.text("zzz"), findsOneWidget);

      await tester.drag(find.byKey(scrollKey), const Offset(0.0, -3000));
      await tester.pump(const Duration(seconds: 5));



      await tester.drag(find.byKey(scrollKey), const Offset(0.0, 3000));
      await tester.pump(const Duration(seconds: 5));
      expect(find.text("zzz"), findsOneWidget);

      await tester.enterText(find.byKey(ValueKey(testId)), "test");
      expect(find.text('test'), findsOneWidget);
      expect(valueAfterChange, "test");
      await tester.drag(find.byKey(scrollKey), const Offset(0.0, -3000));
      await tester.pump(const Duration(seconds: 5));

      await tester.drag(find.byKey(scrollKey), const Offset(0.0, 3000));
      await tester.pump(const Duration(seconds: 5));
      expect(find.text('test'), findsOneWidget);
    });
    testWidgets('Verify dropdown updates - long list with multiple refreshes', (WidgetTester tester) async {


      Stream<Map<String, dynamic>>? onValueChangeStream;
      final StreamController<Map<String, dynamic>> _onUserController =
      StreamController<Map<String, dynamic>>();
      String valueAfterChange = "XXX";
      onValueChangeStream = _onUserController.stream.asBroadcastStream();
      String dropId= "drpId";
      final Map<String, dynamic> json = {
        "widgets": [
          {
            "id": dropId,
            "name": "Drop down",
            "type": "drop_down",
            "values": ["XXX", "YYY", "ZZZ"],
            "chosen_value": "ZZZ"
          },
        ]
      };
      for(int i = 0; i < 50; i++){
        json["widgets"].add ( {
          "id": "abc"+i.toString(),
          "name": "Edit text",
          "type": "edit_text",
          "chosen_value": i.toString(),
          "description": "(edit description..)",
        });
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json)
              .setStreamUpdates(onValueChangeStream)
              .setOnValueChanged((String id, dynamic value){
            valueAfterChange = value;
            return Future.value(true);
          }).build()
          ),
        ),
      );
      await tester.pump();
      _onUserController.add({}..[dropId] =
          valueAfterChange); //
      await tester.pump(const Duration(seconds: 5));


      Key scrollKey = const Key('scrollView');
      ValueKey innerDropDown =  ValueKey(dropId);
      final dropdownItem = find.text('valueAfterChange').last;


      expect(find.text(valueAfterChange), findsNWidgets(3));
      expect(find.text("ZZZ"), findsNothing);

      await tester.drag(find.byKey(scrollKey), const Offset(0.0, -3000));
      await tester.pump(const Duration(seconds: 5));

      await tester.drag(find.byKey(scrollKey), const Offset(0.0, 3000));
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();



      expect(find.text(valueAfterChange), findsNWidgets(3));
      expect(find.text("ZZZ"), findsNothing);
      await tester.pump();

      expect((tester.widget(find.byKey(ValueKey(dropId +"inner"))) as DropdownButton).value,
          equals('XXX'));
      // Here before the menu is open we have one widget with text 'Lesser'

      await tester.tap(find.byKey(ValueKey(dropId +"inner")));
      // Calling pump twice once comple the the action and
      // again to finish the animation of closing the menu.
      await tester.pump();
      await tester.pump(Duration(seconds: 1));

      // after opening the menu we have two widgets with text 'Greater'
      // one in index stack of the dropdown button and one in the menu .
      // apparently the last one is from the menu.
      await tester.tap(find.text('YYY').last);
      await tester.pump();
      await tester.pump(Duration(seconds: 1));

      /// We directly verify the value updated in the onchaged function.
      expect(valueAfterChange, 'YYY');



      await tester.tap(find.byKey(ValueKey(dropId +"inner")));
      // Calling pump twice once comple the the action and
      // again to finish the animation of closing the menu.
      await tester.pump();
      await tester.pump(Duration(seconds: 1));

      // after opening the menu we have two widgets with text 'Greater'
      // one in index stack of the dropdown button and one in the menu .
      // apparently the last one is from the menu.
      await tester.tap(find.text('ZZZ').last);
      await tester.pump();
      await tester.pump(Duration(seconds: 1));

      /// We directly verify the value updated in the onchaged function.
      expect(valueAfterChange, 'ZZZ');

      await tester.drag(find.byKey(scrollKey), const Offset(0.0, -3000));
      await tester.pump(const Duration(seconds: 5));

      await tester.drag(find.byKey(scrollKey), const Offset(0.0, 3000));
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      expect((tester.widget(find.byKey(ValueKey(dropId +"inner"))) as DropdownButton).value,
          equals('ZZZ'));

      _onUserController.add({}..[dropId] =
          "XXX"); //
      await tester.pump(const Duration(seconds: 5));

      expect((tester.widget(find.byKey(ValueKey(dropId +"inner"))) as DropdownButton).value,
          equals('XXX'));

      await tester.drag(find.byKey(scrollKey), const Offset(0.0, -3000));
      await tester.pump(const Duration(seconds: 5));

      await tester.drag(find.byKey(scrollKey), const Offset(0.0, 3000));
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      expect((tester.widget(find.byKey(ValueKey(dropId +"inner"))) as DropdownButton).value,
          equals('XXX'));
    });


    testWidgets('Verify Toggle updates - long list with multiple refreshes', (WidgetTester tester) async {


      Stream<Map<String, dynamic>>? onValueChangeStream;
      final StreamController<Map<String, dynamic>> _onUserController =
      StreamController<Map<String, dynamic>>();
      String? valueAfterChange = "YES";
      String toggleValue = "YES";
      onValueChangeStream = _onUserController.stream.asBroadcastStream();
      String toggleId= "toggleId";
      final Map<String, dynamic> json = {
        "widgets": [
          {
            "id": toggleId,
            "name": "Toggle",
            "type": "toggle",
            "values": ["YES", "NO"],
            "chosen_value": "NO"
          },
        ]
      };
      for(int i = 0; i < 50; i++){
        json["widgets"].add ( {
          "id": "abc"+i.toString(),
          "name": "Edit text",
          "type": "edit_text",
          "chosen_value": i.toString(),
          "description": "(edit description..)",
        });
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json)
              .setStreamUpdates(onValueChangeStream)
              .setOnValueChanged((String id, dynamic value){
            valueAfterChange = value;
            return Future.value(true);
          }).build()),
        ),
      );
      await tester.pump();
      _onUserController.add({}..[toggleId] =
          valueAfterChange); //
      await tester.pump(const Duration(seconds: 5));


      Key scrollKey = const Key('scrollView');

      await tester.tap(find.text(toggleValue));
      await tester.pump(const Duration(seconds: 1));
      expect(null, valueAfterChange);


      await tester.drag(find.byKey(scrollKey), const Offset(0.0, -3000));
      await tester.pump(const Duration(seconds: 5));

      await tester.drag(find.byKey(scrollKey), const Offset(0.0, 3000));
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      await tester.tap(find.text(toggleValue));
      await tester.pump(const Duration(seconds: 5));
      expect("YES", valueAfterChange);

    });

  });

  testWidgets('Saveable edit text, Change value - long list with scroll', (WidgetTester tester) async {

    final Map<String, dynamic> json= {};
    json["widgets"] = [];
    for(int i = 0; i < 51; i++){
      json["widgets"].add ( {
        "id": "abc"+i.toString(),
        "name": "Edit text",
        "type": "edit_text",
        "chosen_value": "abc"+i.toString(),
        "description": "(edit description..)",
      });
    }


    await tester.pumpWidget(
      MaterialApp(
        home: Material(child: JsonFormWithThemeBuilder(jsonWidgets: json)
            .setSaveBarBuilderMethod(saveBarBuilder)
            .build()),
      ),
    );
    // Trigger a frame.
    await tester.pump();

    expect(find.text("abc0"), findsOneWidget);
    expect(find.text("abc50"), findsNothing);


    // FocusScope.of(tester.element(find.byKey(const ValueKey("abc0")))).requestFocus();
    FocusScope.of(await tester.element(find.byKey(const ValueKey("abc0")))).requestFocus();
    await tester.idle();
    await tester.pump();

    await tester.enterText(find.byKey(const ValueKey("abc0")), "test");


    await tester.drag(find.byKey(Key('scrollView')), const Offset(0.0, -6000));
    await tester.pump(const Duration(seconds: 5));


    expect(find.text('test'), findsNothing);
    expect(find.text("abc0"), findsNothing);
    expect(find.text("abc50"), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey("saveButton")));
    await tester.pump();

    await tester.drag(find.byKey(Key('scrollView')), const Offset(0.0, 6000));
    await tester.pump(const Duration(seconds: 5));
    expect(find.text("test"), findsOneWidget);
    expect(find.text("abc0"), findsNothing);
    expect(find.text("abc50"), findsNothing);
  });


}
