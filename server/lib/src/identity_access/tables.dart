import '../platform/ownership.dart';

const identityAccessOwnership = ModuleOwnership(
  module: 'identity_access',
  owns: {
    'users',
    'roles',
    'permissions',
    'role_permissions',
    'tenant_memberships',
    'tenant_membership_roles',
    'idempotency_keys',
    'devices',
    'otp_challenges',
    'auth_sessions',
    'support_sessions',
  },
);
