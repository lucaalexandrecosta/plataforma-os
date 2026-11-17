// Rótulos em português dos códigos que o servidor devolve. Os códigos são os
// mesmos do banco (docs/03); o que não estiver aqui aparece como veio.

const workOrderStatusLabels = {
  'requested': 'Solicitada',
  'open': 'Aberta',
  'scheduled': 'Agendada',
  'in_progress': 'Em atendimento',
  'on_hold': 'Pendente',
  'completed': 'Concluída',
  'closed': 'Encerrada',
  'cancelled': 'Cancelada',
};

/// Status "em aberto", na ordem do ciclo (igual ao filtro `openOnly`).
const openWorkOrderStatuses = ['requested', 'open', 'scheduled', 'in_progress', 'on_hold'];

const priorityLabels = {'low': 'Baixa', 'normal': 'Normal', 'high': 'Alta', 'urgent': 'Urgente'};

const holdReasonLabels = {
  'awaiting_part': 'Aguardando peça',
  'awaiting_customer': 'Aguardando cliente',
  'needs_return': 'Precisa de retorno',
  'awaiting_approval': 'Aguardando aprovação',
  'other': 'Outro',
};

const cancellationReasonLabels = {
  'customer_cancelled': 'Cancelada pelo solicitante',
  'created_in_error': 'Aberta por engano',
  'other': 'Outro',
};

const entryMethodLabels = {
  'qr_token': 'QR code',
  'short_code': 'Código da etiqueta',
  'asset_list': 'Lista de bens',
  'backoffice': 'Backoffice',
};

const originLabels = {'backoffice': 'Backoffice', 'technician_app': 'App do técnico'};

const assetStatusLabels = {
  'in_stock': 'Em estoque',
  'installed': 'Instalado',
  'in_workshop': 'Na oficina',
  'retired': 'Baixado',
};

const ownershipLabels = {
  'tenant_loan': 'Próprio (comodato)',
  'tenant_rental': 'Próprio (locação)',
  'customer_owned': 'Do cliente',
};

const visitStatusLabels = {
  'scheduled': 'Agendada',
  'en_route': 'Em deslocamento',
  'on_site': 'No local',
  'paused': 'Pausada',
  'finished': 'Finalizada',
  'cancelled': 'Desmarcada',
};

const visitOutcomeLabels = {
  'resolved': 'Resolvido',
  'needs_return': 'Precisa de retorno',
  'customer_absent': 'Cliente ausente',
  'not_executed': 'Não executado',
};

const checkInMethodLabels = {'qr': 'QR code', 'gps': 'GPS', 'manual': 'Manual'};

/// Status da OS em que dá para agendar visita (igual ao servidor).
const schedulableWorkOrderStatuses = {'open', 'scheduled', 'on_hold', 'in_progress'};

String label(Map<String, String> labels, String? code) => code == null ? '—' : labels[code] ?? code;
