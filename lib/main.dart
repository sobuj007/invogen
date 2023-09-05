import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:invogen/page/auth/splashPage.dart';
import 'package:invogen/utilty/colorsFile.dart';
import 'package:invogen/utilty/fontsFile.dart';
import 'package:invogen/utilty/styles.dart';
import 'package:invogen/utilty/tempData.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

ColorsFile col= ColorsFile();
FontFile fonts=FontFile();
Styles sheet= Styles();
TempData temp= TempData();

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  runApp(const InvoGen());
}
class InvoGen extends StatelessWidget {
  const InvoGen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context,oriebtation,screenType){
      return MaterialApp(home: SplashPage(),);
    });
  }
}
