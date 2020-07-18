import 'package:flutter/material.dart';

///********************************************************************************************
///
/// 用于测试的页面
///
///********************************************************************************************
class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: Scaffold(
          body: DialogPage(),
        ));
  }
}

class DialogPage extends StatefulWidget {
  @override
  _DialogPageState createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('1111'),
        onPressed: (){
        },
      ),
    );
  }
}


//Scaffold(
//appBar: PreferredSize(
//child: AppBar(
//flexibleSpace: TitleBar(
//title: "会员商城",
//subTitle: "我的订单",
//subTitleClick: (){
//print('----------------------------------');
//},
//),
//elevation: 0,
//backgroundColor: Colors.white,
//),
//preferredSize: Size.fromHeight(44),
//),
//backgroundColor: Colors.white,
//resizeToAvoidBottomPadding: false,
//body: MyApp(),
//),
//)
