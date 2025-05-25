import 'package:flutter/material.dart';
import 'package:pluto_apk/services/auth.dart';

import 'global/global.dart';

class Register extends StatefulWidget {

  final Function? toggleView;
  const Register({super.key,  this.toggleView });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register"),
        actions: <Widget>[
          ElevatedButton.icon(onPressed: (){widget.toggleView!();}, icon: const Icon(Icons.person), label: const Text('Login'))
        ],),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: TextFormField(
                    validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                    onChanged: (val){
                      setState(() => email = val);
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        labelText: "Email"
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.only(left: 10,right: 10),
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
                        dynamic result = await _auth.registerWithEmail(email, password);
                        if(result == null){
                          setState(() => error = 'Invalid email or password');
                        }
                      }
                    },
                    child: const Text('Register')),
                const SizedBox(height: 10.0,),
                Text(error,style: const TextStyle(color: Colors.red, fontSize: 14),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
