import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('popupover Mention Example')),
      body: Center(
        child: Popover(
          trigger: const Text('Press me'),

          text: '@example_user example_user example_user',
          placement: Placement.topEnd, // Thay đổi vị trí tại đây
        ),
      ),
    ),
  ));
}
