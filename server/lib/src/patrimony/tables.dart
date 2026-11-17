import '../platform/ownership.dart';

const patrimonyOwnership = ModuleOwnership(
  module: 'patrimony',
  owns: {'asset_depreciation_profiles', 'depreciation_closings', 'depreciation_entries'},
);
