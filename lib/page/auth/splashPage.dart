import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invogen/main.dart';
import 'package:invogen/page/auth/loginPage.dart';
import 'package:invogen/page/dashboard/dashboard.dart';
import 'package:invogen/utilty/hiveDB.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  starttimer(){
    Future.delayed(Duration(seconds: 2)).then((value) => {
getdata()
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    starttimer();
  }
  
 getdata()async{
     var data=await HiveDB().fetchData('userInfo', 'user');
 if(data!=null){
  var jres= json.decode(data);
  temp.setUser(jres['data']['user']);
  temp.setToken(jres['data']['token']);
  print(jres['data']['token'].toString());
  Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_)=>Dashboard()));
 }else{
   Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_)=>LoginPage()));
 }

  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: col.themeColor,body: Container(
      width: 100.w,height: 100.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Expanded(child: Image(image: AssetImage('assets/logo.png'),width: 70.w,height: 8.h,),),
        Image(image: AssetImage('assets/pp.png'),width: 40.w,height: 5.h,)
      ],),
    ),);
  }
}