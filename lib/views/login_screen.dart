import 'package:evaluation_amgmiot/services/get_api.dart';
import 'package:evaluation_amgmiot/utilities/global.dart';
import 'package:evaluation_amgmiot/views/dashboard_screen.dart';
import 'package:flutter/material.dart';
import '../utilities/utilities.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [gradient1, gradient2],
              stops: [0.6, 0.95],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter),
        ),
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15,
                top: MediaQuery.of(context).size.height * 0.08,
              ),
              child: Center(
                child: Image.asset(
                  'lib/assets/images/amgmiot_logo.png',
                  scale: 1.5,
                ),
              ),
            ),
            const Text(
              'Login',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const Text(
              'User name',
              style: TextStyle(fontSize: 23),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white)),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.02,
                  ),
                  child: TextField(
                    controller: usernameController,
                    style: const TextStyle(fontSize: 25),
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const Text(
              'Password',
              style: TextStyle(fontSize: 23),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white)),
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.02,
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: _isObscure,
                  obscuringCharacter: "*",
                  style: const TextStyle(fontSize: 25),
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    suffix: IconButton(
                      padding: const EdgeInsets.all(0),
                      iconSize: 20.0,
                      icon: _isObscure
                          ? const Icon(
                              Icons.visibility_off,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.visibility,
                              color: Colors.white,
                            ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String uname = usernameController.text;
                  String pass = passwordController.text;

                  String result = await ApiDataService().getStringDataFromApi(
                      "Login?username=$uname&password=$pass");

                  if (result == "valid") {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return const DashboardScreen();
                      }),
                    );
                  } else {
                    showSnackBar(
                        context, "Invalid credentials! Please try again.");
                    usernameController.clear();
                    passwordController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: gradient2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 21),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.03,
                ),
                child: const Text(
                  'APP VERSION 0.1',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
