import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pluto_apk/models/user.dart';
import 'package:pluto_apk/Worker/scanner.dart';
import 'package:pluto_apk/services/auth.dart';
import 'package:pluto_apk/wrapper.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserUID?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          )
        ),
        home: Wrapper(),
        debugShowCheckedModeBanner: false,
        title: 'Login',
      ),
    );
  }
}
