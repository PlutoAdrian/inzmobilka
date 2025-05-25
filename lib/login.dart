import 'package:flutter/material.dart';
import 'package:pluto_apk/global/global.dart';
import 'package:pluto_apk/services/auth.dart';

class Login extends StatefulWidget {

  final Function? toggleView;
  const Login({super.key,  this.toggleView });

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            colors: [
              Colors.blueAccent,
              Colors.lightBlueAccent.shade100,
            ]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Padding(padding: EdgeInsets.all(20),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Wirtualna świetlica", style: TextStyle(color: Colors.white, fontSize: 55),),
              SizedBox(height: 10,),
              Text("Logowanie", style: TextStyle(color: Colors.white70, fontSize: 23),)
            ],  
            ),
            ),
            SizedBox(height: 150,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10,),
                          Container(
                            padding: const EdgeInsets.only(left: 50,right: 50),
                            child: TextFormField(
                              validator: (val) => val!.isEmpty ? 'Wpisz email' : null,
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
                            padding: const EdgeInsets.only(left: 50,right: 50),
                            child: TextFormField(
                              validator: (val) => val!.isEmpty ? 'Wpisz hasło' : null,
                              onChanged: (val){
                                setState(() => password = val);
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                  labelText: "Hasło"
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          ElevatedButton(
                              onPressed: () async {
                                if(_formKey.currentState!.validate()){
                                  globalEmail = email;
                                  dynamic result = await _auth.signInWithEmail(email, password);
                                  if(result == null){
                                    setState(() => error = 'Nieprawidłowy email lub hasło');
                                  }
                                }
                              },
                              child:  Text('Zaloguj')),
                          SizedBox(height: 10,),
                          ElevatedButton(
                              onPressed: (){widget.toggleView!();},
                              child: Text('Zarejestruj')),

                          const SizedBox(height: 10.0,),
                          Text(error,style: const TextStyle(color: Colors.red, fontSize: 14),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
