import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invogen/main.dart';
import 'package:invogen/page/auth/signUp.dart';
import 'package:invogen/page/customWidget/customPassword.dart';
import 'package:invogen/page/dashboard/dashboard.dart';
import 'package:invogen/utilty/hiveDB.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool isRemember = false;
  @override
  void initState() {
    super.initState();
   //getdata();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: col.themeColor,
        body: Container(
          height: 100.h,
          width: 100.w,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      image: AssetImage('assets/logo.png'),
                      width: 30.w,
                      height: 8.h,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generate',
                          style: fonts.custom(
                              col.whites, 35.0, FontWeight.bold, 1.0),
                        ),
                        Text(
                          'Your invoice',
                          style: fonts.custom(
                              col.whites, 35.0, FontWeight.bold, 1.0),
                        ),
                        Row(
                          children: [
                            Text(
                              'with ',
                              style: fonts.custom(
                                  col.whites, 35.0, FontWeight.bold, 1.0),
                            ),
                            Image(
                              image: AssetImage('assets/InvoGen.png'),
                              width: 45.w,
                              height: 8.h,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    Container(
                      height: 7.h,
                      width: 100.w,
                      child: TextField(
                         style: fonts.h6semibold(col.whites),
                          controller: email,
                          cursorColor: col.whites,
                          decoration:
                              sheet.logindeco("example@gmail.com", "Email")),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                   CustomPassword(label: "Password",hint: "XXX-XXX",tcontroler: 
                   pass,),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                side:
                                    BorderSide(width: 1.0, color: col.themeAlter),
                                fillColor:
                                    MaterialStatePropertyAll(col.themeAlter),
                                value: isRemember,
                                onChanged: (v) {
                                  isRemember = v!;
                                  setState(() {});
                                }),
                            Text(
                              'Remember me ! ',
                              style: fonts.h7semibold(col.whites),
                            )
                          ],
                        ),
                        Text(
                          'Forget Password ?',
                          style: fonts.h7semibold(col.whites),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    GestureDetector(
                        onTap: () {
                          if(email.text.isNotEmpty &&pass.text.isNotEmpty){
                            userLogin();
                          }else{
                            sheet.showWarningTost(context, "Field can't be empty");
                          }
                          
                        },
                        child: Container(
                            width: 100.w,
                            height: 6.h,
                            color: col.themeAlter,
                            alignment: Alignment.center,
                            child: Text(
                              'Login',
                              style: fonts.h3semibold(col.whites),
                            )))
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: 100.w,
          height: 6.h,
          alignment: Alignment.center,
          child: GestureDetector(onTap: (){
            Navigator.push(context, CupertinoPageRoute(builder: (_)=>SingUp()));
          },
            child: RichText(
              text: TextSpan(
                  text: "Don't have account ? ",
                  style: fonts.h7semibold(col.whites),
                  children: [
                    TextSpan(
                      text: " SignUp",
                      style: fonts.h3bold(col.whites),
                    )
                  ]),
            ),
          ),
        ));
  }

  userLogin() async {
    sheet.loaders(context);

    var headersList = {'Accept': 'application/json'};
    var url = Uri.parse('https://invogen.cosmeticplugs.com/api/login');

    var body = {
      'email': email.text.toString(),
      'password': pass.text.toString()
    };

    var req = http.MultipartRequest('POST', url);
    req.headers.addAll(headersList);
    req.fields.addAll(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      HiveDB().storeData("userInfo", 'user',resBody);
      Navigator.pop(context);
      sheet.showSucessTost(context, "data recive");
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_)=>Dashboard()));
    } else {
      print(res.reasonPhrase);
        Navigator.pop(context);
       sheet.showSucessTost(context, "somting worng");

    }
  }
}
