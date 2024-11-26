import 'package:flutter/material.dart';
import 'package:pluto_apk/global/global.dart';
import 'package:pluto_apk/services/auth.dart';
import 'package:pluto_apk/services/database.dart';

import '../home.dart';

class AddChild extends StatefulWidget {
  const AddChild({super.key});

  @override
  State<AddChild> createState() => _AddChildState();
}

class _AddChildState extends State<AddChild> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Add a child"),
          //actions: <Widget>[
           // ElevatedButton.icon(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));}, icon: Icon(Icons.arrow_back), label: Text('Home'))
          //],
        ),
        body: Center(
          child:Form(
              key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: TextFormField(
                        validator: (val) => val!.isEmpty ? 'Enter a name' : null,
                        onChanged: (val){
                        setState(() => name = val);
                                  },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                          labelText: 'Name'),
                   )
                  ),
                    ElevatedButton(
                        onPressed: () async {
                          if(_formKey.currentState!.validate()){
                            //dynamic result = await _auth.signInWithEmail(email, password);
                            await DatabaseService(uid: " ").AddAChild(name, globalUID!);
                          }
                        },
                        child: Text('Add')),
                  ],
            ),

        ),
      ),
    );
  }
}
