<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

This library aims to help developer get started quickly and create a form made out of json.


## Features

The JsonForm can be updated both from the user interaction but can also be notified from outside
(check the example for the stream). You can also get the Json back.

## Usage
You can declare a Json as:
```dart
  final Map<String, dynamic> json = {
    "widgets": [
      {
        "id": "1",
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },
      {
        "id": "2",
        "name": "Static text",
        "type": "static_text",
        "chosen_value": "value",
        "description": "(description..)",
      },
      {
        "id": "3",
        "name": "Edit text",
        "type": "edit_text",
        "chosen_value": "edit value",
        "description": "(edit description..)",
      },
      {"type": "header", "name": "Header", "id": "99"},
      {
        "id": "4",
        "name": "Drop down",
        "type": "drop_down",
        "values": ["Low-Intermediate", "Medium", "High"],
        "chosen_value": "Low-Intermediate"
      }
    ]
  };
```

And easily use the basic Theme (or edit it)

```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Action Button'),
      ),
      body: JsonForm(onValueChange, map: widget.json,
          onValueChanged: (String d, dynamic s) {
           // Do something with the data
      }, theme: const DefaultTheme()),
      /*form?.getForm(context),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter++;
          if (counter % 4 == 1) {
            toggle++;
            _onUserController.add({}..["1"] = toggle % 2); // toggle
          }
          if (counter % 4 == 2) {
            _onUserController.add({}..["2"] =
                "updated" + Random().nextInt(10).toString()); // toggle
          }
          if (counter % 4 == 3) {
            _onUserController.add({}..["3"] =
                "editUp" + Random().nextInt(10).toString()); // toggle
          }
          if (counter % 4 == 0) {
            _onUserController.add({}..["4"] = list[toggle % 2]); // toggle
          }
        },
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.green,
      ),
    );
```
<p align="center">
  <img src="https://github.com/itaishalom/JsonToForm/blob/main/screen_shot.jpg" width="350">
</p>


## Additional information

contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
# JsonToFormWithTheme
