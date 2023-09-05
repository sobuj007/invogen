import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../main.dart';

class Styles {
  logindeco(hint, label) => InputDecoration(
    
      contentPadding: EdgeInsets.symmetric(horizontal: 4.0.w, vertical: .8.h),
      hintText: hint,
      labelText: label.toString(),
      labelStyle: fonts.h6semibold(col.themeAlter),
     
      hintStyle: fonts.h6semibold(col.hintcol),
      border: OutlineInputBorder(
        
          borderSide: BorderSide(width: 1.0, color: col.themeAlter)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: .8, color: col.themeAlter)));
  loaders(context) {
    return showCupertinoDialog(
        context: context,
        builder: (_) => Container(
              height: 100.h,
              width: 100.w,
              color: col.themeColor,
              child: Center(
                child:
                    CupertinoActivityIndicator(color: col.whites, radius: 22.0),
              ),
            ));
  }
  loaders2(context) {
     showCupertinoDialog(
        context: context,
        builder: (_) => Container(
              height: 100.h,
              width: 100.w,
              color: col.themeColor,
              child: Center(
                child:
                    CupertinoActivityIndicator(color: col.whites, radius: 22.0),
              ),
            ));
  }
  showSucessTost(context,text)=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text.toString(),style: fonts.h7semibold(col.successColor),),));
  showWarningTost(context,text)=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text.toString(),style: fonts.h7semibold(col.warningColor),),));
}
