import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wobei/bean/AreaBean.dart';
import 'package:wobei/bean/CityBean.dart';
import 'package:wobei/bean/ProvinceBean.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/plugin/LogPlugin.dart';
import 'package:wobei/widget/EditText.dart';
import 'package:wobei/widget/PinYinWidget.dart';
import '../../my_lib/extension/BaseExtension.dart';

///*****************************************************************************
///
/// 描述：城市列表
/// 作者：YeXuDong
/// 创建时间：2020/7/10
///
///*****************************************************************************
class CityListPage extends StatefulWidget {
  @override
  _CityListPageState createState() => _CityListPageState();
}

class _CityListPageState extends State<CityListPage> with BaseUtils {
  List<City> cityList = [];
  final firstLetterList = List<String>();
  final firstLetterPositionList = List<int>();
  final firstLetterOffsetList = List<double>();

  final ctrl = ScrollController();

  var currentLetter = 'A';

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/json/city.json').then((value) {
      String cityJson = value;
      List list = json.decode(cityJson)['city'];
      List<City> cities = list.map((e) => City.fromJson(e)).toList();
      cities.sort((left, right) => left.firstCode.compareTo(right.firstCode));
      firstLetterList.add('A');
      firstLetterPositionList.add(0);
      firstLetterOffsetList.add(0.0);
      for (int i = 1; i < cities.length - 1; i++) {
        if (cities[i].firstCode[0] != cities[i + 1].firstCode[0]) {
          cities[i + 1].isFirstLetter = false;
          firstLetterList.add(cities[i + 1].firstCode[0].toUpperCase());
          firstLetterPositionList.add(i + 1);
          firstLetterOffsetList.add((i*50+firstLetterList.length*28).toDouble());
        } else {
          cities[i + 1].isFirstLetter = true;
        }
      }
      print(firstLetterOffsetList);
      cities[0].isFirstLetter = false;
      cities[1].isFirstLetter = true;
      setState(() {
        cityList = cities;
      });
    });

    var lastOffset = 0;

    ctrl.addListener(() {
      if(ctrl.offset.toInt() != lastOffset){
        lastOffset = ctrl.offset.toInt();
        for(var i=0;i<firstLetterOffsetList.length;i++){
          if(firstLetterOffsetList[i] >= ctrl.offset){
            if(currentLetter != firstLetterList[i-1]){
              setState(() {
                currentLetter = firstLetterList[i-1];
              });
            }
            break;
          }
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: getStatusBarHeight()),
        child: Stack(
          children: <Widget>[
            Container(
              child: SingleChildScrollView(
                controller: ctrl,
//                physics: BouncingScrollPhysics(),
                child: Column(
                  children: cityList
                      .map((e) => Container(
                            height: e.isFirstLetter ? 50 : 78,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                e.isFirstLetter
                                    ? SizedBox(
                                        height: 0,
                                      )
                                    : Container(
                                        child: e.firstCode[0]
                                            .toUpperCase()
                                            .text('#A5A3AC'.color(), 12),
                                        alignment: Alignment.centerLeft,
                                        height: 28,
                                      ),
                                Container(
                                  height: 49,
                                  child: Text(e.cname),
                                  alignment: Alignment.centerLeft,
                                ),
                                Divider(
                                  height: 1,
                                  color: Config.DIVIDER_COLOR,
                                )
                              ],
                            ),
                            margin: EdgeInsets.only(left: 20, right: 20),
                          ))
                      .toList(),
                ),
              ),
              height: context.getSrnH() - getStatusBarHeight() - 44,
              margin: EdgeInsets.only(top: 44),
              width: context.getSrnW(),
            ),
            Positioned(
              child: PinYinWidget(
                getCurrentLetter: (letter, int position) {
                  if (firstLetterList.contains(letter)) {
                    ctrl.jumpTo(firstLetterPositionList[
                                firstLetterList.indexOf(letter)] *
                            50.0 +
                        firstLetterList.indexOf(letter) * 28);
                  }
                },
              ),
              right: 10,
              top: 200,
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      Config.CLOSE,
                      width: 17.5,
                      height: 17.5,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 1,
                      height: 32,
                      decoration: BoxDecoration(
                        color: '#F5F5F5'.color(),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 16,
                          ),
                          Image.asset(
                            Config.SEARCH,
                            width: 12,
                            height: 12,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          '输入城市名或拼音'.text('#A5A3AC'.color(), 12),
                        ],
                      ),
                    ).setExpanded(1),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ).setSizedBox(height: 44),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  color: Colors.white,
                  child: currentLetter
                      .toUpperCase()
                      .text('#A5A3AC'.color(), 12),
                  alignment: Alignment.centerLeft,
                  height: 28,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
