enum Flavor { dev, uat, prod }

class AppConfig {
  static late Flavor flavor;
  static String get name => flavor.name;
  // later: base URLs per flavor go here
}