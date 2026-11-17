// Gera os casos de paridade do motor de depreciação em Dart com o motor
// JavaScript do Painel de Depreciação (ENG.calcular).
//
// Uso: node tool/depreciation/fixtures_from_painel.mjs "<caminho do Painel de Depreciação.html>"
// Saída: packages/depreciation/test/fixtures/painel_js.json
//
// Os casos são pseudoaleatórios com semente fixa, então a saída só muda se o
// motor do painel mudar.
import { readFileSync, writeFileSync } from 'node:fs';
import vm from 'node:vm';

const htmlPath = process.argv[2];
if (!htmlPath) {
  console.error('Informe o caminho do HTML do painel.');
  process.exit(1);
}
const html = readFileSync(htmlPath, 'utf8');
const engineSrc = [...html.matchAll(/<script[^>]*>([\s\S]*?)<\/script>/g)]
  .map((m) => m[1])
  .find((s) => s.includes('const ENG ='));
if (!engineSrc) throw new Error('Motor ENG não encontrado no HTML.');
const ctx = {};
vm.createContext(ctx);
vm.runInContext(`${engineSrc}\nthis.ENG = ENG;`, ctx);
const ENG = ctx.ENG;

// Gerador determinístico (mulberry32).
let seed = 20261115;
const rnd = () => {
  seed |= 0; seed = (seed + 0x6d2b79f5) | 0;
  let t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
  t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
  return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
};
const pick = (a) => a[Math.floor(rnd() * a.length)];
const int = (lo, hi) => lo + Math.floor(rnd() * (hi - lo + 1));
const iso = (y, m, d) => `${y}-${String(m).padStart(2, '0')}-${String(d).padStart(2, '0')}`;
const dec = (n, d) => n.toFixed(d);

const cases = [];
for (let i = 0; i < 200; i++) {
  const y = int(2015, 2026), m = int(1, 12), d = int(1, ENG.diasNoMes(y, m));
  const metodoGer = pick(['linear', 'sda', 'sd', 'unidades']);
  const valor = dec(int(1000, 5000000) + int(0, 99) / 100, 2);
  const taxaFiscal = pick(['4', '10', '20', '25', '6.6667', '33.3333']);
  const taxaGer = pick(['4', '10', '12.5', '20', '6.6667', '15']);
  const iof = pick(['1', '1', '0.8287', '1.0523', '5.4321']);
  const iog = pick(['1', '1', '4.85', '0.9876']);
  const residualFiscal = pick(['0', '0', dec(Number(valor) * 0.1, 2)]);
  const residualGer = pick(['0', dec(Number(valor) * 0.05, 2), dec(Number(valor) * 0.2, 2)]);
  let dataBaixa = '';
  if (rnd() < 0.3) {
    const by = y + int(0, 8), bm = int(1, 12);
    dataBaixa = iso(by, bm, int(1, ENG.diasNoMes(by, bm)));
  }
  const bem = {
    valor, qtd: 1, dataInicio: iso(y, m, d), dataBaixa,
    prorata: pick(['dias', 'integral', 'seguinte']),
    iof, iog, taxaFiscal, turnos: pick(['1', '2', '3']),
    residualFiscal, metodoGer, taxaGer, residualGer,
    capacidade: metodoGer === 'unidades' ? String(int(1000, 100000)) : '0',
    producaoMes: metodoGer === 'unidades' ? String(int(10, 2000)) : '0',
  };
  const jsBem = Object.fromEntries(Object.entries(bem).map(([k, v]) =>
    [k, ['valor', 'iof', 'iog', 'taxaFiscal', 'residualFiscal', 'taxaGer', 'residualGer', 'capacidade', 'producaoMes'].includes(k) ? Number(v) : v]));
  jsBem.turnos = Number(bem.turnos);
  const r = ENG.calcular(jsBem);
  cases.push({
    input: bem,
    info: { vlrMio: dec(r.info.vlrMio, 5), vlrMgr: dec(r.info.vlrMgr, 5) },
    // Primeiros 24 meses, um a cada 12 e os 6 últimos: cobre início, viradas de
    // ano e o fechamento do saldo sem inflar o arquivo.
    months: r.meses.filter((_, j, a) => j < 24 || j % 12 === 0 || j >= a.length - 6).map((x) => [
      `${x.y}-${String(x.m).padStart(2, '0')}`,
      dec(x.cotDpm, 5), dec(x.cotDao, 5), dec(x.dprMes, 2), dec(x.dprAcu, 2),
      dec(x.cotDpg, 5), dec(x.cotDag, 5), dec(x.dprMesG, 2), dec(x.dagR, 2),
    ]),
  });
}

const out = new URL('../../packages/depreciation/test/fixtures/painel_js.json', import.meta.url);
writeFileSync(out, JSON.stringify({
  geradoPor: 'tool/depreciation/fixtures_from_painel.mjs',
  colunas: ['competencia', 'cotDpm', 'cotDao', 'dprMes', 'dprAcu', 'cotDpg', 'cotDag', 'dprMesG', 'dagR'],
  casos: cases,
}) + '\n');
console.log(`${cases.length} casos, ${cases.reduce((a, c) => a + c.months.length, 0)} meses.`);
