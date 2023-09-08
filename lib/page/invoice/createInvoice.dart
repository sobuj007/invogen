import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invogen/main.dart';
import 'package:invogen/page/dashboard/dashboard.dart';
import 'package:invogen/page/invoice/inviceViewer.dart';
import 'package:list_country_picker/list_country_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:http/http.dart' as http;

class CreateInvoice extends StatefulWidget {

  final clientId;
  final deuDate;
  final template;

  const CreateInvoice({ this.clientId, this.deuDate, this.template,super.key});

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  TextEditingController product = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController quantity = TextEditingController();

  var _country;
  bool tremConditon = false;

/************************* */
  final ImagePicker _picker = ImagePicker();
  XFile? _photo;
  var pickedImage = '';
  List itemsList = [];
  List<String> itemsListItem = [];
  List<String> itemsListPrice = [];
  late StateSetter _setter;
  var total = 0.0;
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
                    height: 1.h,
                  ),
                  Container(
                    height: 7.h,
                    width: 100.w,
                    child: TextField(
                        style: fonts.h6semibold(col.whites),
                        controller: product,
                        cursorColor: col.whites,
                        decoration: sheet.logindeco("Item", "Product Name")),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 7.h,
                        width: 45.w,
                        child: TextField(
                            style: fonts.h6semibold(col.whites),
                            controller: quantity,
                            cursorColor: col.whites,
                            enabled: false,
                            
                            decoration: sheet.logindeco("Exm: 10", "Quantity= 1")),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        height: 7.h,
                        width: 45.w,
                        child: TextField(
                            style: fonts.h6semibold(col.whites),
                            controller: price,
                            cursorColor: col.whites,
                            decoration: sheet.logindeco("Exm: 10\$", "Price")),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
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
                            if (product.text.isNotEmpty &&
                                price.text.isNotEmpty) {
                              var d = {
                                "product": product.text.toString(),
                                "quntity": 1,
                                "price": price.text,
                              };
                              itemsList.add(d);
                              itemsListItem.add(product.text.toString());
                              itemsListPrice.add(price.text.toString());
                              setState(() {
                                product.clear();
                                price.clear();
                                quantity.clear();
                                countTotal();
                              });
                            }

                            // if (email.text.isNotEmpty &&
                            //     fullname.text.isNotEmpty &&
                            //     phone.text.isNotEmpty) {
                            //   addToDb();
                            // } else {
                            //   sheet.showWarningTost(
                            //       context, "Field can't be empty");
                            // }
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
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  /************************************************************ List area********************************************** */
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50.w,
                            child: Text(
                              'Product'.toString(),
                              style: fonts.h7reguler(col.whites),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: 14.w,
                            alignment: Alignment.center,
                            child: Text(
                              'Quntity'.toString(),
                              style: fonts.h7reguler(col.whites),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              'Price'.toString(),
                              style: fonts.h7reguler(col.whites),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ]),
                  ),
                  Container(
                    height: 50.h,
                    width: 100.w,
                    child: StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        _setter = setState;

                        return itemsList.isEmpty
                            ? Center(
                                child: Text(
                                  'No Item add !',
                                  style: fonts.h6reguler(col.whites),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ListView.builder(
                                itemCount: itemsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onLongPress: () {
                                      /*************************************************** Alart Dialog ****************************/
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                content: Container(
                                                  height: 15.h,
                                                  width: 50.w,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Do want to Delete item $index"
                                                            .toString(),
                                                        style: fonts.h7semibold(
                                                            col.blacks),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          InkWell(
                                                            child: Text(
                                                              "No",
                                                              style: fonts
                                                                  .h7semibold(
                                                                      Colors
                                                                          .red),
                                                            ),
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          InkWell(
                                                            child: Text(
                                                              "Yes",
                                                              style: fonts
                                                                  .h7semibold(
                                                                      Colors
                                                                          .green),
                                                            ),
                                                            onTap: () {
                                                              itemsList
                                                                  .removeAt(
                                                                      index);
                                                              itemsListItem
                                                                  .removeAt(
                                                                      index);
                                                              itemsListPrice
                                                                  .removeAt(
                                                                      index);
                                                              countTotal();
                                                              Navigator.pop(
                                                                  context);
                                                              _setter(() {});
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ));
                                    },
                                    /************************************************************************** singel Item  ***********************************/
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 50.w,
                                                child: Text(
                                                  itemsList[index]['product']
                                                      .toString(),
                                                  style: fonts
                                                      .h7reguler(col.blacks),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                                width: 13.w,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  itemsList[index]['quntity']
                                                      .toString(),
                                                  style: fonts
                                                      .h7reguler(col.blacks),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  child: Text(
                                                    itemsList[index]['price']
                                                        .toString(),
                                                    style: fonts
                                                        .h7reguler(col.blacks),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              )
                                            ]),
                                      ),
                                    ),
                                  );
                                },
                              );
                      },
                    ),
                  ),

                  /********************************Total ************************************************** */
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Total'.toString(),
                                style: fonts.h7reguler(col.whites),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: total == 0.0
                                ? Text('')
                                : Text(
                                    total.toStringAsFixed(2),
                                    style: fonts.h7reguler(col.whites),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                          Container(
                            width: 30.w,
                            color: col.themeAlter,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: GestureDetector(
                                onTap: () {
                                  if(itemsList.isNotEmpty&&itemsListItem.isNotEmpty&&itemsListPrice.isNotEmpty){
                                    addToDb();
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please, add Item First!"),backgroundColor: col.warningColor,));
                                  }



                                },
                                child: Text(
                                  'Create',
                                  style: fonts.h6reguler(col.whites),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          )
                        ]),
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
    // var headersList = {
    //   'Accept': 'application/json',
    //   'Authorization': 'Bearer ' + temp.getToken().toString()
    // };

  

  Map<String,String> headersList = {
 
 "Accept": "application/json",
 "Authorization": "Bearer " + temp.getToken().toString() 
};
var url = Uri.parse('https://invogen.cosmeticplugs.com/api/invoice/store');

Map<String,String>data;
data={
  "client": widget.clientId,
 "template": widget.template.toString().toLowerCase(),
 "discount": "0",
 "due_date": widget.deuDate.toString(),
};
 for(int i=0;i<itemsListItem.length;i++){
   data.addAll({'title[$i]':itemsListItem[i]});
   data.addAll({'price[$i]':itemsListPrice[i]});
  }

// Map<String,dynamic> bodydata = {
//  "client": widget.clientId,
//  "template": widget.template,
//  "discount": "0",
//  "due_date": widget.deuDate,
//   "title[]": itemsListItem,
//  "price[]": itemsListPrice,
// //  'title[]': 'Item 3',
// //  'title[]': 'Item 4',
// //  'title[]': 'Item 5',
// //  'price[]': '1',
// //  'price[]': '2',
// //  'price[]': '3',
// //  'price[]': '4',
// //  'price[]': '5' 
// };
// print(bodydata);

var req =await http.post(url,
 headers:
 {
 "Accept": "application/json",
 "Authorization": "Bearer " + temp.getToken().toString() 
},body: data
);

var res = jsonDecode(req.body);

    if (req.statusCode >= 200 && req.statusCode < 300) {
      print(res);
      Navigator.pop(context);
      sheet.showSucessTost(context, "Invoice Added Successfuly");
      print(res['data']['invoice']['url'].toString());
Navigator.push(context,CupertinoPageRoute(builder: (_)=>PdfViewer(pdfData:res['data']['invoice']['url'])));
      clearAll();
    } else {
      print(res.reasonPhrase);
      Navigator.pop(context);
      sheet.showSucessTost(context, "Someting Wrong");
    }
     

  }

  clearAll() {
   itemsList=[];
   itemsListItem=[];
   itemsListPrice=[];
   total=0;
    setState(() {});
  }

  countTotal() {
    total=0;
    for (var i = 0; i < itemsList.length; i++) {
      // total=total+(int.parse(itemsList[i]['quntity'])*int.parse(itemsList[i]['price']));
      total = total + (1.0) * double.parse(itemsList[i]['price']);
      print(total);
    }
    setState(() {});
  }
}
