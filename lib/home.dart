import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'step2.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController phoneField = TextEditingController();

  void sendSmsCode() async {
    if (phoneField.text.isEmpty) {
      // Mostrar mensagem usuario
      return;
    }

    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneField.text,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException authException) {
        print(authException.code);
        print(authException.message);
      },
      codeSent: (String verificationId, int? timeout) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Step2(
            verificationId: verificationId,
            phoneNumber: phoneField.text,
          ),
        ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: phoneField,
                decoration: InputDecoration(
                  labelText: 'Digite seu telefone',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendSmsCode,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
