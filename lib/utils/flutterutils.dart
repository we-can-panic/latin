import 'package:flutter/material.dart';

enum StyleType { vivid, normal, info }

Container stringToIcon(String content, {StyleType style = StyleType.normal}) {
  switch (style) {
    case StyleType.vivid:
      return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Colors.lightGreen,
        ),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 32,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    case StyleType.info:
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Colors.black45,
        ),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
      );
    case StyleType.normal:
    default:
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Text(
          content,
          style: const TextStyle(fontSize: 24, color: Colors.black),
        ),
      );
  }
}

Future<List<String>> selectItems(BuildContext context, List<String> items,
    List<String> beforeSelectedItems, String title) async {
  List<String> selectedItems = List.from(beforeSelectedItems);

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: items.map((item) {
                bool isSelected = selectedItems.contains(item);
                return CheckboxListTile(
                  title: Text(item),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null && value) {
                        selectedItems.add(item);
                      } else {
                        selectedItems.remove(item);
                      }
                    });
                  },
                );
              }).toList(),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(selectedItems);
            },
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop([]);
              selectedItems = beforeSelectedItems;
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );

  return selectedItems;
}

Future<String> selectItem(BuildContext context, List<String> items,
    String beforeSelectedItem, String title) async {
  // ignore: no_leading_underscores_for_local_identifiers
  String selectedItem = beforeSelectedItem;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: items.map((item) {
                return RadioListTile<String>(
                  title: Text(item),
                  value: item,
                  groupValue: selectedItem,
                  onChanged: (String? value) {
                    setState(() {
                      selectedItem = value!;
                    });
                  },
                );
              }).toList(),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(selectedItem);
            },
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop([]);
              selectedItem = beforeSelectedItem;
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );

  return selectedItem;
}

Future<void> showAlertDialog(
    BuildContext context, String title, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // ユーザーがダイアログ外をタップして閉じるのを防ぐ
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // ダイアログを閉じる
            },
          ),
        ],
      );
    },
  );
}
