import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../main.dart';
class CustomPassword extends StatefulWidget {
  final tcontroler;
  final label;
  final hint;
   CustomPassword({this.tcontroler,this.label,this.hint,super.key});

  @override
  State<CustomPassword> createState() => _CustomPasswordState();
}

class _CustomPasswordState extends State<CustomPassword> {
  bool showPass=true;
  @override
  Widget build(BuildContext context) {
    return  Container(
                      height: 7.h,
                      width: 100.w,
                      child: TextField(
                        obscureText: showPass, 
                        style: fonts.h6semibold(col.whites),
                          controller:widget.tcontroler,
                          decoration: InputDecoration(
    suffixIcon:IconButton(onPressed: (){
      setState(() {
        if(showPass==true){
          showPass=false;
        }else{
          showPass=true;
        }
      });
    }, icon: Icon(showPass?Icons.visibility_off:Icons.visibility)) ,
      contentPadding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: .8.h),
      hintText: widget.hint,
      labelText: widget.label.toString(),
      labelStyle: fonts.h6semibold(col.themeAlter),
     
      hintStyle: fonts.h6semibold(col.hintcol),
      border: OutlineInputBorder(
        
          borderSide: BorderSide(width: 1.0, color: col.themeAlter)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: .8, color: col.themeAlter)))),
                    );
  }
}