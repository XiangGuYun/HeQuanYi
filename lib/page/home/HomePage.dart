import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:frame_animate_widget/frame_animate_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wobei/bean/Banner.dart';
import 'package:wobei/bean/BannerData.dart';
import 'package:wobei/bean/BannerData1.dart';
import 'package:wobei/bean/CategoryData.dart';
import 'package:wobei/bean/EnterprisePrefectureHomePageData.dart';
import 'package:wobei/bean/HomeIcon.dart';
import 'package:wobei/bean/HomeIconData.dart';
import 'package:wobei/bean/HomeLabel.dart';
import 'package:wobei/bean/HomeLabelData.dart';
import 'package:wobei/bean/Location.dart';
import 'package:wobei/bean/RightClassData.dart';
import 'package:wobei/bean/SearchWord.dart';
import 'package:wobei/common/Global.dart';
import 'package:wobei/common/OverScrollBehavior.dart';
import 'package:wobei/constant/AppRoute.dart';
import 'package:wobei/constant/Config.dart';
import 'package:wobei/my_lib/Req.dart';
import 'package:wobei/my_lib/base/BaseState.dart';
import 'package:wobei/my_lib/utils/FileUtils.dart';
import 'package:wobei/page/order/VipShopPage.dart';
import 'package:wobei/plugin/AmapPlugin.dart';
import 'package:wobei/plugin/LogPlugin.dart';
import 'package:wobei/plugin/WebPlugin.dart';
import 'package:wobei/widget/VipPriceText.dart';
import 'file:///D:/hequanyi/flutter_app/lib/widget/right_item/home/FreeItem.dart';

import '../../my_lib/extension/BaseExtension.dart';

///*****************************************************************************
///
/// 描述：主页
/// 作者：YeXuDong
/// 创建时间：2020/7
///
///*****************************************************************************
class HomePage extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<HomePage>
    with
        BaseUtils,
    //为了在页面切出去后保留当前状态，必须实现此接口，重写wantKeepAlive方法并返回true
        AutomaticKeepAliveClientMixin {
  /// 轮播图列表
  List<BannerData1> bannerList = [];

  /// 主页标签列表
  List<HomeIconData> homeIconList = [];

  /// 专区列表
  List<HomeLabelData> areaList = [];

  /// 用于控制网络加载动画的全局键
  var keyLoading = GlobalKey<FrameAnimationImageState>();

  /// 用于控制下拉刷新动画的全局键
  var keyRefresh = GlobalKey<FrameAnimationImageState>();

  /// 是否处于网络加载状态
  var loading = true;

  /// 网络加载动画
  Widget loadingAnim;

  /// 下拉刷新控制器
  RefreshController _refreshController;

  /// 用户所处城市，默认是杭州
  String userCity = '杭州';

  /// 建议搜索词
  String textSuggestSearch = '';

  /// 推荐搜索词，需要传给搜索页显示
  List<String> recommendWords = [];

  SearchWord searchWord;

  ///===========================================================================
  /// 当页面销毁时
  ///===========================================================================
  @override
  void dispose() {
    super.dispose();
    // 在页面销毁后需要停止执行刷新动画
    keyRefresh.currentState.stopAnimation();
  }

  ///===========================================================================
  /// 当页面初始时
  ///===========================================================================
  @override
  void initState() {
    super.initState();
    init();
    Global.prefs.setString('cityId', '87'); // todo 先写死
    doLocateAndRenderAreaList();
    renderBanner();
    renderHomeIcon();
    Req.getKeyword((SearchWord data) {
      searchWord = data;
      setState(() {
        textSuggestSearch = data.suggestWord;
        recommendWords = data.recommendWords;
      });
    });
    Req.getRightClassList((List<RightClassData> data, String json) {
      Global.classNumber = data.length;
      FileUtils.writeFileToTemp(context, 'right_class_data.txt', json);
    });
    Req.getVipShopCategory((List<CategoryData> data, String jsonStr) {
      Global.categoryNumber = data.length;
      FileUtils.writeFileToTemp(context, 'cate_data.txt', jsonStr);
    });
  }

  ///===========================================================================
  /// 当页面构建时
  ///===========================================================================
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 22),
          child: ScrollConfiguration(
            behavior: OverScrollBehavior(), //去除波浪
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              onRefresh: _onRefresh,
              header: CustomHeader(
                  builder: (BuildContext context, RefreshStatus mode) {
                    return Container(
                      height: 100,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 100,
                            right: 100,
                            bottom: 0,
                            child: FrameAnimationImage(
                              keyRefresh,
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
              controller: _refreshController,
              child: ListView.builder(
                  itemCount: 7,
                  itemBuilder: (ctx, index) {
                    switch (index) {
                      case 0:
                        return SizedBox(
                          height: 18,
                        );
                        break;
                      case 1:
                        return getBanner()
                            .setPadding1(left: 20, right: 20); //轮播图
                        break;
                      case 2:
                        return SizedBox(
                          height: 20,
                        );
                        break;
                      case 3:
                        return getSubBar().setPadding1(left: 20, right: 20);
                        break;
                      case 4:
                        return SizedBox(
                          height: 0,
                        );
                        break;
                      case 5:
                        return getAreaList();
                        break;
                      default:
                        return SizedBox(
                          height: 20,
                        );
                    }
                  }),
            ),
          ),
        ),
        getTopBar().setColor(Colors.white).setPadding1(left: 20, right: 20),
        //顶部栏，包括搜索，定位
        Center(
          child: loadingAnim,
        ).setVisible2(loading)
      ],
    ).setPadding1(top: 6 + getStatusBarHeight());
  }

  ///---------------------------------------------------------------------------
  /// 下拉刷新
  ///---------------------------------------------------------------------------
  void _onRefresh() async {
    //模拟网络请求
    await Future.delayed(Duration(milliseconds: 1000));
    //结束下拉
    _refreshController.refreshCompleted();
  }

  ///---------------------------------------------------------------------------
  /// 设置顶部栏
  ///---------------------------------------------------------------------------
  Widget getTopBar() {
    return Row(
      children: <Widget>[
        Image.asset(
          'assets/images/location_l.png',
          width: 12,
          height: 16,
          fit: BoxFit.cover,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          userCity,
          style: TextStyle(
              color: Config.BLACK_393649,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ).setGestureDetector(onTap: () {
          Navigator.of(context).pushNamed(AppRoute.CITY_LIST_PAGE);
        }),
        SizedBox(
          width: 20,
        ),
        Container(
          height: 32,
          decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.all(Radius.circular(18))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Text(
                textSuggestSearch,
                style: TextStyle(color: '#A5A3AC'.color(), fontSize: 12),
              )
            ],
          ),
        ).setGestureDetector(onTap: () {
          Navigator.of(context)
              .pushNamed(AppRoute.SEARCH_PAGE, arguments: searchWord);
        }).setExpanded(1)
      ],
    ).setSize(double.infinity, 30);
  }

  ///---------------------------------------------------------------------------
  /// 设置轮播图
  ///---------------------------------------------------------------------------
  Widget getBanner() {
    return Swiper(
      key: UniqueKey(),
      itemBuilder: (BuildContext context, int index) {
        return CachedNetworkImage(
          placeholder: (ctx, url) => Image.asset(Config.BANNER_COVER),
          imageUrl: bannerList[index].url,
          fit: BoxFit.cover,
          fadeOutDuration: Duration(milliseconds: 10),
          fadeInDuration: Duration(milliseconds: 300),
          width: context.getSrnW() - 40,
          height: 167.5,
        ).setGestureDetector(onTap: () {
          switch (bannerList[index].jumpType) {
          //1.静态 2.H5 3.权益 4.会员购买页
            case '1':
            case '2':
              if (bannerList[index].jumpUrl.isNotEmpty) {
                WebPlugin.show(bannerList[index].jumpUrl);
//                Navigator.of(context).pushNamed(AppRoute.WEB_PAGE,
//                    arguments: bannerList[index].jumpUrl);
              }
              break;
          }
//          when (data[it].jumpType) {
//            //1.静态 2.H5 3.权益 4.会员购买页
//            "1", "2" -> if (data[it].jumpUrl.isNotEmpty()) HeBeiHtmlActivity.start(act, data[it].jumpUrl)
//          "3" -> goTo<RightDetailActivity>("id" to data[it].itemId.s)
//          "4" -> if (!(SPUtils.getSP(act, "vip", false) as Boolean)) {
//          goTo<BuyVipActivity>()
//          } else {
//          goTo<BuyVipActivity>(BuyVipActivity.IS_RENEW to true, BuyVipActivity.VALIDITY to SPUtils.getSP(act, "date", "").s)
//          }
//        }
        });
      },
      itemCount: bannerList.length,
      pagination: SwiperCustomPagination(
          builder: (BuildContext context, SwiperPluginConfig config) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  bottom: 7,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 20,
                        height: 2,
                        color: config.activeIndex == 0
                            ? Colors.white
                            : Color(0x4dffffff),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 20,
                        height: 2,
                        color: config.activeIndex == 1
                            ? Colors.white
                            : Color(0x4dffffff),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 20,
                        height: 2,
                        color: config.activeIndex == 2
                            ? Colors.white
                            : Color(0x4dffffff),
                      )
                    ],
                  ),
                )
              ],
            );
          }),
      control: null,
      loop: true,
      //是否循环
      autoplay: true,
      autoplayDelay: 3000,
    ).setClipRRect(4).setSizedBox(width: double.infinity, height: 167.5);
  }

  ///---------------------------------------------------------------------------
  /// 获取副标签栏
  ///---------------------------------------------------------------------------
  Widget getSubBar() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: homeIconList.length,
        itemBuilder: (ctx, i) {
          return Row(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CachedNetworkImage(
                    placeholder: (ctx, url) => Image.asset(Config.ICON_COVER),
                    imageUrl: homeIconList[i].iconImg,
                    fit: BoxFit.cover,
                    fadeOutDuration: Duration(milliseconds: 10),
                    fadeInDuration: Duration(milliseconds: 10),
                    width: 54.5,
                    height: 34,
                  ).setClipRRect(17),
                  Text(
                    homeIconList[i].name,
                    style: TextStyle(fontSize: 12, color: "#ff393649".color()),
                  ),
                ],
              ).setSizedBox(width: 54.5).setGestureDetector(onTap: () {
//                if (!homeIconList[i].usable) {
//                  homeIconList[i].unusableTip.toast();
//                  return;
//                }
                switch (homeIconList[i].type) {
                  case 1:
                    switch (homeIconList[i].resourceId) {
                      case 1:
                      // 会员商城
                        Navigator.of(context).pushNamed(AppRoute.VIP_SHOP_PAGE);
                        break;
                      case 2:
                      // 禾卡专属
                        Navigator.of(context)
                            .pushNamed(AppRoute.HE_KA_ZHUAN_SHU);
                        break;
                      case 3:
                      // 话费充值
                        Navigator.of(context)
                            .pushNamed(AppRoute.PREPAID_REFILL_PAGE);
                        break;
                    }
                    break;
                  case 2:
                    Navigator.of(context).pushNamed(AppRoute.VIP_SHOP_PAGE,
                        arguments: homeIconList[i].resourceId);
                    break;
                }
              }),
              SizedBox(
                width: i == homeIconList.length - 1
                    ? 0
                    : (context.getSrnW() - (54.5 * homeIconList.length) - 40) /
                    (homeIconList.length - 1),
              ),
            ],
          );
        }).setSizedBox(height: 52, width: double.infinity);
  }

  ///---------------------------------------------------------------------------
  /// 获取专区列表
  ///---------------------------------------------------------------------------
  Widget getAreaList() {
    return ListView.builder(
        shrinkWrap: true, //解决无限高度问题
        physics: NeverScrollableScrollPhysics(), //禁用滑动事件
        itemCount: areaList.length,
        itemBuilder: (ctx, i) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: i == 0 ? 0 : 30,
              ),
              Row(
                children: <Widget>[
                  Text(
                    areaList[i].name,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Config.BLACK_393649),
                  ),
                  SizedBox(
                    width: 1,
                  ).setExpanded(1),
                  Text(
                    "进入专区",
                    style: TextStyle(fontSize: 12, color: "#ffa5a3ac".color()),
                  ).setGestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            AppRoute.PREFECTURE_PAGE, arguments: areaList[i].id);
                      }
                  ),
                  Image.asset(
                    Config.DETAIL_LIGHT,
                    width: 11,
                    height: 11,
                    fit: BoxFit.cover,
                  )
                ],
              ).setPadding1(left: 20, right: 20),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 173, //注意这里必须制定ListView高度，否则无法显示
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: areaList[i].pageVO.results.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: index == 0 ? 20 : 12,
                              ),
                              CachedNetworkImage(
                                imageUrl:
                                areaList[i].pageVO.results[index].logo,
                                width: (ctx.getSrnW() - 52) / 2,
                                height: 121,
                                fit: BoxFit.cover,
                                placeholder: (ctx, url) =>
                                    Image.asset(
                                      Config.RIGHT_COVER,
                                      width: (context.getSrnW() - 52) / 2,
                                      height: 121,
                                      fit: BoxFit.fill,
                                    ),
                                fadeOutDuration: Duration(milliseconds: 50),
                              ).setClipRRect(4.0),
                              SizedBox(
                                width: index ==
                                    areaList[i].pageVO.results.length - 1
                                    ? 20
                                    : 0,
                              ),
                            ],
                          ),
                          getAreaListItem(
                              areaList[i].pageVO.results[index], index == 0)
                        ],
                      ).setGestureDetector(onTap: () {
                        Navigator.of(context).pushNamed(
                            AppRoute.RIGHT_DETAIL_PAGE,
                            arguments:
                            areaList[i].pageVO.results[index].id);
                      });
                    }),
              )
            ],
          );
        });
  }

  ///---------------------------------------------------------------------------
  /// 获取专区列表中的权益列表
  ///---------------------------------------------------------------------------
  List<Widget> getRightList(List<Result> results) {
    List<Widget> list = [];
    results.asMap().forEach((i, item) {
      list.add(Row(
        children: <Widget>[
          SizedBox(
            width: i == 0 ? 20 : 12,
          ),
          Image.network(
            item.logo,
            width: (context.getSrnW() - 52) / 2,
            height: 121,
            fit: BoxFit.cover,
          ).setClipRRect(4.0),
          SizedBox(
            width: i == results.length - 1 ? 20 : 0,
          ),
        ],
      ));
    });
    return list;
  }

  ///===========================================================================
  /// 保持页面状态
  ///===========================================================================
  @override
  bool get wantKeepAlive => true;

  ///---------------------------------------------------------------------------
  /// 定位并渲染专区列表
  ///---------------------------------------------------------------------------
  void doLocateAndRenderAreaList() {
    AmapPlugin.startLocate((Location location) {
      setState(() {
        userCity = location.cityName.replaceAll('市', '');
      });
      Req.getHomeLabel1((List<HomeLabelData> labels, String json) {
        setState(() {
          //注意这里不要使用addAll
          areaList = labels;
        });
        loading = false;
        //网络请求结束后，一定要停止动画
        keyLoading.currentState.stopAnimation();
        FileUtils.writeFileToTemp(context, 'home_label_data.txt', json);
      });
    });
  }

  ///---------------------------------------------------------------------------
  /// 渲染轮播图
  ///---------------------------------------------------------------------------
  void renderBanner() {
    Req.getBannerInfo1((List<BannerData1> list, String json) {
      setState(() {
        bannerList = list;
      });
      FileUtils.writeFileToTemp(context, 'banner_info_data.txt', json);
    });
  }

  ///---------------------------------------------------------------------------
  /// 渲染首页标签
  ///---------------------------------------------------------------------------
  void renderHomeIcon() {
    Req.getHomeIcon((List<HomeIconData> iconList, String json) {
      setHomeIconState(iconList);
      FileUtils.writeFileToTemp(context, 'home_icon_data.txt', json);
    });
  }

  ///---------------------------------------------------------------------------
  /// 初始化对象
  ///---------------------------------------------------------------------------
  void init() {
    loadingAnim = FrameAnimationImage(
      keyLoading,
      Global.netLoadingImgList,
      width: 200,
      height: 200,
      interval: 20,
      start: true,
    );

    _refreshController = RefreshController(initialRefresh: false);

    FileUtils.getStringFromTemp('banner_info_data.txt', (s) {
      List list = json.decode(s);
      List<BannerData1> dataList =
      list.map((data) => BannerData1.fromJson(data)).toList();
      setState(() {
        bannerList = dataList;
      });
    });

    FileUtils.getStringFromTemp('home_icon_data.txt', (s) {
      List list = json.decode(s);
      List<HomeIconData> dataList =
      list.map((data) => HomeIconData.fromJson(data)).toList();
      setHomeIconState(dataList);
    });

    FileUtils.getStringFromTemp('home_label_data.txt', (s) {
      List list = json.decode(s);
      List<HomeLabelData> dataList =
      list.map((data) => HomeLabelData.fromJson(data)).toList();
      setState(() {
        areaList = dataList;
      });
    });
  }

  ///---------------------------------------------------------------------------
  /// 获取专区列表项的名称、价格等信息
  ///---------------------------------------------------------------------------
  Widget getAreaListItem(Result result, bool isFirst) {
    /*
    vipType	integer($int32) 禾卡价格 0未知 1有 2无
     */
    if (result.payWay == 2) {
      return getFreeItem(result, isFirst);
    } else {
      if (result.vipPrice.toDouble() == 0.0) {
        return getOnePriceItem(result);
      } else {
        if (result.vipId == '0') {
          return getNormalItem(result);
        } else {
          if (result.vipType == 1)
            return getDeletePriceItem(result, isFirst);
          else {
            return getOnePriceItem(result);
          }
        }
      }
    }
  }

  void setHomeIconState(List<HomeIconData> iconList) {
    setState(() {
      homeIconList = iconList;
    });
  }
}

///---------------------------------------------------------------------------
/// 普通列表项
///---------------------------------------------------------------------------
Widget getNormalItem(Result result) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: 12,
      ),
      Text(
        result.name,
        style: TextStyle(fontSize: 14, color: Config.BLACK_303133),
      ),
      Text(
        '¥ ${result.price}',
        style: TextStyle(
            fontSize: 20, color: Config.BLACK_303133, fontFamily: 'money'),
      )
    ],
  );
}

///---------------------------------------------------------------------------
/// 只有一个价格的列表项
///---------------------------------------------------------------------------
Widget getOnePriceItem(Result result) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: 12,
      ),
      Text(
        result.name,
        style: TextStyle(fontSize: 14, color: Config.BLACK_303133),
      ),
      Text(
        '¥ ${result.price}',
        style: TextStyle(
            fontSize: 20, color: Config.BLACK_303133, fontFamily: 'money'),
      )
    ],
  );
}

///---------------------------------------------------------------------------
/// 带删除价格的列表项
///---------------------------------------------------------------------------
Widget getDeletePriceItem(Result result, bool isFirst) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: 11,
      ),
      Text(
        result.name,
        style: TextStyle(fontSize: 14, color: Config.BLACK_303133),
      ).setMargin1(left: isFirst ? 20 : 1),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: isFirst ? 20 : 12,
          ),
          VipPriceText(
            price: result.vipPrice.toString(),
            bigFontSize: 20,
            smallFontSize: 12,
          ),
          Container(
            child: Image.asset(Config.HECARD_PRICE),
            width: 22,
            height: 10,
            margin: EdgeInsets.only(bottom: 3),
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            child: Text(
              '¥ ${result.price}',
              style: TextStyle(
                fontSize: 12, color: Config.GREY_C0C4CC,
                decoration: TextDecoration.lineThrough, //删除线
                decorationColor: Config.GREY_C0C4CC,
              ),
            ),
          )
        ],
      )
    ],
  );
}

///---------------------------------------------------------------------------
/// 免费领列表项
///---------------------------------------------------------------------------
Widget getFreeItem(Result result, bool isFirst) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 12,
        ),
        Text(
          result.name.maxLength(10),
          style: TextStyle(fontSize: 14, color: Config.BLACK_303133),
        ),
        Text(
          '免费领',
          style: TextStyle(fontSize: 12, color: Config.RED_B3926F),
        )
      ],
    ),
    padding: EdgeInsets.only(left: isFirst ? 20 : 12),
  );
}
