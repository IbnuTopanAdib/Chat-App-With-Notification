import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredEmail = "";
  String _enteredPassword = "";

  bool _isLogin = false;
  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    print(_enteredEmail);
    print(_enteredPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 200,
              margin: const EdgeInsets.fromLTRB(30, 20, 20, 20),
              child: Image.asset('assets/image/logo.png'),
            ),
            Card(
              elevation: 8,
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().length < 6 ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _enteredEmail = newValue!;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              if (value.trim().length < 6) {
                                return 'Password harus minimal 6 karakter';
                              }
                              if (!RegExp(r'[0-9]').hasMatch(value)) {
                                return 'Password harus mengandung setidaknya satu angka';
                              }
                              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                return 'Password harus mengandung setidaknya satu huruf besar';
                              }
                              if (!RegExp(r'[a-z]').hasMatch(value)) {
                                return 'Password harus mengandung setidaknya satu huruf kecil';
                              }
                              return null; // Jika semua validasi lolos
                            },
                            onSaved: (newValue) {
                              _enteredPassword = newValue!;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    shape: const BeveledRectangleBorder()),
                                onPressed: _submit,
                                child: Text(_isLogin ? 'Login' : 'Signup')),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Create an aaccount'
                                  : 'I already have an account'))
                        ],
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
