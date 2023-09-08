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
  const PdfViewer({this.pdfData,super.key});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
 
  @override
  void initState() {
    super.initState();
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
        final Email email = Email(
  body: 'Email body ${widget.pdfData}',
  subject: 'Email subject',
  recipients: ['anwarsobuj007@gmail.com'],
  cc: ['cc@example.com'],
  bcc: ['bcc@example.com'],
 // attachmentPaths: ['/path/to/attachment.zip'],
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
    final appDocDir = await getExternalStorageDirectory();
    final filePath = '${appDocDir!.path}/$fileName';

    // Write the PDF data to a file
    final pdfFile = File(filePath);
    await pdfFile.writeAsBytes(response.bodyBytes);

    // Open the PDF using a PDF viewer package or widget
    // For example, you can use 'pdf_flutter' package or 'flutter_pdfview'
    // You need to add the corresponding package to your pubspec.yaml for this step.

    // Example using pdf_flutter:
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) => PDFViewer(document: PDFDocument(file: pdfFile)),
    //   ),
    // );
    print(pdfFile.toString());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Download Complete")));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pdfFile.toString())));
  } else {
    throw Exception('Failed to download PDF');
  }

      }
}