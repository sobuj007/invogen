import 'dart:convert';
import 'dart:io';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invogen/main.dart';
import 'package:invogen/page/clients/createClients.dart';
import 'package:invogen/page/clients/editprofile.dart';
import 'package:invogen/page/customWidget/cDrawer.dart';
import 'package:invogen/page/invoice/chosseClient.dart';
import 'package:invogen/page/invoice/createInvoice.dart';
import 'package:invogen/page/model/clientsModel.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

import '../invoice/inviceViewer.dart';

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

  load() {
    showDialog(
        context: context,
        builder: (_) => Container(height: 100, width: 100, color: col.whites));
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
 
 GlobalKey<ScaffoldState> scf=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exitTo(),
      child: Scaffold(
        key: scf,
        backgroundColor: col.themeColor,
    
        /**************************** SDrawer*/
        drawer: CDrawer(scf:scf),
        body: SafeArea(
            child: Container(
          height: 100.h,
          width: 100.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0,vertical: 1.w),
            child: Stack(
              children: [
                Positioned(
                  child: Column(
                    children: [
                       Container(width: 100.w,height: 6.h,child: Row(children: [
                      IconButton(onPressed: (){
    scf.currentState!.openDrawer();
    
                      }, icon: Icon(Icons.menu,color: col.themeAlter,size: 28,))
                    ],),),
                      // invoice card *************************************************************
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 43.w,
                            color: col.themeAlter,
                            height: 15.h,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Total'.toString(),
                                    style: fonts.custom(
                                        col.whites, 14.0, FontWeight.w800, 2.0),
                                  ),
                                  Expanded(
                                      child: invoices.isEmpty
                                          ? Transform.scale(
                                              scale: .4,
                                              child: CircularProgressIndicator(
                                                color: col.whites,
                                              ))
                                          : Text(
                                              invoices.length.toString(),
                                              style: fonts.custom(col.whites,
                                                  45.0, FontWeight.w800, 1.0),
                                            )),
                                  Text(
                                    'Invoice',
                                    style: fonts.custom(
                                        col.whites, 25.0, FontWeight.w300, 1.0),
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
                            height: 15.h,
                            width: 43.w,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                child: Column(
                                  children: [
                                    Text(
                                      'Total'.toString(),
                                      style: fonts.custom(
                                          col.whites, 14.0, FontWeight.w800, 2.0),
                                    ),
                                    Expanded(
                                        child: clients.isEmpty
                                            ? Transform.scale(
                                                scale: .4,
                                                child: CircularProgressIndicator(
                                                  color: col.whites,
                                                ))
                                            : Text(
                                                clients.length.toString(),
                                                style: fonts.custom(col.whites,
                                                    45.0, FontWeight.w800, 1.0),
                                              )),
                                    Text(
                                      'Clients',
                                      style: fonts.custom(
                                          col.whites, 25.0, FontWeight.w300, 1.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Clients",
                                style: fonts.h5semibold(col.whites),
                              ),
                            ),
    /*********************************************************** invoice Tab */
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Invoices",
                                style: fonts.h5semibold(col.whites),
                              ),
                            ),
                          ],
                          views: [
                            Container(
                              height: 100.h,
                              width: 100.w,
                              color: Colors.white12,
                              child: clients.isEmpty
                                  ? Center(
                                      child: CircularProgressIndicator(
                                          color: col.themeAlter),
                                    )
                                  : ListView.builder(
                                      itemCount: clients.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: .5.w, horizontal: 1.w),
                                          child: Container(
                                             height: 12.h,
                                            width: 100.w,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Colors.white70,
                                                gradient: LinearGradient(colors: [
                                             Color(0XFFff9966),
                                                  Color(0XFFff5e62),
                                                ])),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 0.h, vertical: 1.h),
                                              child: ListTile(
                                                  onTap: () {
    Navigator.push(context, CupertinoPageRoute(builder: (_)=>EditProfile(client: clients[index],)));
    
                                                  },
                                                  leading: CircleAvatar(
                                                    radius: 30.0,
                                                    backgroundImage: NetworkImage(
                                                        clients[index]['image']),
                                                    backgroundColor: col.whites,
                                                  ),
                                                  title: Text(
                                                    clients[index]['name']
                                                        .toString(),
                                                    style: fonts
                                                        .h5semibold(col.whites),
                                                  ),
                                                  subtitle: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 10),
                                                    child: Text(
                                                      clients[index]['email']
                                                          .toString(),
                                                      style: fonts
                                                          .h7semibold(col.whites),
                                                    ),
                                                  ),
                                                  ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            /**************************************************** invoice ************************ */
                            Container(
                              height: 100.h,
                              width: 100.w,
                              color: Colors.white12,
                              child: invoices.isEmpty
                                  ? Center(
                                      child: CircularProgressIndicator(
                                          color: col.themeAlter),
                                    )
                                  : ListView.builder(
                                      itemCount: invoices.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 12.h,
                                            width: 100.w,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Colors.white70,
                                                gradient: LinearGradient(colors: [
                                                  Color(0XFFdd5e89),
                                                  Color(0XFFf7bb97),
                                                  Color(0XFF5FFBF1),
                                                ])),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (_) => PdfViewer(
                                                            pdfData:
                                                                invoices[index]
                                                                    ['url'],
                                                            client:
                                                                invoices[index]
                                                                    ['client'])));
                                              },
                                              child: Container(
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      top: 0,right: 0,
                                                      child:      Container(
                                                  color:invoices[index]['status']=='unpaid'? Colors.redAccent:Colors.green,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                                                    child: Text(
                                                      invoices[index]['status']
                                                          .toString(),
                                                      style: fonts.h8reguler(col.whites),
                                                    ),
                                                  ),
                                                ),),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  8.0),
                                                          child: Container(
                                                            height: 8.h,
                                                            width: 16.w,
                                                            decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: NetworkImage(
                                                                        invoices[index]
                                                                                    [
                                                                                    'client']
                                                                                [
                                                                                'image']
                                                                            .toString()),
                                                                    fit:
                                                                        BoxFit.fill)),
                                                          ),
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(),
                                                            Text(
                                                              invoices[index][
                                                                          'invoice_no']
                                                                      .toString() +
                                                                  '.pdf',
                                                              style: fonts.h5semibold(
                                                                  col.whites),
                                                            ),
                                                            Text(
                                                              invoices[index]
                                                                          ['client']
                                                                      ['name']
                                                                  .toString(),
                                                              style: fonts.h7semibold(
                                                                  col.whites),
                                                            ),
                                                            Text(
                                                              invoices[index]
                                                                      ['due_date']
                                                                  .toString(),
                                                              style: fonts.h8reguler(
                                                                  col.whites),
                                                            ),
                                                            SizedBox(),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                    height: 36.w,
                    width: 18.w,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => CreateClient()));
                          },
                          child: CircleAvatar(
                              radius: 28.0,
                              child: CircleAvatar(
                                radius: 27,
                                backgroundColor: col.themeColor,
                                child: Icon(Icons.person),
                              )),
                        ),
                        SizedBox(
                          height: 2.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => ChosseClient(
                                          client: clients,
                                        )));
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
      ),
    );
  }


exitTo(){
  showDialog(context: context, builder:(_)=> AlertDialog(
    actions:[ Container(
    height: 20.h,color: col.whites,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
          Text("Do you want to Exit ",style: fonts.h5semibold(col.blacks),),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("No !",style: fonts.h5semibold(Colors.green),),
              ),
            ),
            SizedBox(width: 20,),
            GestureDetector(
              onTap: (){
                exit(0);
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("Yes !",style: fonts.h5semibold(Colors.red),),
              ),
            )
          ],)
        ],),
      ),
    ),]
  ));
}

}
