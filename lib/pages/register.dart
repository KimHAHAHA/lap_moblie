import 'dart:developer' show log;

import 'package:app_6/config/internal_config.dart';
import 'package:app_6/model/request/customer_register_post_req.dart';
import 'package:app_6/model/response/customer_register_post_res.dart';
import 'package:app_6/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var fullnameCtl = TextEditingController();
  var phoneNoCtl = TextEditingController();
  var emailCtl = TextEditingController();
  var passwordCtl = TextEditingController();
  var confirmpwCtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ลงทะเบียนสมาชิกใหม่')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ชื่อ-นามสกุล", style: TextStyle(fontSize: 20)),
                SizedBox(height: 8),
                TextField(
                  controller: fullnameCtl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("หมายเลขโทรศัพท์", style: TextStyle(fontSize: 20)),
                SizedBox(height: 8),
                TextField(
                  controller: phoneNoCtl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("อีเมล์", style: TextStyle(fontSize: 20)),
                SizedBox(height: 8),
                TextField(
                  controller: emailCtl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("รหัสผ่าน", style: TextStyle(fontSize: 20)),
                SizedBox(height: 8),
                TextField(
                  controller: passwordCtl,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ยืนยันรหัสผ่าน", style: TextStyle(fontSize: 20)),
                SizedBox(height: 8),
                TextField(
                  controller: confirmpwCtl,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () => register(),
                child: const Text('สมัครสมาชิก'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'หากมีบัญชีอยู่แล้ว?',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void register() {
    if (fullnameCtl.text.isNotEmpty &&
        phoneNoCtl.text.isNotEmpty &&
        emailCtl.text.isNotEmpty &&
        passwordCtl.text.isNotEmpty) {
      if (passwordCtl.text == confirmpwCtl.text) {
        var data = CustomerRegisterPostRequest(
          fullname: fullnameCtl.text,
          phone: phoneNoCtl.text,
          email: emailCtl.text,
          image: "",
          password: passwordCtl.text,
        );
        http
            .post(
              Uri.parse("$API_ENDPOINT/customers"),
              headers: {"Content-Type": "application/json; charset=utf-8"},
              body: customerRegisterPostRequestToJson(data),
            )
            .then((value) {
              var res = customerRegisterPostResponseFromJson(value.body);
              log(res.message);
              log(res.id.toString());
            })
            .catchError((error) {
              log('Error $error');
            });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        log("password and confirm password is not equals");
      }
    } else {
      log("Fields MUST be empty");
    }
  }
}
