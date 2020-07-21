import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:frame_animate_widget/frame_animate_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wobei/bean/MeData.dart';
import 'package:wobei/bean/SearchWord.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/constant/AppRoute.dart';
import 'package:wobei/enum/JumpType.dart';
import 'package:wobei/my_lib/RouteAnim.dart';
import 'package:wobei/page/WebPage.dart';
import 'package:wobei/page/home/CityListPage.dart';
import 'package:wobei/page/home/HeKaExclusivePage.dart';
import 'package:wobei/page/home/PrefecturePage.dart';
import 'package:wobei/page/home/PrepaidRefillPage.dart';
import 'package:wobei/page/home/SearchPage.dart';
import 'package:wobei/page/intro/ADPage.dart';
import 'package:wobei/page/intro/WelcomePage.dart';
import 'package:wobei/page/login/LoginPage.dart';
import 'package:wobei/page/me/BuyVipPage.dart';
import 'package:wobei/page/me/CardTicketDetailPage.dart';
import 'package:wobei/page/me/CertificationPage.dart';
import 'package:wobei/page/me/DealDetailPage.dart';
import 'package:wobei/page/me/DealRecordPage.dart';
import 'package:wobei/page/me/EnterprisePrefecturePage.dart';
import 'package:wobei/page/me/HeBeiAboutPage.dart';
import 'package:wobei/page/me/HeBeiShopPage.dart';
import 'package:wobei/page/me/MessageCenterPage.dart';
import 'package:wobei/page/me/MyCardTicketPage.dart';
import 'package:wobei/page/me/MyHistoryCardTicketPage.dart';
import 'package:wobei/page/me/MyPacketPage.dart';
import 'package:wobei/page/me/NickNamePage.dart';
import 'package:wobei/page/me/PersonalInfoPage.dart';
import 'package:wobei/page/me/RedPacketPage.dart';
import 'package:wobei/page/me/RightExchangeTicketPage.dart';
import 'package:wobei/page/me/SettingsPage.dart';
import 'package:wobei/page/me/VipExchangeCodePage.dart';
import 'package:wobei/page/order/MyOrderPage.dart';
import 'package:wobei/page/order/ProductDetailPage.dart';
import 'package:wobei/page/order/VipShopPage.dart';
import 'package:wobei/page/pay/RightPayPage.dart';
import 'package:wobei/page/pay/SetPayPwdPage.dart';
import 'package:wobei/page/right/RightClassPage.dart';
import 'package:wobei/page/right/RightDetailPage.dart';

import 'page/ScaffoldPage.dart';

void main() {
  //在调用runApp之前初始化绑定时，需要调用此方法。
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) {
    runApp(BaseApp());
  });
}

class BaseApp extends StatefulWidget {
  @override
  _BaseAppState createState() => _BaseAppState();
}

class _BaseAppState extends State<BaseApp> {
  //配置路由
  var routes = {
    AppRoute.PREFECTURE_PAGE: (context, {arguments}) => PrefecturePage(
          areaId: arguments,
        ),
    AppRoute.PREPAID_REFILL_PAGE: (context) => PrepaidRefillPage(),
    AppRoute.HE_KA_ZHUAN_SHU: (context) => HeKaExclusivePage(),
    AppRoute.MY_ORDER_PAGE: (context, {arguments}) => MyOrderPage(),
    AppRoute.PRODUCT_DETAIL_PAGE: (context, {arguments}) => ProductDetailPage(
          goodsId: arguments,
        ),
    AppRoute.VIP_SHOP_PAGE: (context, {arguments}) => VipShopPage(
          categoryId: arguments,
        ),
    AppRoute.SCAFFOLD_PAGE: (context) => ScaffoldPage(),
    AppRoute.RIGHT_PAY_PAGE: (context, {arguments}) =>
        RightPayPage(id: arguments),
    AppRoute.RIGHT_CLASS_PAGE: (context) => RightClassPage(),
    AppRoute.RIGHT_DETAIL_PAGE: (context, {arguments}) => RightDetailPage(
          id: arguments,
        ),
    AppRoute.CITY_LIST_PAGE: (context) => CityListPage(),
    AppRoute.MY_HISTORY_CARD_TICKET_PAGE: (context) =>
        MyHistoryCardTicketPage(),
    AppRoute.MESSAGE_CENTER_PAGE: (context) => MessageCenterPage(),
    AppRoute.SET_PAY_PWD_PAGE: (context) => SetPayPwdPage(),
    AppRoute.DEAL_RECORD_PAGE: (context, {JumpFrom arguments}) =>
        DealRecordPage(
          from: arguments,
        ),
    AppRoute.DEAL_DETAIL_PAGE: (context, {arguments}) => DealDetailPage(
          flowId: arguments,
        ),
    AppRoute.CARD_TICKET_DETAIL_PAGE: (context, {arguments}) =>
        CardTicketDetailPage(
          orderId: arguments,
        ),
    AppRoute.MY_CARD_TICKET_PAGE: (context, {arguments}) => MyCardTicketPage(
          isOverdue: arguments,
        ),
    AppRoute.HE_BEI_SHOP_PAGE: (context) => HeBeiShopPage(),
    AppRoute.MY_PACKET_PAGE: (context) => MyPacketPage(),
    AppRoute.BUY_VIP_PAGE: (context) => BuyVipPagePage(),
    AppRoute.ENTERPRISE_PREFECTURE_PAGE: (context, {arguments}) =>
        EnterprisePrefecturePage(
          info: arguments,
        ),
    AppRoute.RED_PACKET_PAGE: (context, {arguments}) => RedPacketPage(
          isHistory: arguments,
        ),
    AppRoute.RIGHT_EXCHANGE_PAGE: (context, {arguments}) =>
        RightExchangeTicketPage(
          isHistory: arguments,
        ),
    AppRoute.VIP_EXCHANGE_CODE_PAGE: (context) => VipExchangeCodePage(),
    AppRoute.ABOUT: (context) => HeBeiAboutPage(),
    AppRoute.SETTINGS_PAGE: (context) => SettingsPage(),
    AppRoute.NICKNAME_PAGE: (context, {arguments}) => NicknamePage(
          nickname: arguments,
        ),
    AppRoute.CERTIFICATION_PAGE: (context) => CertificationPage(),
    AppRoute.WEB_PAGE: (context, {arguments}) => WebPage(
          url: arguments,
        ),
    AppRoute.WELCOME_PAGE: (context) => WelcomePage(),
    AppRoute.AD_PAGE: (context, {arguments}) => ADPage(),
    AppRoute.HOME_PAGE: (context) => ScaffoldPage(),
    AppRoute.LOGIN: (context) => LoginPage(),
    // 注意：SearchPage中的arguments如果可选参数，那么这里的arguments必须也是可选参数
    AppRoute.SEARCH_PAGE: (BuildContext context, {SearchWord arguments}) =>
        SearchPage(arguments: arguments),
    AppRoute.PERSONAL_INFO: (context, {MeData arguments}) => PersonalInfoPage(
          arguments: arguments,
        ),
  };

  /// 用于控制下拉刷新动画的全局键
  final keyLoading = UniqueKey();

  var loadingAnim;

  @override
  void initState() {
    super.initState();
    loadingAnim = FrameAnimationImage(
      keyLoading,
      Global.netLoadingImgList,
      width: 200,
      height: 200,
      interval: 20,
      start: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
        // 配置默认的头指示器。如果每个页面都有相同的标题指示器，则需要设置这个
        headerBuilder: () =>
            CustomHeader(builder: (BuildContext context, RefreshStatus mode) {
              return Container(
                height: 100,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 100,
                      right: 100,
                      bottom: 0,
                      child: FrameAnimationImage(
                        keyLoading,
                        Global.frameList,
                        width: 200,
                        height: 30,
                        interval: 20,
                        start: true,
                      ),
                    )
                  ],
                ),
              );
            }),
        // 配置默认底部指示器
        footerBuilder: () => CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("已经到底啦！");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("加载失败");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("释放加载更多");
                } else {
                  body = Text("已经到底啦！");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
        // header trigger refresh trigger distance
        headerTriggerDistance: 80.0,
        // custom spring back animate,the props meaning see the flutter api
        springDescription:
            SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
        // 头的最大拖动范围。如果出现冲出视图区域的情况，请设置此属性
        maxOverScrollExtent: 100,
        // 在底部的最大拖动范围
        maxUnderScrollExtent: 0,
        // 此属性不适用于PageView和TabBarView. 如果你需要TabBarView能够左右滑动, 你需要设置它为true.
        enableScrollWhenRefreshCompleted: true,
        // 在加载失败的情况下，用户仍然可以通过手势上拉触发更多的加载。
        enableLoadingWhenFailed: true,
        // 当视窗少于一个屏幕时，禁用上拉以载入更多的功能
        hideFooterWhenNotFull: true,
        // trigger load more by BallisticScrollActivity
        enableBallisticLoad: true,
        child: MaterialApp(
          title: '禾权益',
          locale: const Locale('en'),
          theme: ThemeData(
              primaryColor: Colors.white,
              accentColor: Colors.white,
              colorScheme: ColorScheme(
                primary: Colors.white,
                primaryVariant: Colors.white,
                secondary: Colors.white,
                secondaryVariant: Colors.white,
                surface: Colors.white,
                background: Colors.white,
                error: Colors.white,
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onSurface: Colors.white,
                onBackground: Colors.white,
                onError: Colors.white,
                brightness: Brightness.light,
              ),
              brightness: Brightness.light),
          debugShowCheckedModeBanner: false,
          home: getFirstPage(),
          color: Colors.white,
          onGenerateRoute: (RouteSettings settings) {
            final String name = settings.name;
            Global.stackNumber += 1;
            print('=======================================' + name);
            final Function pageContentBuilder = this.routes[name];
            if (pageContentBuilder != null) {
              if (settings.arguments != null) {
                final Route route = AnimationPageRoute(
                    animationType: AnimationType.SlideRightToLeft,
                    animationDuration: Duration(milliseconds: 400),
                    builder: (context) {
                      return pageContentBuilder(context,
                          arguments: settings.arguments);
                    });
                return route;
              } else {
                final Route route = AnimationPageRoute(
                    animationType: AnimationType.SlideRightToLeft,
                    animationDuration: Duration(milliseconds: 400),
                    builder: (context) {
                      return pageContentBuilder(context);
                    });
                return route;
              }
            }
            return null;
          },
        ));
  }

  Widget getFirstPage() {
    return Global.prefs.getString('ad')==null? ScaffoldPage() : ADPage();
  }
}

///*****************************************************************************
///
/// 基层页面
///
///*****************************************************************************
class MainApp extends StatelessWidget {
  //配置路由
  var routes = {
    AppRoute.CITY_LIST_PAGE: (context) => CityListPage(),
    AppRoute.MY_HISTORY_CARD_TICKET_PAGE: (context) =>
        MyHistoryCardTicketPage(),
    AppRoute.MESSAGE_CENTER_PAGE: (context) => MessageCenterPage(),
    AppRoute.SET_PAY_PWD_PAGE: (context) => SetPayPwdPage(),
    AppRoute.DEAL_RECORD_PAGE: (context, {JumpFrom arguments}) =>
        DealRecordPage(
          from: arguments,
        ),
    AppRoute.DEAL_DETAIL_PAGE: (context, {arguments}) => DealDetailPage(
          flowId: arguments,
        ),
    AppRoute.CARD_TICKET_DETAIL_PAGE: (context, {arguments}) =>
        CardTicketDetailPage(
          orderId: arguments,
        ),
    AppRoute.MY_CARD_TICKET_PAGE: (context, {arguments}) => MyCardTicketPage(
          isOverdue: arguments,
        ),
    AppRoute.HE_BEI_SHOP_PAGE: (context) => HeBeiShopPage(),
    AppRoute.MY_PACKET_PAGE: (context) => MyPacketPage(),
    AppRoute.BUY_VIP_PAGE: (context) => BuyVipPagePage(),
    AppRoute.ENTERPRISE_PREFECTURE_PAGE: (context, {arguments}) =>
        EnterprisePrefecturePage(
          info: arguments,
        ),
    AppRoute.RED_PACKET_PAGE: (context, {arguments}) => RedPacketPage(
          isHistory: arguments,
        ),
    AppRoute.RIGHT_EXCHANGE_PAGE: (context, {arguments}) =>
        RightExchangeTicketPage(
          isHistory: arguments,
        ),
    AppRoute.VIP_EXCHANGE_CODE_PAGE: (context) => VipExchangeCodePage(),
    AppRoute.ABOUT: (context) => HeBeiAboutPage(),
    AppRoute.SETTINGS_PAGE: (context) => SettingsPage(),
    AppRoute.NICKNAME_PAGE: (context, {arguments}) => NicknamePage(
          nickname: arguments,
        ),
    AppRoute.CERTIFICATION_PAGE: (context) => CertificationPage(),
    AppRoute.WEB_PAGE: (context, {arguments}) => WebPage(
          url: arguments,
        ),
    AppRoute.WELCOME_PAGE: (context) => WelcomePage(),
    AppRoute.AD_PAGE: (context, {arguments}) => ADPage(),
    AppRoute.HOME_PAGE: (context) => ScaffoldPage(),
    AppRoute.LOGIN: (context) => LoginPage(),
    // 注意：SearchPage中的arguments如果可选参数，那么这里的arguments必须也是可选参数
    AppRoute.SEARCH_PAGE: (BuildContext context, {SearchWord arguments}) =>
        SearchPage(arguments: arguments),
    AppRoute.PERSONAL_INFO: (context, {MeData arguments}) => PersonalInfoPage(
          arguments: arguments,
        ),
  };

  /// 用于控制下拉刷新动画的全局键
  static var keyLoading = GlobalKey<FrameAnimationImageState>();

  final loadingAnim = FrameAnimationImage(
    keyLoading,
    Global.netLoadingImgList,
    width: 200,
    height: 200,
    interval: 20,
    start: true,
  );

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
        // 配置默认的头指示器。如果每个页面都有相同的标题指示器，则需要设置这个
        headerBuilder: () =>
            CustomHeader(builder: (BuildContext context, RefreshStatus mode) {
              return Container(
                height: 100,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 100,
                      right: 100,
                      bottom: 0,
                      child: FrameAnimationImage(
                        keyLoading,
                        Global.frameList,
                        width: 200,
                        height: 30,
                        interval: 20,
                        start: true,
                      ),
                    )
                  ],
                ),
              );
            }),
        // 配置默认底部指示器
        footerBuilder: () => CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("已经到底啦！");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("加载失败");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("释放加载更多");
                } else {
                  body = Text("已经到底啦！");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
        // header trigger refresh trigger distance
        headerTriggerDistance: 80.0,
        // custom spring back animate,the props meaning see the flutter api
        springDescription:
            SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
        // 头的最大拖动范围。如果出现冲出视图区域的情况，请设置此属性
        maxOverScrollExtent: 100,
        // 在底部的最大拖动范围
        maxUnderScrollExtent: 0,
        // 此属性不适用于PageView和TabBarView. 如果你需要TabBarView能够左右滑动, 你需要设置它为true.
        enableScrollWhenRefreshCompleted: true,
        // 在加载失败的情况下，用户仍然可以通过手势上拉触发更多的加载。
        enableLoadingWhenFailed: true,
        // 当视窗少于一个屏幕时，禁用上拉以载入更多的功能
        hideFooterWhenNotFull: true,
        // trigger load more by BallisticScrollActivity
        enableBallisticLoad: true,
        child: MaterialApp(
          title: '禾权益',
          locale: const Locale('en'),
          theme: ThemeData(
              primaryColor: Colors.white,
              accentColor: Colors.white,
              colorScheme: ColorScheme(
                primary: Colors.white,
                primaryVariant: Colors.white,
                secondary: Colors.white,
                secondaryVariant: Colors.white,
                surface: Colors.white,
                background: Colors.white,
                error: Colors.white,
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onSurface: Colors.white,
                onBackground: Colors.white,
                onError: Colors.white,
                brightness: Brightness.light,
              ),
              brightness: Brightness.light),
          debugShowCheckedModeBanner: false,
          home: getFirstPage(),
          color: Colors.white,
          onGenerateRoute: (RouteSettings settings) {
            final String name = settings.name;
            final Function pageContentBuilder = this.routes[name];
            if (pageContentBuilder != null) {
              if (settings.arguments != null) {
                final Route route = AnimationPageRoute(
                    animationType: AnimationType.SlideRightToLeft,
                    animationDuration: Duration(milliseconds: 400),
                    builder: (context) {
                      return pageContentBuilder(context,
                          arguments: settings.arguments);
                    });
                return route;
              } else {
                final Route route = AnimationPageRoute(
                    animationType: AnimationType.SlideRightToLeft,
                    animationDuration: Duration(milliseconds: 400),
                    builder: (context) {
                      return pageContentBuilder(context);
                    });
                return route;
              }
            }
            return null;
          },
        ));
  }

  Widget getFirstPage() {
    return ScaffoldPage();
  }
}
