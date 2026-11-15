import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart' as core;

import '../../platform/endpoints/endpoint_bases.dart';

/// `refreshJwtTokens.*` — renova a sessão de login (refresh token do módulo).
class RefreshJwtTokensEndpoint extends core.RefreshJwtTokensEndpoint {
  @override
  @unauthenticatedClientCall
  Future<core.AuthSuccess> refreshAccessToken(Session session, {String? refreshToken}) {
    session.useAnonymousContext();
    return super.refreshAccessToken(session, refreshToken: refreshToken);
  }
}
