import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Step2 extends StatefulWidget {
  Step2({Key? key, required this.verificationId, required this.phoneNumber})
      : super(key: key);

  final String verificationId;
  final String phoneNumber;

  @override
  _Step2State createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  TextEditingController codeField = TextEditingController();

  void verifySmsCode() async {
    if (codeField.text.isEmpty) {
      // Mostrar mensagem usuario
      return;
    }

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: codeField.text,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    print(userCredential.additionalUserInfo);
    print(userCredential.user);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.verificationId);
    print(widget.phoneNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text('Confirme o codigo sms'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: codeField,
                decoration: InputDecoration(
                  labelText: 'Digite o código SMS',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: verifySmsCode,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
