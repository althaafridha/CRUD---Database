import 'dart:convert';
import 'package:crud_database/constant/url.dart';

import 'package:crud_database/screens/home/home_screen.dart';
import 'package:crud_database/screens/register/register_screen.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

enum LoginStatus { notSignin, signIn }

class _LoginViewState extends State<LoginView> {
  bool _securedText = true;
  final _key = new GlobalKey<FormState>();
  bool _isLoading = false;

  LoginStatus _loginStatus = LoginStatus.notSignin;
  late String? email, password;

  showHide() {
    setState(() {
      _securedText = !_securedText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    var url = Uri.parse(BaseUrl.login);
    final response = await http.post(url, body: {
      "email": email,
      "password": password,
    });
    final data = jsonDecode(response.body);

    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['nama'];
    String emailAPI = data['email'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, usernameAPI, emailAPI);
      });
      print(pesan);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Berhasil'),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      print(pesan);
    }
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignin;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  savePref(int value, String username, String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("nama", username);
      preferences.setString("email", email);
      preferences.commit();
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      preferences.commit();
      _loginStatus = LoginStatus.notSignin;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignin:
        return Scaffold(
            body: Form(
          key: _key,
          child: Center(
            child: SingleChildScrollView(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Silahkan login untuk melanjutkan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
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
                              decoration: InputDecoration(
                                hintText: 'Email',
                                fillColor: const Color(0xffF2F2F2),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none)),
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
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
                                hintText: 'Password',
                                fillColor: const Color(0xffF2F2F2),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none)),
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
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue),
                                child: const Text('Login'),
                              )),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Belum punya akun?',
                              style: TextStyle(
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
                                          builder: (context) =>
                                              const RegisterPage()));
                                },
                                child: const Text(
                                  ' Register',
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
        ));
      case LoginStatus.signIn:
        return HomePage(
          signOut,
        );
    }
  }
}
