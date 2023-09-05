import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:invogen/page/invoice/createInvoice.dart';
import 'package:invogen/page/model/clientsModel.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../main.dart';
import '../dashboard/dashboard.dart';

class ChosseClient extends StatefulWidget {
  final client;
  ChosseClient({this.client, super.key});

  @override
  State<ChosseClient> createState() => _ChosseClientState();
}

class _ChosseClientState extends State<ChosseClient> {
  List<String> template = [];
  List<dynamic> clientData = [];
  var clientId;
  DateTime? _dates = DateTime.now();
  DateTime? _datesDue = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clientData = widget.client;
    print('widget.client');
    print(widget.client);
    fecthTemplate();
  }

  fecthTemplate() async {
    var headersList = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + temp.getToken().toString()
    };
    var url =
        Uri.parse('https://invogen.cosmeticplugs.com/api/invoice/templates');

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      var jres = json.decode(resBody);
      var d = jres['data']['templates'];
      d.forEach((key, value) {
        template.add(value);
      });

      setState(() {});
    } else {
      print(res.reasonPhrase);
    }
  }

  var selectTemplate = '';
  var selectClint = '';
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
              padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => Dashboard()));
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
                  Text('Select Template',
                      style: fonts.h6reguler(col.themeAlter)),
                  SizedBox(
                    height: 10,
                  ),
                  template.isEmpty
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: col.themeAlter)),
                          child: SearchableDropdown<int>(
                            trailingIcon: Icon(
                              Icons.arrow_drop_down,
                              color: col.themeAlter,
                            ),
                            hintText: Text(
                              'Select Template',
                              style: fonts.h6semibold(col.themeAlter),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            items: List.generate(
                                template.length,
                                (i) => SearchableDropdownMenuItem(
                                    value: i,
                                    label: 'item $i',
                                    child: Text(
                                      template[i],
                                      style: fonts.h6semibold(col.themeAlter),
                                    ))),
                            onChanged: (int? value) {
                              
                               var d = value?.toInt() ?? 0;
                               selectTemplate = template[d];
                               print(selectTemplate);
                              setState(() {
                                
                              });
                              
                            },
                          ),
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Select Client', style: fonts.h6reguler(col.themeAlter)),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: col.themeAlter)),
                    child: SearchableDropdown<int>(
                      trailingIcon: Icon(
                        Icons.arrow_drop_down,
                        color: col.themeAlter,
                      ),
                      hintText: Text(
                        'Select Client',
                        style: fonts.h6semibold(col.themeAlter),
                      ),
                      margin: EdgeInsets.all(15),
                      items: List.generate(
                          widget.client.length,
                          (i) => SearchableDropdownMenuItem(
                              value: i,
                              label: 'item $i',
                              child: Text(
                                widget.client[i]['name'],
                                style: fonts.h6semibold(col.themeAlter),
                              ))),
                      onChanged: (int? value) {
                        selectClint = widget.client[value]['name'].toString();
                        clientId=widget.client[value]['id'].toString();
                       setState(() {
                         
                       });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  /*************************************************invoice Date*************************************** */
                  Text('Invoice Date', style: fonts.h6reguler(col.themeAlter)),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: col.themeAlter)),
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            _dates.toString().substring(0, 11),
                            style: fonts.h6semibold(col.themeAlter),
                          ),
                        ),
                        onTap: () async {
                          _dates = await DatePicker.showSimpleDatePicker(
                            context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1960),
                            lastDate: DateTime(2050),
                            dateFormat: "dd-MMMM-yyyy",
                            locale: DateTimePickerLocale.en_us,
                            looping: true,
                          );
                          setState(() {});
                        },
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  /*************************************************Due Date*************************************** */
                  Text('Due Date', style: fonts.h6reguler(col.themeAlter)),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: col.themeAlter)),
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            _datesDue.toString().substring(0, 11),
                            style: fonts.h6semibold(col.themeAlter),
                          ),
                        ),
                        onTap: () async {
                          _datesDue = await DatePicker.showSimpleDatePicker(
                            context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1960),
                            lastDate: DateTime(2050),
                            dateFormat: "dd-MMMM-yyyy",
                            locale: DateTimePickerLocale.en_us,
                            looping: true,
                          );
                          setState(() {
                            
                          });
                        },
                      )),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            // clearAll();
                          },
                          child: Icon(
                            Icons.restart_alt,
                            size: 40,
                            color: col.hintcol,
                          )),
                      GestureDetector(
                          onTap: () {
                            if (selectClint == '' &&
                                selectTemplate == '' &&
                                _dates == null) {
                             
                              sheet.showWarningTost(
                                  context, "Field can't be empty");
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => CreateInvoice(deuDate: _datesDue,template: selectTemplate,clientId: clientId,)));
                            }
                          },
                          child: Container(
                              width: 60.w,
                              height: 6.h,
                              color: col.themeAlter,
                              alignment: Alignment.center,
                              child: Text(
                                'Next',
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
}
