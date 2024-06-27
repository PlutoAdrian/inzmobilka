import 'package:flutter/material.dart';
import 'package:pluto_apk/global/global.dart';
import 'package:pluto_apk/Worker/scanner.dart';
import 'package:pluto_apk/services/auth.dart';

class Login extends StatefulWidget {

  final Function? toggleView;
  Login({ this.toggleView });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        actions: <Widget>[
          ElevatedButton.icon(onPressed: (){widget.toggleView!();}, icon: Icon(Icons.person), label: Text('Register'))
        ],

      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: TextFormField(
                    validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                    onChanged: (val){
                      setState(() => email = val);
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        labelText: "Login"
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: TextFormField(
                    validator: (val) => val!.isEmpty ? 'Enter a password' : null,
                    onChanged: (val){
                      setState(() => password = val);
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        labelText: "Password"
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        globalEmail = email;
                        dynamic result = await _auth.signInWithEmail(email, password);
                        if(result == null){
                          setState(() => error = 'Invalid email or password');
                        }
                      }
                    },
                    child: Text('Login')),
                SizedBox(height: 10.0,),
                Text(error,style: TextStyle(color: Colors.red, fontSize: 14),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
