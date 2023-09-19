import 'package:flutter/material.dart';
import 'package:invogen/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class CDrawer extends StatefulWidget {
  final scf;
  const CDrawer({this.scf,super.key});

  @override
  State<CDrawer> createState() => _CDrawerState();
}

class _CDrawerState extends State<CDrawer> {
  var user;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
user=temp.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(width: 66.w,
        backgroundColor: col.whites,
        child: Column(children: [
          /************************ Header */
          Container(
            height: 25.h,
            width: 100.w,
            color: Colors.blueAccent.shade100,
            child: Padding(
              padding:  EdgeInsets.all(12.0),
              child:Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
                children: [
                  user['image']==null? Image(image: AssetImage('assets/logo.png'),height: 13.h,):Image(image:NetworkImage(user['image']),height: 13.h,),
                  Divider(),
                  Text(user['name'],style: fonts.h4semibold(col.whites),overflow: TextOverflow.clip,),
                  SizedBox(height: 1.w,),
                  Text(user['email'],style: fonts.h7semibold(col.whites),overflow: TextOverflow.clip,),

                  
                ],
              ),
            ),
          ),
         Flexible(
           child: ListView(

            children: [
              ListTile(leading: Icon(Icons.edit),title: Text('Profile',style: fonts.h6semibold(col.blacks),),),
              ListTile(leading: Icon(Icons.settings),title: Text('Settings',style: fonts.h6semibold(col.blacks),),),
              ListTile(leading: Icon(Icons.apps_rounded),title: Text('Apps Infos',style: fonts.h6semibold(col.blacks),),),
              ListTile(leading: Icon(Icons.policy),title: Text('Policy',style: fonts.h6semibold(col.blacks),),),
              ListTile(leading: Icon(Icons.logout),title: Text('Logout',style: fonts.h6semibold(col.blacks),),),
         
           ],),
         )


        ],),
      ),
    );
  }
}