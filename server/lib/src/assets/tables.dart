import '../platform/ownership.dart';

const assetsOwnership = ModuleOwnership(
  module: 'assets',
  owns: {'assets', 'asset_assignments', 'qr_tag_batches', 'qr_tags'},
);
