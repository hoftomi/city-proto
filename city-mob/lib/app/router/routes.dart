/// App routes (go_router). The game's tabs are branches of a StatefulShellRoute.
class Routes {
  static const splash = '/';
  static const login = '/login';
  static const lobby = '/games';

  static String game(String id) => '/games/$id';
  static String join(String id) => '/games/$id/join';

  static String map(String id) => '/games/$id/play/map';

  /// The city view; the city and the district (trade | politics | espionage) are query parameters, so it's deep-linkable.
  static String city(String id, {String? cityId, String? district}) => Uri(
        path: '/games/$id/play/city',
        queryParameters: {'c': ?cityId, 'd': ?district},
      ).toString();
  static String reports(String id) => '/games/$id/play/reports';
  static String orders(String id) => '/games/$id/play/orders';
  static String ranking(String id) => '/games/$id/play/ranking';
}
