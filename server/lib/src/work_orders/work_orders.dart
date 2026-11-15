/// Interface pública do módulo `work_orders` (camada 5, docs/02 §3.2).
library;

export '../generated/protocol.dart'
    show
        WorkOrder,
        WorkOrderChanges,
        WorkOrderDetail,
        WorkOrderInput,
        WorkOrderPage,
        WorkOrderStatusChange,
        WorkOrderType,
        WorkOrderTypeInput;
export 'internal/work_orders.dart' show WorkOrders;
export 'tables.dart' show workOrdersOwnership;
