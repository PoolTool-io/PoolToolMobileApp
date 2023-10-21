class Constants {
  static const String PREFS_SHOWN_ONBOARDING = "PREFS_SHOWN_ONBOARDING";
  static const String THEME_STATUS = "THEME_STATUS";
  static const String USER_ID = "USER_ID";
  static const String PREFS_ADDED_DEFAULT_POOLS =
      "PREFS_ADDED_DEFAULT_MAINNET_POOL";
  static const String PREFS_SHOW_FAVORITE_POOL_UPDATES =
      "PREFS_SHOW_FAVORITE_POOL_UPDATES";
  static const String PREFS_FILTER_SATURATED = "PREFS_FILTER_SATURATED";
  static const String PREFS_FILTER_EXPENSIVE = "PREFS_FILTER_EXPENSIVE";
  static const String PREFS_FILTER_UNKNOWN = "PREFS_FILTER_UNKNOWN";
  static const String PREFS_FILTER_BLOCKLESS = "PREFS_FILTER_BLOCKLESS";
  static const String PREFS_FILTER_NOT_FROM_ITN = "PREFS_FILTER_NOT_FROM_ITN";
  static const String PREFS_FILTER_DISCONNECTED = "PREFS_FILTER_DISCONNECTED";
  static const String PREFS_FILTER_POOL_GROUPS = "PREFS_FILTER_POOL_GROUPS";
  static const String PREFS_FILTER_CHAT_READY = "PREFS_FILTER_CHAT_READY";
  static const String PREFS_FILTER_RETIRING = "PREFS_FILTER_RETIRING";
  static const String PREFS_FILTER_RETIRED = "PREFS_FILTER_RETIRED";
  static const String PREFS_DONT_SHOW_LANDSCAPE_HINT =
      "PREFS_DONT_SHOW_LANDSCAPE_HINT";
  static const String PREFS_MIGRATED_FAVOURITES = "PREFS_MIGRATED_FAVOURITES";
  static const String PREFS_REMOVED_FEATURED_POOL =
      "PREFS_REMOVED_FEATURED_POOL";
  static const String LOVE_POOL_ID =
      "95c4956f7a137f7fe9c72f2e831e6038744b6307d00143b2447e6443";
  static const String POOLTOOL_POOL_ID =
      "02d8d38081492f1c5163f3084efad8d51827e47c5c16351153e3def8";

  static const String ARROW_UP = "\u25b2";
  static const String ARROW_DOWN = "\u25bc";

  static const int EPOCH_LENGTH = 432000;

  static const String SATURATION_INFO =
      "A saturated stake pool has more stake delegated to it than is ideal for the network. Once a stake pool reaches 100% saturation, it will offer diminishing rewards. The saturation mechanism was designed to prevent centralization by encouraging delegators to delegate to different stake pools, and operators to set up alternative pools so that they can continue earning maximum rewards.";

  static const POOLTOOL_NOTIFICATIONS_CATEGORY = "pooltool";
  static const SATURATION_ALERT = "saturation_alert";
  static const BLOCK_PRODUCTION_ALERT = "block_production_alert";
  static const FEE_CHANGE_ALERT = "fee_change_alert";
  static const PLEDGE_ALERT = "pledge_alert";
  static const CHAT_ALERT = "chat_alert";
}
