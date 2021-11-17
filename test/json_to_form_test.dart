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
            "chosen_value": 1
          },
        ]
      };
      // Build the Chat widget.
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithTheme(jsonWidgets: json)),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      // Expect to find one ImageMessage
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
      // Build the Chat widget.
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithTheme(jsonWidgets: json)),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      // Expect to find one ImageMessage
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
      // Build the Chat widget.
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithTheme(jsonWidgets: json)),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      // Expect to find one ImageMessage
      expect(find.byType(Toggle), findsNothing);
      expect(find.byType(EditTextValue), findsNothing);
      expect(find.byType(Header), findsNothing);
      expect(find.byType(StaticTextValue), findsOneWidget);
      expect(find.byType(DropDownWidget), findsNothing);
    });
    testWidgets('Verify edit dropdown', (WidgetTester tester) async {
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
      // Build the Chat widget.
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithTheme(jsonWidgets: json)),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      // Expect to find one ImageMessage
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
      // Build the Chat widget.
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithTheme(jsonWidgets: json)),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      // Expect to find one ImageMessage
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
      // Build the Chat widget.
      await tester.pumpWidget(
        MaterialApp(
          home: Material(child: JsonFormWithTheme(jsonWidgets: json)),
        ),
      );
      // Trigger a frame.
      await tester.pump();
      // Expect to find one ImageMessage
      expect(tester.takeException(), isInstanceOf<ParsingException>());
    });
  });
}
