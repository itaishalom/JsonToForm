import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_to_form_with_theme/exceptions/parsing_exception.dart';

import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/widgets/drop_down_widget.dart';
import 'package:json_to_form_with_theme/widgets/edit_text_value.dart';
import 'package:json_to_form_with_theme/widgets/header.dart';
import 'package:json_to_form_with_theme/widgets/static_text_value.dart';
import 'package:json_to_form_with_theme/widgets/toggle.dart';

void main() {
  group("Widget tests:", () {
    testWidgets('Verify toggle', (WidgetTester tester) async {
      final Map<String, dynamic> json = {
        "widgets": [
          {
            "id": "1",
            "name": "Toggle",
            "type": "toggle",
            "values": ["On", "Off"],
            "chosen_value": "Off"
          },
        ]
      };
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithTheme(jsonWidgets: json)),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      expect(find.byType(Toggle), findsOneWidget);
      expect(find.byType(EditTextValue), findsNothing);
      expect(find.byType(Header), findsNothing);
      expect(find.byType(DropDownWidget), findsNothing);
    });
    testWidgets('Verify edit text', (WidgetTester tester) async {
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
          home: Material(child: JsonFormWithTheme(jsonWidgets: json)),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      expect(find.byType(Toggle), findsNothing);
      expect(find.byType(EditTextValue), findsOneWidget);
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
          home: Material(child: JsonFormWithTheme(jsonWidgets: json)),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      expect(find.byType(Toggle), findsNothing);
      expect(find.byType(EditTextValue), findsNothing);
      expect(find.byType(Header), findsNothing);
      expect(find.byType(StaticTextValue), findsOneWidget);
      expect(find.byType(DropDownWidget), findsNothing);
    });
    testWidgets('Verify dropdown', (WidgetTester tester) async {
      final Map<String, dynamic> json = {
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
          home: Material(child: JsonFormWithTheme(jsonWidgets: json)),
        ),
      );
      await tester.pump();
      expect(find.byType(Toggle), findsNothing);
      expect(find.byType(EditTextValue), findsNothing);
      expect(find.byType(Header), findsNothing);
      expect(find.byType(StaticTextValue), findsNothing);
      expect(find.byType(DropDownWidget), findsOneWidget);
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
          home: Material(child: JsonFormWithTheme(jsonWidgets: json)),
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
          home: Material(child: JsonFormWithTheme(jsonWidgets: json)),
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
          home: Material(child: JsonFormWithTheme(jsonWidgets: json, onValueChanged: (String id, dynamic value){
            valueAfterChange = value;
            return Future.value(true);
          },)),
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
          home: Material(child: JsonFormWithTheme(jsonWidgets: json, onValueChanged: (String id, dynamic value){
            valueAfterChange = value;
            return Future.value(true);
          },)),
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
          home: Material(child: JsonFormWithTheme(jsonWidgets: json, onValueChanged: (String id, dynamic value){
            valueAfterChange = value;
            return Future.value(true);
          },)),
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
          home: Material(child: JsonFormWithTheme(jsonWidgets: json, streamUpdates: onValueChangeStream)),
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
      String valueAfterChange = "MoroDoro";
      String valueAfterChangeCut = "MoroD..";
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
          home: Material(child: JsonFormWithTheme(jsonWidgets: json, streamUpdates: onValueChangeStream)),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      _onUserController.add({}..["3"] =
          valueAfterChange); // toggle


      await tester.pump(const Duration(seconds: 5));
      final findText = find.text(valueAfterChangeCut);
     // debugDumpApp();
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
          home: Material(child: JsonFormWithTheme(jsonWidgets: json, streamUpdates: onValueChangeStream)),
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
      await tester.drag(find.byKey(Key('scrollView')), const Offset(0.0, -3000));
      await tester.pump(const Duration(seconds: 5));

      expect(find.text("51"), findsOneWidget);
      await tester.drag(find.byKey(Key('scrollView')), const Offset(0.0, 3000));
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
          home: Material(child: JsonFormWithTheme(streamUpdates: onValueChangeStream, jsonWidgets: json, onValueChanged: (String id, dynamic value){
            valueAfterChange = value;
            return Future.value(true);
          },)),
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
  });
}
