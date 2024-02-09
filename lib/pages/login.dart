import 'package:flutter/material.dart';
import 'package:message_app/models/user.dart';
import 'package:message_app/pages/createAccount.dart';
import 'package:message_app/pages/menu.dart';
import 'package:message_app/repositories/user_repository.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    User? user = await UserRepository.login(username, password);

    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Menu(user: user),
        ),
      );
    } else {
      // Handle login failure
    }
  }

  void _goToSignUp() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccount(),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Dark Chat',
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                height: MediaQuery.of(context).size.height * 0.15,
                child: Image.asset('assets/images/black-cat.png'),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                  ),
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: _goToSignUp,
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
