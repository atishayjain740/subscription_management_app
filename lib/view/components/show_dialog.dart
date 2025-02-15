import 'package:flutter/material.dart';

void showMessageDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: Text("Alert", style: Theme.of(context).textTheme.displayLarge),
        content: Text(message, style: Theme.of(context).textTheme.bodyLarge),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK",
                style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      );
    },
  );
}
