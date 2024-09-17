import 'dart:io';

import 'package:chat_with_notif/widget/user_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final _firebaseAuth = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _enteredEmail = "";
  String _enteredPassword = "";
  File? _selectedImage;
  bool _isAuthenticating = false;

  bool _isLogin = false;
  void _submit() async {
    if (_formKey.currentState!.validate() ||
        _isLogin && _selectedImage != null) {
      _formKey.currentState!.save();
    }
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
                email: _enteredEmail, password: _enteredPassword);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_profile')
            .child('${userCredential.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = storageRef.getDownloadURL();
        print(imageUrl);
      }

      setState(() {
        _isAuthenticating = false;
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Authentication failed")));
    }
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
                          if (!_isLogin)
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                _selectedImage = pickedImage;
                              },
                            ),
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
                          if (!_isAuthenticating)
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
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating)
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
