import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invogen/main.dart';
import 'package:invogen/page/dashboard/dashboard.dart';
import 'package:list_country_picker/list_country_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

class CreateClient extends StatefulWidget {
  const CreateClient({super.key});

  @override
  State<CreateClient> createState() => _CreateClientState();
}

class _CreateClientState extends State<CreateClient> {
  TextEditingController email = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController phone = TextEditingController();

  var _country;
  bool tremConditon = false;

/************************* */
  final ImagePicker _picker = ImagePicker();
  XFile? _photo;
  var pickedImage = '';
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
                      IconButton(
                          onPressed: () {
                           Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_)=>Dashboard()));
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: col.whites,
                          )),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 7.h,
                        width: 60.w,
                        child: TextField(
                            style: fonts.h6semibold(col.whites),
                            controller: fullname,
                            cursorColor: col.whites,
                            decoration: sheet.logindeco("jhon deo", "Name")),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => Container(
                              height: 15.h,
                              color: col.themeColor,
                              width: 100.w,
                              child: Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 5.h,vertical: 5.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(Icons.camera_alt,color: col.themeAlter,),
                                          Text(
                                            "From Camera",
                                            style:
                                                fonts.h5semibold(col.themeAlter),
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        imageFromGallery();
                                      },
                                    ),
                                    GestureDetector(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(Icons.image,color: col.themeAlter,),
                                          Text("From Gallery", style:
                                                fonts.h5semibold(col.themeAlter),)
                                        ],
                                      ),
                                      onTap: () {
                                        imageFromCamera();
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 7.h,
                          width: 28.w,
                          color: col.hintcol,
                          child: pickedImage != ''
                              ? Image.file(
                                  File(pickedImage),
                                  fit: BoxFit.fill,
                                )
                              : Center(
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: col.whites,
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
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
                  Container(
                    height: 7.h,
                    width: 100.w,
                    child: TextField(
                        style: fonts.h6semibold(col.whites),
                        controller: phone,
                        cursorColor: col.whites,
                        decoration: sheet.logindeco("+880XX-XXXXXX", "Phone")),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                      height: 7.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1.2, color: col.themeAlter)),
                      child: ListCountryPiker(
                        onCountryChanged: (value) {
                          setState(() {
                            _country = value.name;
                          });
                        },
                        child: ListTile(
                          title: Text(
                            _country==null? 'Select country':_country.toString(),
                            style: fonts.h5semibold(col.whites),
                          ),
                          trailing: Icon(
                            Icons.arrow_drop_down,
                            color: col.whites,
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                     clearAll();
                          },
                          child: Icon(
                            Icons.restart_alt,
                            size: 40,
                            color: col.hintcol,
                          )),
                      GestureDetector(
                          onTap: () {
                            if (email.text.isNotEmpty &&
                                fullname.text.isNotEmpty &&
                                phone.text.isNotEmpty) {
                              addToDb();
                            } else {
                              sheet.showWarningTost(
                                  context, "Field can't be empty");
                            }
                          },
                          child: Container(
                              width: 60.w,
                              height: 6.h,
                              color: col.themeAlter,
                              alignment: Alignment.center,
                              child: Text(
                                'Add',
                                style: fonts.h3semibold(col.whites),
                              ))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

/************************* */

  imageFromCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      print(image.path.toString());
      _photo = image;
      setState(() {
        pickedImage = _photo!.path;
      });
    }
  }

  imageFromGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print(image.path.toString());
      _photo = image;
      setState(() {
        pickedImage = _photo!.path;
      });
    }
  }

  /*********************************** add to server******************* */

  addToDb() async {
    sheet.loaders(context);
    var headersList = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + temp.getToken().toString()
    };
    var url = Uri.parse('https://invogen.cosmeticplugs.com/api/client/store');

    var body = {
      'name': fullname.text.toString(),
      'email': email.text.toString(),
      'phone': phone.text.toString(),
      'country': _country.toString()
    };

    var req = http.MultipartRequest('POST', url);
    req.headers.addAll(headersList);
    req.files.add(await http.MultipartFile.fromPath('image', pickedImage));
    req.fields.addAll(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      Navigator.pop(context);
      sheet.showSucessTost(context, "Client Added Successfuly");
clearAll();
    } else {
      print(res.reasonPhrase);
       Navigator.pop(context);
      sheet.showSucessTost(context, "Someting Wrong");
    }
  }
  clearAll(){
           fullname.clear();
                            phone.clear();
                            email.clear();
                            pickedImage = '';
                            _country = null;
                            setState(() {});
  }
}
