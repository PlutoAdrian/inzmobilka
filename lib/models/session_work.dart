import 'package:flutter/material.dart';
import 'package:pluto_apk/models/session.dart';

class SessionWork extends StatelessWidget {
  final Session session;
  final Function()? onTap;
  const SessionWork({
    super.key,
    required this.session,
    this.onTap,
  });

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