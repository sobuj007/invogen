import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invogen/main.dart';
import 'package:invogen/page/customWidget/customPassword.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

class SingUp extends StatefulWidget {
  const SingUp({super.key});

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  TextEditingController email = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController pass = TextEditingController();
  
  TextEditingController confPass = TextEditingController();
  bool tremConditon = false;
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
                    Row(
                      children: [
                        IconButton(onPressed: (){
Navigator.pop(context);
                        }, icon: Icon(Icons.arrow_back,color: col.whites,)),
                        Image(
                          image: AssetImage('assets/logo.png'),
                          width: 30.w,
                          height: 8.h,
                        ),
                      ],
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
                              sheet.logindeco("jhon Deo", "FullName")),
                    ),
                     SizedBox(
                      height: 1.h,
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
                   CustomPassword(label: "Password",hint: "XXX-XXX",),
                    SizedBox(
                      height: 1.h,
                    ),
                   CustomPassword(label: "Confirm Password",hint: "XXX-XXX",),
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
                                value: tremConditon,
                                onChanged: (v) {
                                  tremConditon = v!;
                                  setState(() {});
                                }),
                            Text(
                              'Accept Trems & Condition ',
                              style: fonts.h7semibold(col.whites),
                            )
                          ],
                        ),
                      
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    GestureDetector(
                        onTap: () {
                          if(email.text.isNotEmpty &&pass.text.isNotEmpty &&fullname.text.isNotEmpty&&confPass.text.isNotEmpty){
                            userSignUp();
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
                              'SignUp',
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
            Navigator.pop(context);
          },
            child: RichText(
              text: TextSpan(
                  text: "Already have account ! ",
                  style: fonts.h7semibold(col.whites),
                  children: [
                    TextSpan(
                      text: " Login",
                      style: fonts.h3bold(col.whites),
                    )
                  ]),
            ),
          ),
        ));
  }

  userSignUp() async {
    sheet.loaders(context);

    var headersList = {'Accept': 'application/json'};
    var url = Uri.parse('https://invogen.cosmeticplugs.com/api/register');

    var body = {
      'email': email.text.toString(),
      'password': pass.text.toString(),
      'name': fullname.text.toString(),
      'password_confirmation': confPass.text.toString()
    };

    var req = http.MultipartRequest('POST', url);
    req.headers.addAll(headersList);
    req.fields.addAll(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      Navigator.pop(context);
      sheet.showSucessTost(context, "Succesfully Login");
    } else {
      print(res.reasonPhrase);
        Navigator.pop(context);
       sheet.showSucessTost(context, "somting worng");

    }
  }
}
