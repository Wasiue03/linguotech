// widgets/link_icon.dart
import 'package:flutter/material.dart';

class LinkIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.link),
        SizedBox(width: 5),
        Text(
          'Add link here',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
