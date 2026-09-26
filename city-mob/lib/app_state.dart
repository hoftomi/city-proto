import 'api/api_client.dart';
import 'api/session.dart';
import 'auth/social_auth.dart';

/// Az alkalmazás egyetlen munkamenete és API-kliense (0.0.1: egyszerű, globális szolgáltatók).
final session = Session();
final api = Api(session);
final socialAuth = SocialAuth(api);
