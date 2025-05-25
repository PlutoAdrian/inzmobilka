import 'package:flutter/material.dart';
import 'package:pluto_apk/models/session.dart';

class SessionItem extends StatelessWidget {
  final Session session;
  final Function() onDelete;
  final Function()? onTap;
  const SessionItem({
    super.key,
    required this.session,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        session.child,
      ),
      onTap: onTap,
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}