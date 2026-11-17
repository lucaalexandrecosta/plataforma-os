// Rótulos em português dos códigos que o servidor devolve. Os códigos são os
// mesmos do banco (docs/03); o que não estiver aqui aparece como veio.

const visitStatusLabels = {
  'scheduled': 'Agendada',
  'en_route': 'A caminho',
  'on_site': 'No local',
  'paused': 'Pausada',
  'finished': 'Finalizada',
  'cancelled': 'Cancelada',
};

/// Visitas que ocupam o técnico agora (só uma por vez no servidor).
const activeVisitStatuses = {'en_route', 'on_site', 'paused'};

const outcomeLabels = {
  'resolved': 'Resolvido',
  'needs_return': 'Precisa de retorno',
  'customer_absent': 'Cliente ausente',
  'not_executed': 'Não executada',
};

/// Motivos aceitos pelo servidor quando a visita precisa de retorno.
const returnHoldReasonLabels = {'awaiting_part': 'Aguardando peça', 'needs_return': 'Precisa de retorno'};

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

const priorityLabels = {'low': 'Baixa', 'normal': 'Normal', 'high': 'Alta', 'urgent': 'Urgente'};

const checkInMethodLabels = {'qr': 'QR da etiqueta', 'gps': 'GPS', 'manual': 'Manual'};

String label(Map<String, String> labels, String? code) => code == null ? '—' : labels[code] ?? code;
