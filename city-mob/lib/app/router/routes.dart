/// Az app útvonalai (go_router). A játék fülei egy StatefulShellRoute ágai.
class Routes {
  static const splash = '/';
  static const login = '/login';
  static const lobby = '/games';

  static String game(String id) => '/games/$id';
  static String join(String id) => '/games/$id/join';

  static String map(String id) => '/games/$id/play/map';

  /// A városnézet; a város és a negyed (keresk | polit | kem) lekérdezési paraméter, így mélylinkelhető.
  static String city(String id, {String? cityId, String? district}) => Uri(
        path: '/games/$id/play/city',
        queryParameters: {'c': ?cityId, 'd': ?district},
      ).toString();
  static String reports(String id) => '/games/$id/play/reports';
  static String orders(String id) => '/games/$id/play/orders';
  static String ranking(String id) => '/games/$id/play/ranking';
}
