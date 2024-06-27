import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pluto_apk/authenticate.dart';
import 'package:pluto_apk/global/global.dart';
import 'package:pluto_apk/home.dart';
import 'package:pluto_apk/login.dart';
import 'package:pluto_apk/models/user.dart';
import 'package:pluto_apk/usertype.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserUID?>(context);
    if (user == null) {
      return Authenticate();
    }else{
      globalUID = user.getUID();
      return UserType();
    }
  }
}
