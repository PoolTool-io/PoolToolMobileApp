class Environment {
  static const API_URL = String.fromEnvironment('POOL_TOOL_API_URL_V1',
      defaultValue: 'https://api.pooltool.io/v1/');
  static const ENVIRONMENT = String.fromEnvironment('POOL_TOOL_ENVIRONMENT',
      defaultValue: 'production');

  static String getEnvironment() {
    return "Mainnet";
  }
}
