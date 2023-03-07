import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback signOut;

  const ProfilePage({required this.signOut});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "username : $username",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "email : $email",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: () {
                _signOut();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  var username, email;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("nama");
      email = preferences.getString("email");
    });
  }

  _signOut() {
    setState(() {
      widget.signOut();
    });
  }
}
