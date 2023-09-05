import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
class Loaders extends StatefulWidget {
  const Loaders({super.key});

  @override
  State<Loaders> createState() => _LoadersState();
}

class _LoadersState extends State<Loaders> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  getData() async {
    var headersList = {
 
 'Accept': 'application/json',
 'Authorization': 'Bearer 1|VHbVW98MxGwRL4Z9A2FkEjcAvL708UMJUQMoPE7z' 
};
var url = Uri.parse('https://invogen.cosmeticplugs.com/api/dashboard');

var req = http.Request('GET', url);
req.headers.addAll(headersList);

var res = await req.send();
final resBody = await res.stream.bytesToString();

if (res.statusCode >= 200 && res.statusCode < 300) {
  print(resBody);
}
else {
  print(res.reasonPhrase);
}
 
  }

  
  @override
  Widget build(BuildContext context) {
    return Container(
              height: 100.h,
              width: 100.w,
              color: col.themeColor,
              child: Center(
                child:
                    CupertinoActivityIndicator(color: col.whites, radius: 22.0),
              ),
            );
  }
}