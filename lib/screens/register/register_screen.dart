import 'dart:convert';

import 'package:crud_database/constant/url.dart';
import 'package:crud_database/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String email, password, username;
  final _key = new GlobalKey<FormState>();

  bool _securedText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _key,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Silahkan buat akun untuk melanjutkan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xffF2F2F2),
                            ),
                    child: TextFormField(
                      onSaved: (e) => username = e!,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Please Insert Username";
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        border: InputBorder.none
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xffF2F2F2),
                            ),
                    child: TextFormField(
                      onSaved: (e) => email = e!,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Please Insert Email";
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        border: InputBorder.none
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xffF2F2F2),
                            ),
                    child: TextFormField(
                      onSaved: (e) => password = e!,
                      obscureText: _securedText,
                      validator: (e) {
                        if (e!.isEmpty) {
                          return "Please Insert password";
                        }
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: showHide,
                            icon: Icon(_securedText
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: check,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Text('Register'),
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sudah punya akun?', style: TextStyle(
                        fontSize: 16,
                      ),),
                      const SizedBox(
                        width: 2.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginView()));
                        },
                        child: const Text(
                          ' Login',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showHide() {
    setState(() {
      _securedText = !_securedText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      save();
    }
    ;
  }

  save() async {
    var url = Uri.parse(BaseUrl.register);
    final response = await http.post(url, body: {
      "nama": username,
      "email": email,
      "password": password,
    });
    final data = jsonDecode(response.body);
    int value = data["value"] ?? 0;
    String pesan = data["message"];
    if (value == 1) {
      print(pesan);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Register berhasil! Silahkan login'),
          backgroundColor: Colors.grey,
        ),
      );
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print(pesan);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Register gagal!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
