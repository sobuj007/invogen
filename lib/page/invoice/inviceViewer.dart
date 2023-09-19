
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:invogen/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
class PdfViewer extends StatefulWidget {
  final pdfData;
  final client;
  const PdfViewer({this.pdfData,this.client,super.key});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
 var pathfinal;
  @override
  void initState() {
    super.initState();
 downpdf();
  }
  downpdf()async{
     await downloadFile(widget.pdfData, widget.pdfData.toString().substring(43,widget.pdfData.length),'/download');
  }


  @override
  Widget build(BuildContext context) {
    print(widget.pdfData.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: col.themeColor,
        title:  Text('Invoice'),
        actions: <Widget>[
          IconButton(
            icon:  Icon(
              Icons.mail,
              color: Colors.white,
              
            ),
            onPressed: ()async {
var  text = 'Dear ${widget.client['name']},\n\n'
          'I hope this message finds you well. We would like to extend our heartfelt gratitude for your prompt payment of the invoice.\n\n'
          'Your timely payment not only helps us maintain the smooth operation of our business but also strengthens our partnership. We greatly value your trust in our products/services, and your continued support is instrumental in our success.\n\n'
          'Please do not hesitate to reach out to our billing department at [Billing Department Contact Information] if you have any questions or require further clarification regarding the invoice or payment.\n\n'
          'Once again, thank you for your prompt attention to this matter. We look forward to serving you again in the future and continuing to meet your needs.\n your invoice is attach in the attachment section or you will download from url ${widget.pdfData} \n'
          'Warm regards,\n'
          'Jhon Deo'
          'Executive Manager'
          'Invogen.io';

        final Email email = Email(
  body: text,
  subject: 'Invogen invoice Email',
  recipients: [widget.client['email']],
  cc: [''],
  bcc: [''],
 attachmentPaths: [pathfinal.toString()],
  isHTML: false,
);


    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
         }
          ),
          SizedBox(width: 1.w,),
          IconButton(
            icon:  Icon(
              Icons.download,
              color: Colors.white,
              
            ),
            onPressed: ()async {
            await downloadFile(widget.pdfData, widget.pdfData.toString().substring(43,widget.pdfData.length),'/download');
            
            }, 
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.pdfData.toString(),
        key: _pdfViewerKey,
      ),
    );
  }

var _progress=0.0;

downloadFile(String urldata, String fileName, String dir) async {
//  print(fileName);
//  print(url.toString());
//  final File? file = await FileDownloader.downloadFile(
//     url: url,
//     name: fileName);

// print('FILE: ${file?.path}');
 
    //     FileDownloader.downloadFile(
    // url: url,
    // name: fileName,
    // onDownloadCompleted: (path) {
    //     final File file = File(path);
    //     //This will be the path of the downloaded file

    //     print("nothing"+file.path.toString());
    // });

  // final File? file = await FileDownloader.downloadFile(
  //   url: url,
  //   name: fileName.toString(),
  //   onProgress: (String? fileName, double progress) {
  //       setState(() => _progress = progress);
  //   });
  final response = await http.get(Uri.parse(urldata));

  if (response.statusCode == 200) {
    // Get the document directory using path_provider
   // final appDocDir = await getApplicationDocumentsDirectory();
    final appDocDir = await getDownloadsDirectory();
    final filePath = '${appDocDir!.path}/$fileName';

    // Write the PDF data to a file
    final pdfFile = File(filePath);
    await pdfFile.writeAsBytes(response.bodyBytes);
pathfinal=pdfFile;

    print(pdfFile.toString());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download Complete")));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pdfFile.toString())));
    setState(() {
  
});
  } else {
    throw Exception('Failed to download PDF');
  }

      }
}