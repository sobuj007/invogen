import 'dart:convert';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invogen/main.dart';
import 'package:invogen/page/clients/createClients.dart';
import 'package:invogen/page/invoice/chosseClient.dart';
import 'package:invogen/page/invoice/createInvoice.dart';
import 'package:invogen/page/model/clientsModel.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List clients = [];
  List invoices = [];
  @override
  void initState() {
    super.initState();
  
    getData();
  }
 load(){
  
showDialog(context: context, builder: (_)=>Container(height: 100,width: 100,color:col.whites));
 }
  getData() async {
  //load();
    var headersList = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + temp.getToken().toString()
    };
    var url = Uri.parse('https://invogen.cosmeticplugs.com/api/dashboard');

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      var dcodedData = json.decode(resBody);
      clients = dcodedData['data']['clients']['data'];
      invoices = dcodedData['data']['invoices']['data'];
      ClientsModel.fromJson(dcodedData['data']['clients']);
     // Navigator.pop(context);
    } else {
      print(res.reasonPhrase);
      sheet.showWarningTost(context, "Data Not Found");
     // Navigator.pop(context);
      
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: col.themeColor,
      body: SafeArea(
          child: Container(
        height: 100.h,
        width: 100.w,
        child: Padding(
          padding: EdgeInsets.all(14.0),
          child: Stack(
            children: [
              Positioned(
                child: Column(
                  children: [
                    // invoice card *************************************************************
                    Container(
                      color: col.themeAlter,
                      height: 12.h,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Total'.toString(),
                                  style: fonts.custom(
                                      col.whites, 14.0, FontWeight.w800, 2.0),
                                ),
                                Expanded(
                                    child:invoices.isEmpty?Transform.scale(scale: .4,child: CircularProgressIndicator(color: col.whites,)): Text(
                                  invoices.length.toString(),
                                  style: fonts.custom(
                                      col.whites, 45.0, FontWeight.w800, 1.0),
                                )),
                              ],
                            ),
                            Text(
                              'Invoice',
                              style: fonts.custom(
                                  col.whites, 35.0, FontWeight.w300, 1.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.8.h,
                    ),
                    //************************************ clients ************************************ */
                    Container(
                      color: col.themeAlter,
                      height: 12.h,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Clients',
                              style: fonts.custom(
                                  col.whites, 35.0, FontWeight.w300, 1.0),
                            ),
                            Column(
                              children: [
                                Text(
                                  'Total'.toString(),
                                  style: fonts.custom(
                                      col.whites, 14.0, FontWeight.w800, 2.0),
                                ),
                                Expanded(
                                    child:clients.isEmpty?Transform.scale(scale: .4,child: CircularProgressIndicator(color: col.whites,)):  Text(
                                  clients.length.toString(),
                                  style: fonts.custom(
                                      col.whites, 45.0, FontWeight.w800, 1.0),
                                )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    /************************************************* Tabview *************************** */
                    Expanded(
                      child: ContainedTabBarView(
                        tabBarProperties: TabBarProperties(
                            isScrollable: false,
                            padding: EdgeInsets.all(5),
                            indicatorColor: col.themeAlter),
                        tabs: [
                          /*******************************Client Tab ********************* */
                          Text(
                            "Clients",
                            style: fonts.h5semibold(col.whites),
                          ),
/*********************************************************** invoice Tab */
                          Text(
                            "Invoices",
                            style: fonts.h5semibold(col.whites),
                          ), 
                        ],
                        views: [
                          Container(
                            height: 100.h,
                            width: 100.w,
                            color: Colors.white12,
                            child:clients.isEmpty? Center(child: CircularProgressIndicator(color: col.themeAlter),): ListView.builder(
                              itemCount: clients.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: .5.w,horizontal: 1.w),
                                  child: Card(
                                    color: Colors.white70,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0.h, vertical: 1.h),
                                      child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 30.0,
                                            backgroundImage: NetworkImage(
                                                clients[index]['image']),
                                            backgroundColor: col.whites,
                                          ),
                                          title: Text(
                                            clients[index]['name'].toString(),
                                            style: fonts.h5semibold(col.blacks),
                                          )),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            height: 100.h,
                            width: 100.w,
                            color: Colors.white12,
                            child:invoices.isEmpty? Center(child: CircularProgressIndicator(color: col.themeAlter),): ListView.builder(
                              itemCount: invoices.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.white70,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0.h, vertical: 1.h),
                                      child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 30.0,
                                            backgroundImage: NetworkImage(
                                                invoices[index]['url']),
                                            backgroundColor: col.whites,
                                          ),
                                          title: Text(
                                            invoices[index]['invoice_no']
                                                .toString(),
                                            style: fonts.h5semibold(col.blacks),
                                          )),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        onChange: (index) => print(index),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  height: 16.h,
                  width: 18.w,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_)=>CreateClient()));
                        },
                        child: CircleAvatar(
                            radius: 28.0,
                            child: CircleAvatar(
                              radius: 27,
                              backgroundColor: col.themeColor,
                              child: Icon(Icons.person),
                            )),
                      ),
                          SizedBox(height: 2.w,),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_)=>ChosseClient(client: clients,)));
                        },
                        child: CircleAvatar(
                            radius: 28.0,
                            child: CircleAvatar(
                              radius: 27.0,
                              backgroundColor: col.themeColor,
                              child: Icon(Icons.print),
                            )),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
