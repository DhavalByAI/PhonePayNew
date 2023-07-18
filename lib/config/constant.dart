import 'dart:ui';
import 'package:flutter/material.dart';

class Constants {
  static const String BASE_URL = "https://phonepeproperty.com/api/";
  static const String APP_CONFIG_URL = BASE_URL + "action=app_config";
  static const String LOG_IN = BASE_URL + "login";
  static const String REGISTER = BASE_URL + "register";
  static const String FORGET_PASS = BASE_URL + "forgot_password";
  static const String SELECT_STATE = BASE_URL + "get_state";
  static const String SELECT_CITY = BASE_URL + "get_city";
  static const String SELECT_LOCALITY = BASE_URL + "get_locality";
  static const String DASHBORAD_PRODUCTS_URL = BASE_URL + "home_latest_ads";
  static const String CATEGORY_PRODUCTS_URL = BASE_URL + "get_search_post";
  static const String YOUR_PRODUCTS_URL = BASE_URL + "home_latest_ads";
  static const String DASHBORAD_FEATURED_PRODUCTS_URL =
      BASE_URL + "featured_urgent_ads";
  static const String PRODUCT_DETAILS = BASE_URL + "ad_detail";
  static const String TOP_PROJECTS = BASE_URL + "top_projectlist";
  static const String FETCH_DROPDOWNDATA = BASE_URL + "get_lead_dropdown_list";
  static const String ADD_LEAD = BASE_URL + "add_new_lead";
  static const String LEAD_LIST = BASE_URL + "get_lead_list_with_search";
  static const String LEAD_DETAILS = BASE_URL + "get_lead_by_id";
  static const String ADD_LEAD_BY_TYPE = BASE_URL + "add_lead_by_type";
  static const String DELET_LEAD_BY_TYPE = BASE_URL + "delete_lead_by_type";
  static const String UPDATE_LEAD_BY_TYPE = BASE_URL + "update_lead_by_type";

  //Category
  static const String CATEGORY_LIST = BASE_URL + "category";
  static const String SUB_CATEGORY_LIST = BASE_URL + "sub-category";

  //Enquire
  static const String SEND_INQUIREY = BASE_URL + "sendinquery";
  static const String GET_INQUIREY = BASE_URL + "getinquery";

  //upload post
  static const String POST_IMG = BASE_URL + "action=upload_product_picture";
  static const String POST_AD = BASE_URL + "save_post";
  static const String EDIT_POST =
      "https://phonepeproperty.com/api/v1/index.php";

  //Additional Info
  static const String ADDINOAL_INFO = BASE_URL + "getCustomFieldByCatIDJson";
  static const String ADDINOAL_INFO_POST = BASE_URL + "send_cusdata_getjson";

  //Google Maps API
  static const String MAP_API = "AIzaSyApImykeqdm2I7v3JnFJQMIjh_tqTtDPOA";

  //Google Admob
  static const String ANDROID_APP_ID = "ca-app-pub-3940256099942544~3347511713";
  //static const String ANDROID_APP_ID = "ca-app-pub-6775793802919123~9158587990";
  static const String BANNER_AD_ID_ANDROID =
      "ca-app-pub-3940256099942544/6300978111";
  //static const String BANNER_AD_ID_ANDROID ="ca-app-pub-6775793802919123/9074332672";
  static const String BANNER_AD_ID_IOS =
      "ca-app-pub-3940256099942544/2934735716";
  //native ad
  static const String NATIVE_AD_ID = "ca-app-pub-3940256099942544/2247696110";

  //delete Ad
  static const String DELETE_AD = BASE_URL + "delete_product";
}

const Color cBlue = Color(0xFF1266e3);
const Color cDarkBlue = Color(0xFF2540A2);
const Color kdarkgrey = Color(0xFF2B3238);
const Color kGreyone = Colors.grey;

const String kOneSingleUserId = "123456";
const String kOneSingleAppId = "306e0a43-be24-46a1-96b7-5dab06d0051f";
