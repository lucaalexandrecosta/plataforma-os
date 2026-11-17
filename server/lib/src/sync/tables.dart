import '../platform/ownership.dart';

const syncOwnership = ModuleOwnership(
  module: 'sync',
  owns: {'sync_mutations', 'sync_tombstones', 'device_sync_scopes', 'sync_review_items', 'sync_runs'},
);
