import 'package:flutter/cupertino.dart';
import 'package:wobei/my_lib/utils/PathUtils.dart';
import 'package:wobei/my_lib/utils/StorageUtils.dart';

///*****************************************************************************
///
/// 管理所有配置信息
///
///*****************************************************************************
class Config{
  ///---------------------------------------------------------------------------
  /// 测试资源
  ///---------------------------------------------------------------------------
  static const String TEST_IMG = 'https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3321238736,733069773&fm=26&gp=0.jpg';
  static const String TEST_IMG1 = 'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3882521289,1164860711&fm=26&gp=0.jpg';

  ///---------------------------------------------------------------------------
  /// 颜色资源
  ///---------------------------------------------------------------------------
  static const Color BLACK_393649 = Color(0xFF393649);
  static const Color BLACK_303133 = Color(0xFF303133);
  static const Color GREY_C9C8CD = Color(0xFFC9C8CD);
  static const Color GREY_C0C4CC = Color(0xFFC0C4CC);
  static const Color GREY_A5A3AC = Color(0xFFA5A3AC);
  static const Color GREY_909399 = Color(0xFF909399);
  static const Color RED_B3926F = Color(0xFFB3926F);
  static const Color GOLD_FFE2C0 = Color(0xFFFFE2C0);
  //黑色按钮按下后的背景色
  static const Color BTN_TAP_DOWN = Color(0x66303133);
  //禁用按钮背景色
  static const Color BTN_ENABLE_FALSE = Color(0xff909399);
  //分割线颜色
  static const Color DIVIDER_COLOR = Color(0xffedecee);


  ///---------------------------------------------------------------------------
  /// 图片资源
  ///---------------------------------------------------------------------------
  static const String COVER_100_100 = 'assets/images/cover_100_100.png';
  static const String COVER_88_66 = 'assets/images/cover_88_66.png';
  static const String COVER_120_90 = 'assets/images/cover_120_90.png';
  static const String DEFAULT_AVATAR = 'assets/images/default_avatar.png';
  static const String ICON_COVER = 'assets/images/icon_cover.png';
  static const String BANNER_COVER = 'assets/images/banner_cover.png';
  static const String RIGHT_COVER = 'assets/images/right_cover.png';
  static const String ACTIONBAR_CLOSE = 'assets/images/actionbar_close.png';
  static const String ARC = 'assets/images/arc.png';
  static const String ARC_GREY = 'assets/images/arc_grey.png';
  static const String BACK_BLACK = 'assets/images/back_black.png';
  static const String BACK_GREY = 'assets/images/back_grey.png';
  static const String BACK_WHITE = 'assets/images/back_white.png';
  static const String CHANGE_COVER = 'assets/images/change_cover.png';
  static const String CHANGE_DIALOG = 'assets/images/change_dialog.png';
  static const String CHECK_BLACK = 'assets/images/check_black.png';
  static const String CHECK_BLACKBG = 'assets/images/check_blackbg.png';
  static const String CHECK_BLACK_BG = 'assets/images/check_black_bg.png';
  static const String CHECK_GOLD = 'assets/images/check_gold.png';
  static const String CHECK_GOLDBG = 'assets/images/check_goldbg.png';
  static const String CHECK_GOLDBORDER = 'assets/images/check_goldborder.png';
  static const String CHECK_GREYBORDER = 'assets/images/check_greyborder.png';
  static const String CITY_CHECK_GOLD = 'assets/images/city_check_gold.png';
  static const String CLASSIFICATION = 'assets/images/classification.png';
  static const String CLEAR = 'assets/images/clear.png';
  static const String CLOSE = 'assets/images/close.png';
  static const String CONSUMMATION = 'assets/images/consummation.png';
  static const String CONTACTS = 'assets/images/contacts.png';
  static const String COPY = 'assets/images/copy.png';
  static const String COUPONDIALOG_BACK = 'assets/images/coupondialog_back.png';
  static const String COUPONDIALOG_CLOSE = 'assets/images/coupondialog_close.png';
  static const String COUPONDIALOG_FRONT = 'assets/images/coupondialog_front.png';
  static const String COUPONDIALOG_MIDDLE = 'assets/images/coupondialog_middle.png';
  static const String DEFAULT_BG = 'assets/images/default_bg.png';
  static const String DETAIL = 'assets/images/detail.png';
  static const String DETAIL_HECARD = 'assets/images/detail_hecard.png';
  static const String DETAIL_LIGHT = 'assets/images/detail_light.png';
  static const String DIALOG_CLOSE = 'assets/images/dialog_close.png';
  static const String DISTANCE = 'assets/images/distance.png';
  static const String ENVELOPE = 'assets/images/envelope.png';
  static const String EXCHANGE = 'assets/images/exchange.png';
  static const String EXCHANGE_DISABLE = 'assets/images/exchange_disable.png';
  static const String EXCLUSIVE = 'assets/images/exclusive.png';
  static const String FAILED = 'assets/images/failed.png';
  static const String FAILURE = 'assets/images/failure.png';
  static const String FLOAT_BTN = 'assets/images/float_btn.png';
  static const String FOLD = 'assets/images/fold.png';
  static const String FOLD_GOLD = 'assets/images/fold_gold.png';
  static const String FOLD_LIGHT = 'assets/images/fold_light.png';
  static const String GPS_BG = 'assets/images/gps_bg.png';
  static const String HEBEI = 'assets/images/hebei.png';
  static const String HEBEI_BG = 'assets/images/hebei_bg.png';
  static const String HECARD = 'assets/images/hecard.png';
  static const String HECARDVIPCARD = 'assets/images/hecardvipcard.png';
  static const String HECARDVIP_BG = 'assets/images/hecardvip_bg.png';
  static const String HECARD_ONLY = 'assets/images/hecard_only.png';
  static const String HECARD_ONLY_OBLIQUE = 'assets/images/hecard_only_oblique.png';
  static const String HECARD_PRICE = 'assets/images/hecard_price.png';
  static const String HECARD_PRICE_L = 'assets/images/hecard_price_l.png';
  static const String HE_LOG = 'assets/images/he_log.png';
  static const String HIGHLIGHT = 'assets/images/highlight.png';
  static const String HOME_ACTIVE = 'assets/images/home_active.png';
  static const String HOME_NORMAL = 'assets/images/home_normal.png';
  static const String ICON = 'assets/images/icon.png';
  static const String LOCATION_L = 'assets/images/location_l.png';
  static const String L_00 = 'assets/images/l_00.png';
  static const String L_01 = 'assets/images/l_01.png';
  static const String L_02 = 'assets/images/l_02.png';
  static const String L_03 = 'assets/images/l_03.png';
  static const String L_04 = 'assets/images/l_04.png';
  static const String L_05 = 'assets/images/l_05.png';
  static const String L_06 = 'assets/images/l_06.png';
  static const String L_07 = 'assets/images/l_07.png';
  static const String L_08 = 'assets/images/l_08.png';
  static const String L_09 = 'assets/images/l_09.png';
  static const String L_10 = 'assets/images/l_10.png';
  static const String L_11 = 'assets/images/l_11.png';
  static const String L_12 = 'assets/images/l_12.png';
  static const String L_13 = 'assets/images/l_13.png';
  static const String L_14 = 'assets/images/l_14.png';
  static const String L_15 = 'assets/images/l_15.png';
  static const String L_16 = 'assets/images/l_16.png';
  static const String L_17 = 'assets/images/l_17.png';
  static const String L_18 = 'assets/images/l_18.png';
  static const String L_19 = 'assets/images/l_19.png';
  static const String L_20 = 'assets/images/l_20.png';
  static const String L_21 = 'assets/images/l_21.png';
  static const String L_22 = 'assets/images/l_22.png';
  static const String L_23 = 'assets/images/l_23.png';
  static const String L_24 = 'assets/images/l_24.png';
  static const String L_25 = 'assets/images/l_25.png';
  static const String L_26 = 'assets/images/l_26.png';
  static const String L_27 = 'assets/images/l_27.png';
  static const String L_28 = 'assets/images/l_28.png';
  static const String L_29 = 'assets/images/l_29.png';
  static const String L_30 = 'assets/images/l_30.png';
  static const String L_31 = 'assets/images/l_31.png';
  static const String L_32 = 'assets/images/l_32.png';
  static const String L_33 = 'assets/images/l_33.png';
  static const String L_34 = 'assets/images/l_34.png';
  static const String L_35 = 'assets/images/l_35.png';
  static const String L_36 = 'assets/images/l_36.png';
  static const String L_37 = 'assets/images/l_37.png';
  static const String L_38 = 'assets/images/l_38.png';
  static const String L_39 = 'assets/images/l_39.png';
  static const String L_40 = 'assets/images/l_40.png';
  static const String L_41 = 'assets/images/l_41.png';
  static const String L_42 = 'assets/images/l_42.png';
  static const String L_43 = 'assets/images/l_43.png';
  static const String L_44 = 'assets/images/l_44.png';
  static const String L_45 = 'assets/images/l_45.png';
  static const String L_46 = 'assets/images/l_46.png';
  static const String L_47 = 'assets/images/l_47.png';
  static const String L_48 = 'assets/images/l_48.png';
  static const String MALL = 'assets/images/mall.png';
  static const String MAP = 'assets/images/map.png';
  static const String MESSAGE_DARK = 'assets/images/message_dark.png';
  static const String MESSAGE_WHITE = 'assets/images/message_white.png';
  static const String MYSELF_ACTIVE = 'assets/images/myself_active.png';
  static const String MYSELF_NORMAL = 'assets/images/myself_normal.png';
  static const String MZ_PUSH_NOTIFICATION_SMALL_ICON = 'assets/images/mz_push_notification_small_icon.png';
  static const String NETWORK_ERROR = 'assets/images/network_error.png';
  static const String OPENVIPCARD = 'assets/images/openvipcard.png';
  static const String ORDER_DETAIL_BG = 'assets/images/order_detail_bg.png';
  static const String OVAL = 'assets/images/oval.png';
  static const String OVERDUE = 'assets/images/overdue.png';
  static const String PASSWORDDIALOG_CLOSE = 'assets/images/passworddialog_close.png';
  static const String POPOVER = 'assets/images/popover.9.png';
  static const String PYQ = 'assets/images/pyq.png';
  static const String QUESTION = 'assets/images/question.png';
  static const String QUESTION_WHITE = 'assets/images/question_white.png';
  static const String RECEIVED = 'assets/images/received.png';
  static const String RECEIVED_COVER = 'assets/images/received_cover.png';
  static const String RECHARGE = 'assets/images/recharge.png';
  static const String RECORD = 'assets/images/record.png';
  static const String REDPACKET = 'assets/images/redpacket.png';
  static const String RED_PACKET = 'assets/images/red_packet.png';
  static const String REFRESH = 'assets/images/refresh.png';
  static const String RIGHT_ACTIVE = 'assets/images/right_active.png';
  static const String RIGHT_EXCHANGE = 'assets/images/right_exchange.png';
  static const String RIGHT_NORMAL = 'assets/images/right_normal.png';
  static const String SEARCH = 'assets/images/search.png';
  static const String SELECT = 'assets/images/select.png';
  static const String SELECTED = 'assets/images/selected.png';
  static const String SELECT_DISABLE = 'assets/images/select_disable.png';
  static const String SETTINGS_DARK = 'assets/images/settings_dark.png';
  static const String SETTINGS_WHITE = 'assets/images/settings_white.png';
  static const String SHADOW = 'assets/images/shadow.png';
  static const String SHARE_BLACK = 'assets/images/share_black.png';
  static const String SHARE_CARD = 'assets/images/share_card.png';
  static const String SHARE_GREY = 'assets/images/share_grey.png';
  static const String SNACKBAR_CLOSE = 'assets/images/snackbar_close.png';
  static const String SUCCESS = 'assets/images/success.png';
  static const String SUPPORTHEBEI = 'assets/images/supporthebei.png';
  static const String S_01 = 'assets/images/s_01.png';
  static const String S_02 = 'assets/images/s_02.png';
  static const String S_03 = 'assets/images/s_03.png';
  static const String S_04 = 'assets/images/s_04.png';
  static const String S_05 = 'assets/images/s_05.png';
  static const String S_06 = 'assets/images/s_06.png';
  static const String S_07 = 'assets/images/s_07.png';
  static const String S_08 = 'assets/images/s_08.png';
  static const String S_09 = 'assets/images/s_09.png';
  static const String S_10 = 'assets/images/s_10.png';
  static const String S_11 = 'assets/images/s_11.png';
  static const String S_12 = 'assets/images/s_12.png';
  static const String S_13 = 'assets/images/s_13.png';
  static const String S_14 = 'assets/images/s_14.png';
  static const String S_15 = 'assets/images/s_15.png';
  static const String S_16 = 'assets/images/s_16.png';
  static const String S_17 = 'assets/images/s_17.png';
  static const String S_18 = 'assets/images/s_18.png';
  static const String S_19 = 'assets/images/s_19.png';
  static const String S_20 = 'assets/images/s_20.png';
  static const String S_21 = 'assets/images/s_21.png';
  static const String S_22 = 'assets/images/s_22.png';
  static const String S_23 = 'assets/images/s_23.png';
  static const String S_24 = 'assets/images/s_24.png';
  static const String S_25 = 'assets/images/s_25.png';
  static const String S_26 = 'assets/images/s_26.png';
  static const String S_27 = 'assets/images/s_27.png';
  static const String S_28 = 'assets/images/s_28.png';
  static const String S_29 = 'assets/images/s_29.png';
  static const String S_30 = 'assets/images/s_30.png';
  static const String S_31 = 'assets/images/s_31.png';
  static const String S_32 = 'assets/images/s_32.png';
  static const String S_33 = 'assets/images/s_33.png';
  static const String S_34 = 'assets/images/s_34.png';
  static const String S_35 = 'assets/images/s_35.png';
  static const String S_36 = 'assets/images/s_36.png';
  static const String TIME = 'assets/images/time.png';
  static const String TRANSPORT_BG = 'assets/images/transport_bg.png';
  static const String UNFOLD = 'assets/images/unfold.png';
  static const String UNFOLD_LIGHT = 'assets/images/unfold_light.png';
  static const String UNFOLD_RED = 'assets/images/unfold_red.png';
  static const String UPDATE_BTN = 'assets/images/update_btn.png';
  static const String UPDATE_DIALOG = 'assets/images/update_dialog.png';
  static const String UPLOAD = 'assets/images/upload.png';
  static const String USED = 'assets/images/used.png';
  static const String VIP = 'assets/images/vip.png';
  static const String VIPLIFE_ACTIVE = 'assets/images/viplife_active.png';
  static const String VIPLIFE_NORMAL = 'assets/images/viplife_normal.png';
  static const String VIP_BG = 'assets/images/vip_bg.png';
  static const String VIP_EXCHANGE = 'assets/images/vip_exchange.png';
  static const String VIP_HECARD = 'assets/images/vip_hecard.png';
  static const String WALLET_BG = 'assets/images/wallet_bg.png';
  static const String WECHAT = 'assets/images/wechat.png';
  static const String WELCOME = 'assets/images/welcome.png';

}