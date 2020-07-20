import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:wobei/bean/BannerData1.dart';
import 'package:wobei/bean/BuyVipData.dart';
import 'package:wobei/bean/CardTicketDetailData.dart';
import 'package:wobei/bean/ChangeCardListData.dart';
import 'package:wobei/bean/DealDetailData.dart';
import 'package:wobei/bean/DealRecordData.dart';
import 'package:wobei/bean/EnterprisePrefectureHomePageData.dart';
import 'package:wobei/bean/EnterprisePrefecturePageData.dart';
import 'package:wobei/bean/ExchangeTicketData.dart';
import 'package:wobei/bean/ExchangeTicketsData.dart';
import 'package:wobei/bean/HeBeiDetailData.dart';
import 'package:wobei/bean/HomeIconData.dart';
import 'package:wobei/bean/HomeLabelData.dart';
import 'package:wobei/bean/LoginData.dart';
import 'package:wobei/bean/MeData.dart';
import 'package:wobei/bean/MyCardData.dart';
import 'package:wobei/bean/PayInfoData.dart';
import 'package:wobei/bean/RedPacketData.dart';
import 'package:wobei/bean/RightClassData.dart';
import 'package:wobei/bean/RightClassFilteredData.dart';
import 'package:wobei/bean/RightDetailData.dart';
import 'package:wobei/bean/RightSubPageData.dart';
import 'package:wobei/bean/SearchWord.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/constant/URL.dart';
import 'package:wobei/my_lib/utils/NetUtils.dart';
import 'package:wobei/my_lib/utils/ToastUtils.dart';
import 'package:wobei/page/me/MessageCenterData.dart';
import 'package:wobei/plugin/LogPlugin.dart';

///*****************************************************************************
/// 管理所有的接口请求
///*****************************************************************************
class Req {
  ///---------------------------------------------------------------------------
  /// 登录
  ///---------------------------------------------------------------------------
  static void login(
      isPasswordLogin, phone, password, verificationCode, Function callback) {
    var params = Map<String, String>();
    params['phone'] = phone;
    if (isPasswordLogin) {
      params['password'] = password;
    } else {
      params['verificatCode'] = verificationCode;
    }
    params.forEach((k, v) {
      print('HTTP: Key is $k, Value is $v');
    });
    NetUtils.post(URL.REGISTER, params, (c, m, s, d) {
      var data = LoginData.fromJson(d);
      callback(data);
    });
  }

  ///---------------------------------------------------------------------------
  /// 获取图片验证码
  ///---------------------------------------------------------------------------
  static Future<Uint8List> getPicVerificationCode(String phone) {
    return NetUtils.getBitmap(
        URL.VERIFY_PIC, Map<String, String>()..['phone'] = phone);
  }

  ///---------------------------------------------------------------------------
  /// 上传头像
  ///---------------------------------------------------------------------------
  static void uploadAvatar(File file, Function callback) {
    NetUtils.uploadImage(URL.UPLOAD_AVATAR, file, (c, m, s, d) {
      if (s) {
        ToastUtils.show('上传成功');
        callback(d['url']);
      } else {
        ToastUtils.show(m);
      }
    });
  }

  ///---------------------------------------------------------------------------
  /// 获取轮播栏的信息
  ///---------------------------------------------------------------------------
  static Future<Response> getBannerInfo({isHomePage = true}) async {
    var params = Map<String, String>();
    if (isHomePage) {
      params['position'] = "1";
    } else {
      params['position'] = "2";
    }
    params['port'] = '3';
    return await NetUtils.post2(URL.LUN_BO_TU, params);
  }

  static Future<Response> getBannerInfo1(Function callback,
      {isHomePage = true}) {
    var params = Map<String, String>();
    if (isHomePage) {
      params['position'] = "1";
    } else {
      params['position'] = "2";
    }
    params['port'] = '3';
    NetUtils.post(URL.LUN_BO_TU, params, (c, m, s, d) {
      List list = json.decode(json.encode(d));
      List<BannerData1> dataList =
          list.map((e) => BannerData1.fromJson(e)).toList();
      callback(dataList, json.encode(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// 获取首页图标
  ///---------------------------------------------------------------------------
//  static Future<Response> getHomeIcon() async {
//    var params = Map<String, String>();
//    return await NetUtils.post2(URL.HOME_ICON, params);
//  }

  static void getHomeIcon(Function callback) {
    var params = Map<String, String>();
    NetUtils.post(URL.HOME_ICON, params, (c, m, s, d) {
      List list = json.decode(json.encode(d));
      List<HomeIconData> dataList =
          list.map((e) => HomeIconData.fromJson(e)).toList();
      callback(dataList, json.encode(d));
    });
  }

  ///---------------------------------------------------------------------------
  ///
  /// ## 获取首页标签
  ///
  /// latitude 纬度
  ///
  /// longitude 经度
  ///
  /// cityId 城市ID
  ///
  ///---------------------------------------------------------------------------
  static Future<Response> getHomeLabel() async {
    var params = Map<String, String>();
    params['latitude'] = Global.prefs.getString('lat');
    params['longitude'] = Global.prefs.getString('lon');
    params['cityId'] = Global.prefs.getString('cityId');
    return await NetUtils.post2(URL.HOME_LABEL, params);
  }

  static void getHomeLabel1(Function callback) {
    var params = Map<String, String>();
    params['latitude'] = Global.prefs.getString('lat');
    params['longitude'] = Global.prefs.getString('lon');
    params['cityId'] = Global.prefs.getString('cityId');
    NetUtils.post(URL.HOME_LABEL, params, (c, m, s, d) {
      List list = json.decode(json.encode(d));
      List<HomeLabelData> dataList =
          list.map((e) => HomeLabelData.fromJson(e)).toList();
      callback(dataList, json.encode(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// 获取广告信息
  ///---------------------------------------------------------------------------
  static void getAdInfo(Function callback) {
    NetUtils.post(URL.GUANG_GAO_YE_HUO_QU_TU_PIAN_DI_ZHI, Map()..['port'] = '1',
        (code, msg, success, data) {
      callback(success, data);
    });
  }

  ///---------------------------------------------------------------------------
  /// 获取搜索关键词
  ///---------------------------------------------------------------------------
  static Future<Response> getKeyword(Function callback) {
    NetUtils.post(URL.GET_SEARCH_WORDS, Map()..['port'] = '1', (c, m, s, d) {
      callback(SearchWord.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  ///
  /// 获取手机验证码
  ///
  /// verifyPictureCode 图片验证码
  ///
  ///---------------------------------------------------------------------------
  static void getVCode(String phone, Function callback,
      {String verifyPictureCode}) {
    Map params = Map<String, String>()..['phone'] = phone;
    if (verifyPictureCode != null) {
      params['verifyPictureCode'] = verifyPictureCode;
    }
    NetUtils.post(URL.SEND_MESSAGE, params, (c, m, s, d) {
      callback(d['token']);
    });
  }

  ///---------------------------------------------------------------------------
  /// 获取“我的”信息
  ///---------------------------------------------------------------------------
  static void getMeInfo(Function callback) {
    Map params = Map<String, String>();
    NetUtils.post(URL.LOOKUP_DATA, params, (c, m, s, d) {
      callback(MeData.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// 实名认证
  ///---------------------------------------------------------------------------
  static void certification(
      String name, String idCard, Function success, Function failure) {
    Map params = Map<String, String>();
    params['name'] = name;
    params['idCard'] = idCard;
    NetUtils.post(URL.CERTIFICATION, params, (c, m, s, d) {
      if (d == true) {
        success(m);
      } else {
        failure(m);
      }
    });
  }

  ///---------------------------------------------------------------------------
  /// 修改我的信息
  ///---------------------------------------------------------------------------
  static void modifyMeInfo(Map<String, String> params, Function success) {
    NetUtils.post(URL.MODIFY_DATA, params, (c, m, s, d) {
      if (d == true) {
        success();
      } else {
        ToastUtils.show(m);
      }
    });
  }

  ///---------------------------------------------------------------------------
  /// 获取我的权益卡券
  ///---------------------------------------------------------------------------
  static void getMyCard(Function callback,
      {int pageNum = 1, bool isOverdue = false}) {
    Map params = Map<String, String>();
    params['pageNum'] = pageNum.toString();
    params['ifEnd'] = isOverdue ? '2' : '1';
    NetUtils.post(URL.FEN_YE_LIST, params, (c, m, s, d) {
      callback(MyCardData.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// 获取我的企业信息
  ///---------------------------------------------------------------------------
  static void viewMyEnterpriseInfo(Function callback) {
    Map params = Map<String, String>();
    NetUtils.post(URL.CHA_KAN_WO_DE_QI_YE_XIN_XI, params, (c, m, s, d) {
      if (d == null) {
        callback(-1, '-1');
      } else {
        callback(d['customerId'], d['customerName']);
      }
    });
  }

  ///---------------------------------------------------------------------------
  /// 获取禾贝余额
  ///---------------------------------------------------------------------------
  static void getHeBeiBalance(Function callback) {
    NetUtils.post(URL.HEBEI_BALANCE, Map<String, String>(), (c, m, s, d) {
      callback(d['total']);
    });
  }

  ///---------------------------------------------------------------------------
  /// 零钱兑换卡列表
  ///---------------------------------------------------------------------------
  static void getChangeCardList(Function callback) {
    NetUtils.post(URL.LING_QIAN_CARD_LIST, Map<String, String>(), (c, m, s, d) {
      callback(ChangeCardListData.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  ///
  /// 查看用户认证状态和支付密码状态
  /// certStatus 是否实名 0:位置 1:已实名 2:未实名
  /// payPwdStatus 是否设置支付密码 0:位置 1:已设置 2:未设置
  ///
  ///---------------------------------------------------------------------------
  static void viewCertificateInfo(Function callback) {
    NetUtils.post(URL.IS_CERTIFICATION, Map<String, String>(), (c, m, s, d) {
      callback(d['certStatus'], d['payPwdStatus']);
    });
  }

  ///---------------------------------------------------------------------------
  /// 获取禾贝明细
  ///---------------------------------------------------------------------------
  static void getHeBeiDetail(int pageNum, Function callback) {
    NetUtils.post(URL.HEBEI_FLOWWATER,
        Map<String, String>()..['pageNum'] = pageNum.toString(), (c, m, s, d) {
      callback(HeBeiDetailData.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// 获取交易记录
  ///---------------------------------------------------------------------------
  static void getPacketFlowWater(int pageNum, Function callback) {
    NetUtils.post(URL.PACKET_FLOW_WATER,
        Map<String, String>()..['pageNum'] = pageNum.toString(), (c, m, s, d) {
      callback(DealRecordData.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// 钱包余额
  ///---------------------------------------------------------------------------
  static void getPacketBalance(Function callback) {
    NetUtils.post(URL.PACKET_BALANCE, Map<String, String>(), (c, m, s, d) {
      callback(d['totalView']);
    });
  }

  ///---------------------------------------------------------------------------
  /// 钱包流水详情
  ///---------------------------------------------------------------------------
  static void getPacketDetail(String flowId, Function callback) {
    NetUtils.post(URL.PACKET_DETAIL, Map<String, String>()..['flowId'] = flowId,
        (c, m, s, d) {
      callback(DealDetailData.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  ///
  /// 会员开通购买页展示
  ///
  /// isRenew 是否为续费
  ///
  ///---------------------------------------------------------------------------
  static void getVipPurchasePage(isRenew, Function callback) {
    NetUtils.post(URL.PURCHASE_PAGE,
        Map<String, String>()..['configType'] = isRenew ? '2' : '1',
        (c, m, s, d) {
      callback(BuyVipData.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// VIP订单下单
  ///---------------------------------------------------------------------------
  static void createVipOrder(
      int vipCardId, String vipCardPriceConfigId, Function callback) {
    final map = Map<String, String>();
    map['vipCardId'] = vipCardId.toString();
    map['vipCardPriceConfigId'] = vipCardPriceConfigId;
    NetUtils.post(URL.BUY_VIP, map, (c, m, s, d) {
      callback(d['vipCardOrderId']);
    });
  }

  ///---------------------------------------------------------------------------
  /// 卡券详情
  ///---------------------------------------------------------------------------
  static void getCardDetail(int orderId, Function callback) {
    final map = Map<String, String>();
    map['orderId'] = orderId.toString();
    map['latitude'] = Global.prefs.getString('lat');
    map['longitude'] = Global.prefs.getString('lon');
    map['cityId'] = Global.prefs.getString('cityId');
    NetUtils.post(URL.DING_DAN_DETAIL + "?orderId=$orderId", map, (c, m, s, d) {
      callback(CardTicketDetailData.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// 我的-红包: 全部/历史
  ///---------------------------------------------------------------------------
  static void getMyPacket(bool isHistory, int pageNum, Function callback) {
    final map = Map<String, String>();
    map['allOrHistory'] = isHistory ? '2' : '1';
    map['pageNum'] = pageNum.toString();
    NetUtils.post(URL.MY_RED_PACKET, map, (c, m, s, d) {
      callback(RedPacketData.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// 券码兑换
  ///---------------------------------------------------------------------------
  static void exchangeTicket(String code, Function callback) {
    NetUtils.post(URL.QUANMA_DUIHUAN, Map<String, String>()..['code'] = code,
        (c, m, s, d) {
      callback(ExchangeTicketData.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// 我的兑换券
  ///---------------------------------------------------------------------------
  static void getMyExchangeTickets(
      bool isOverdue, int pageNum, Function callback) {
    NetUtils.post(
        URL.getMyThroneCombo,
        Map<String, String>()
          ..['status'] = isOverdue ? '2' : '1'
          ..['pageNum'] = pageNum.toString(), (c, m, s, d) {
      LogPlugin.logD('test', json.encode(d));
      callback(ExchangeTicketsData.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// 企业专区首页
  ///---------------------------------------------------------------------------
  static void getEnterprisePrefectureHomePage(
      int customerId, Function callback) {
    NetUtils.post(URL.QI_YE_ZHUAN_QU_SHOU_YE,
        Map<String, String>()..['customerId'] = customerId.toString(),
        (c, m, s, d) {
      callback(EnterprisePrefectureHomePageData.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// 企业专区分页，查看各个标签下的权益
  ///---------------------------------------------------------------------------
  static void getEnterprisePrefecturePage(
      int labelId, String pageNum, Function callback) {
    var params = Map<String, String>();
    params['latitude'] = Global.prefs.getString('lat');
    params['longitude'] = Global.prefs.getString('lon');
    params['cityId'] = Global.prefs.getString('cityId');
    params['labelId'] = labelId.toString();
    NetUtils.post(URL.FEN_YE_CHA_KAN_GE_GE_BIAO_QIAN_XIA_DE_QUAN_YI, params,
        (c, m, s, d) {
      callback(EnterprisePrefecturePageData.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  ///
  /// 获取消息中心数据
  ///
  /// pageNum 1.推送 2.通知
  ///
  ///---------------------------------------------------------------------------
  static void getMessageCenterData(
      int pushType, int pageNum, Function callback) {
    var params = Map<String, String>();
    params['pushType'] = pushType.toString();
    params['pageNum'] = pageNum.toString();
    NetUtils.post(URL.MESSAGE_CENTER, params, (c, m, s, d) {
      callback(MessageCenterData.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// 设置消息为已读状态
  ///---------------------------------------------------------------------------
  static void setMsgRead(int id, Function callback) {
    var params = Map<String, String>();
    params['id'] = id.toString();
    NetUtils.post(URL.SET_HAVE_READ, params, (c, m, s, d) {
      callback(d);
    });
  }

  ///---------------------------------------------------------------------------
  /// 消息点击数+1
  ///---------------------------------------------------------------------------
  static void clickAddOne(int id, Function callback) {
    var params = Map<String, String>();
    params['taskId'] = id.toString();
    NetUtils.post(URL.CLICK_ADD_ONE, params, (c, m, s, d) {
      callback(d);
    });
  }

  ///---------------------------------------------------------------------------
  /// 获取权益类型列表
  ///---------------------------------------------------------------------------
  static void getRightClassList(Function callback, {level = '1'}) {
    var params = Map<String, String>();
    params['level'] = level;
    NetUtils.post(URL.RIGHT_CLASS_LIST, params, (c, m, s, d) {
      List list = json.decode(json.encode(d));
      List<RightClassData> dataList =
          list.map((e) => RightClassData.fromJson(e)).toList();
      callback(dataList, json.encode(d));
    });
  }

  ///---------------------------------------------------------------------------
  ///
  /// 获取权益分页
  ///
  /// itemGroupLevelIds 用户无筛选：一级分类id；用户筛选：一级分类和二级分类的集合
  ///
  /// commonType 0-最新 1-热门 2-高价
  ///
  /// typeId 不传-不限属性 通用权益-0 其它-1
  ///
  /// distanceType 附近-0 3公里-3 6公里-6
  ///
  ///---------------------------------------------------------------------------
  static void getRightSubPage(
      {itemGroupLevelIds = '',
      pageNum = 1,
      commonType = '0',
      typeId = '',
      distanceType = '0',
      Function callback}) {
    var params = Map<String, String>();
    params['itemGroupLevelIds'] = itemGroupLevelIds;
    params['pageNum'] = pageNum.toString();
    params['latitude'] = Global.prefs.getString('lat');
    params['longitude'] = Global.prefs.getString('lon');
    params['commonType'] = '0';
    if (typeId != '') {
      params['typeId'] = typeId;
    }
    params['distanceType'] = distanceType;

    NetUtils.post(URL.FEN_YE_QUERY, params, (c, m, s, d) {
      callback(RightSubPageData.fromJson(d), json.encode(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// 请求权益详情
  ///---------------------------------------------------------------------------
  static void getRightDetail(int id, Function callback,
      {bool isEnterprise = false}) {
    var params = Map<String, String>();
    params['itemId'] = id.toString();
    params['latitude'] = Global.prefs.getString('lat');
    params['longitude'] = Global.prefs.getString('lon');
    params['cityId'] = Global.prefs.getString('cityId');
    params['payEntrance'] = isEnterprise ? '2' : '1';

    NetUtils.post(URL.RIGHT_DETAIL, params, (c, m, s, d) {
      callback(RightDetailData.fromJson(d), json.encode(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// 获取权益分类过滤后的页面
  ///---------------------------------------------------------------------------
  static void getRightClassFilteredPage(List<int> idList, Function callback,
      {pageNum = 1}) {
    var url = URL.FEN_YE_QUERY;
    for (int i = 0; i < idList.length; i++) {
      if (i == 0) {
        url += "?itemGroupLevelIds=${idList[i]}";
      } else {
        url += "&itemGroupLevelIds=${idList[i]}";
      }
    }
    final map = Map<String, String>();
    map['pageNum'] = pageNum.toString();
    NetUtils.post(url, map, (c, m, s, d) {
      callback(RightSubPageData.fromJson(d));
    });
  }

  ///---------------------------------------------------------------------------
  /// 取消支付权益订单
  ///---------------------------------------------------------------------------
  static void cancelPayRightOrder(int orderId, Function callback) {
    NetUtils.post(URL.CANCEL_DUI_HUAN,
        Map<String, String>()..['orderId'] = orderId.toString(), (c, m, s, d) {
      callback(d);
    });
  }

  ///---------------------------------------------------------------------------
  /// 获取购买权益或会员的支付页面信息
  ///---------------------------------------------------------------------------
  static void getPayInfo(int id, Function callback, {bool isRightPage = true}) {
    final map = Map<String, String>();
    if (isRightPage) {
      map['orderId'] = id.toString();
    } else {
      map['vipCardOrderId'] = id.toString();
    }
    NetUtils.post(isRightPage ? URL.RIGHT_PAY_INFO : URL.VIP_PAY_INFO, map,
        (c, m, s, d) {
          callback(PayInfoData.fromJson(d));
        });
  }

/**
 * 获取支付页面信息
 */
//  fun getPayInfo(payType: Int, orderId: Int, callback: (data: PayInfo) -> Unit) {
//  OK.post<PayInfo>(if (payType == Constant.PAY_RIGHT) URL.RIGHT_PAY_INFO
//  else URL.VIP_PAY_INFO, {
//  callback.invoke(it)U
//  }, (if (payType == Constant.PAY_RIGHT) "orderId" else "vipCardOrderId") to orderId.toString())
//  }

}
