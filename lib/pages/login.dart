import 'dart:developer' show log;

import 'package:app_6/config/config.dart';
import 'package:app_6/config/internal_config.dart';
import 'package:app_6/model/request/customer_login_post_req.dart';
import 'package:app_6/model/response/customer_login_post_res.dart';
import 'package:app_6/pages/register.dart';
import 'package:app_6/pages/showtrip.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int number = 0;
  String phoneNo = '';
  var phoneNoCtl = TextEditingController();
  var passwordCtl = TextEditingController();
  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Image.asset('assets/images/2.PNG'),
            ),
            Column(
              children: [
                SizedBox(width: 20, height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    children: [
                      Text(
                        "หมายเลขโทรศัพท์",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    controller: phoneNoCtl,
                    // onChanged: (value) {
                    //   phoneNo = value;
                    // },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20, height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    children: [
                      Text(
                        "รหัสผ่าน",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: TextField(
                    controller: passwordCtl,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => register(),
                        child: const Text('ลงทะเบียน'),
                      ),
                      FilledButton(
                        onPressed: () => login(),
                        child: const Text("เข้าสู่ระบบ"),
                      ),
                    ],
                  ),
                ),
                Text(text, style: TextStyle(fontSize: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void login() async {
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
      phone: phoneNoCtl.text,
      password: passwordCtl.text,
    );

    http
        .post(
          Uri.parse("$API_ENDPOINT/customers/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginPostRequestToJson(req),
        )
        .then((value) {
          log(value.body);
          var customerLoginPostResponse = customerLoginPostResponseFromJson(
            value.body,
          );
          log(customerLoginPostResponse.customer.fullname);
          log(customerLoginPostResponse.customer.email);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ShowTripPage(cid: customerLoginPostResponse.customer.idx),
            ),
          );
        })
        .catchError((error) {
          log('Error $error');
        });
  }
}
