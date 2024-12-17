import 'package:flutter/material.dart';
import 'package:pluto_apk/models/event.dart';
import 'package:pluto_apk/models/session.dart';

class SessionWork extends StatelessWidget {
  final Session session;
  final Function()? onTap;
  const SessionWork({
    Key? key,
    required this.session,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        session.child,
      ),
      onTap: onTap,
    );
  }
}