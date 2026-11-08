// Confere se o schema.sql cabe nos modelos do Serverpod (achado do spike S2):
//  - todo valor de lista CHECK (... IN ('a', 'b')) vira valor de enum Dart
//    (serialized: byName, mesmo texto do banco), então precisa ser um
//    identificador válido e não pode estar na lista de palavras reservadas do
//    gerador;
//  - todo nome de coluna vira campo em camelCase, com a mesma lista.
// O Serverpod 4.1 não permite valor serializado diferente do nome do enum.
//
// Uso: node tool/db/check_enum_values.mjs [db/schema.sql]
import { readFileSync } from 'node:fs';

// serverpod_cli 4.1.1, lib/src/analyzer/models/validation/restrictions.dart
// (_globallyRestrictedKeywords). Atualizar junto com a versão do Serverpod.
const RESERVED = new Set([
  'toJson', 'toJsonForProtocol', 'fromJson', 'toString', 'hashCode', 'runtimeType', 'noSuchMethod', 'abstract',
  'else', 'import', 'super', 'as', 'enum', 'in', 'switch', 'assert', 'export', 'interface', 'sync', 'async',
  'extend', 'is', 'this', 'await', 'extension', 'library', 'throw', 'break', 'external', 'mixin', 'true', 'case',
  'factory', 'new', 'try', 'class', 'final', 'catch', 'false', 'null', 'typedef', 'on', 'var', 'const', 'finally',
  'operator', 'void', 'continue', 'for', 'part', 'while', 'covariant', 'function', 'rethrow', 'with', 'default',
  'get', 'return', 'yield', 'deferred', 'hide', 'set', 'do', 'if', 'show', 'dynamic', 'implements', 'static',
]);
const IDENT = /^[a-zA-Z_][a-zA-Z0-9_]*$/;

const file = process.argv[2] ?? 'db/schema.sql';
const sql = readFileSync(file, 'utf8').replace(/--[^\n]*/g, '');
const tableAt = (index) => [...sql.slice(0, index).matchAll(/CREATE TABLE app\.(\w+)/g)].pop()?.[1] ?? '?';
const camel = (name) => name.replace(/_([a-z0-9])/g, (_, c) => c.toUpperCase());

const problems = [];
for (const m of sql.matchAll(/(\w+)\s+IN\s*\(([^()]*)\)/g)) {
  const values = m[2].split(',').map((v) => v.trim());
  if (!values.every((v) => /^'[^']*'$/.test(v))) continue; // lista numérica ou de expressões
  for (const raw of values) {
    const v = raw.slice(1, -1);
    if (!IDENT.test(v)) problems.push(`${tableAt(m.index)}.${m[1]}: '${v}' não é identificador Dart válido`);
    else if (RESERVED.has(v)) problems.push(`${tableAt(m.index)}.${m[1]}: '${v}' é palavra reservada do Serverpod`);
  }
}
for (const t of sql.matchAll(/CREATE TABLE app\.(\w+)\s*\(([\s\S]*?)\n\);/g)) {
  for (const line of t[2].split('\n')) {
    const col = line.trim().match(/^([a-z_][a-z0-9_]*)\s+[a-z]/);
    if (col && !['unique', 'check', 'foreign', 'primary', 'constraint', 'exclude'].includes(col[1])) {
      if (RESERVED.has(camel(col[1]))) problems.push(`${t[1]}.${col[1]}: nome de coluna reservado no Serverpod`);
    }
  }
}

if (problems.length) {
  console.error(`[ENUMS] ${problems.length} problema(s) para os modelos do Serverpod:\n  ${problems.join('\n  ')}`);
  process.exit(1);
}
console.log('[ENUMS] valores de CHECK e nomes de coluna compatíveis com os modelos do Serverpod');
