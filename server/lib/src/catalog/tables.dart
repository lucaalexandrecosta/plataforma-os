import '../platform/ownership.dart';

const catalogOwnership = ModuleOwnership(
  module: 'catalog',
  owns: {
    'product_families',
    'products',
    'services',
    'symptoms',
    'symptom_applicabilities',
    'failure_causes',
    'resolution_codes',
    'checklist_templates',
  },
);
