import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/planejamento_mensal_controller.dart';

class PlanejamentoMensalPage extends StatefulWidget {
  final PlanejamentoMensalController controller;

  const PlanejamentoMensalPage({super.key, required this.controller});

  @override
  State<PlanejamentoMensalPage> createState() => _PlanejamentoMensalPageState();
}

class _PlanejamentoMensalPageState extends State<PlanejamentoMensalPage> {
  final diasController = TextEditingController();
  final metaController = TextEditingController();
  final mesFormatado = DateFormat('MMMM/yyyy', 'pt_BR');
  DateTime? _mesDosCampos;

  @override
  void initState() {
    super.initState();
    widget.controller.carregar();
  }

  @override
  void dispose() {
    diasController.dispose();
    metaController.dispose();
    super.dispose();
  }

  void _preencherCampos() {
    final planejamento = widget.controller.resumo?.planejamento;
    final dias =
        planejamento?.diasPlanejados ?? _diasNoMes(widget.controller.mes);
    diasController.text = dias
        .clamp(0, _diasNoMes(widget.controller.mes))
        .toString();
    metaController.text = planejamento?.metaKmMensal.toString() ?? '';
    _mesDosCampos = widget.controller.mes;
  }

  int _diasNoMes(DateTime mes) => DateTime(mes.year, mes.month + 1, 0).day;

  void _ajustarDias(int valor) {
    final limite = _diasNoMes(widget.controller.mes);
    final ajustado = valor.clamp(0, limite);
    diasController.value = TextEditingValue(
      text: ajustado.toString(),
      selection: TextSelection.collapsed(offset: ajustado.toString().length),
    );
    setState(() {});
  }

  void _editarDias(String texto) {
    final valor = int.tryParse(texto);
    if (valor == null) return;
    final limite = _diasNoMes(widget.controller.mes);
    if (valor > limite) _ajustarDias(limite);
  }

  Future<void> _alterarMes(int deslocamento) async {
    final mes = widget.controller.mes;
    await widget.controller.alterarMes(
      DateTime(mes.year, mes.month + deslocamento),
    );
    if (mounted) _preencherCampos();
  }

  Future<void> _salvar() async {
    final dias = int.tryParse(diasController.text.trim());
    final meta = int.tryParse(metaController.text.trim());
    if (dias == null ||
        meta == null ||
        dias < 0 ||
        dias > _diasNoMes(widget.controller.mes) ||
        meta < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe dias e meta válidos.')),
      );
      return;
    }
    await widget.controller.salvar(diasPlanejados: dias, metaKmMensal: meta);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Planejamento salvo.')));
    }
  }

  String _numero(num valor, {int casas = 0}) {
    final formato = NumberFormat.decimalPatternDigits(
      locale: 'pt_BR',
      decimalDigits: casas,
    );
    return formato.format(valor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planejamento Mensal')),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final resumo = widget.controller.resumo;
          if (resumo != null &&
              !widget.controller.carregando &&
              _mesDosCampos != widget.controller.mes) {
            _preencherCampos();
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    tooltip: 'Mês anterior',
                    onPressed: () => _alterarMes(-1),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text(
                    mesFormatado.format(widget.controller.mes),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    tooltip: 'Próximo mês',
                    onPressed: () => _alterarMes(1),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    tooltip: 'Diminuir dias planejados',
                    onPressed: () => _ajustarDias(
                      (int.tryParse(diasController.text) ?? 0) - 1,
                    ),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Expanded(
                    child: TextField(
                      controller: diasController,
                      keyboardType: TextInputType.number,
                      onChanged: _editarDias,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'Dias planejados de trabalho',
                        suffixText:
                            'de ${_diasNoMes(widget.controller.mes)} dias',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Aumentar dias planejados',
                    onPressed: () => _ajustarDias(
                      (int.tryParse(diasController.text) ?? 0) + 1,
                    ),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: metaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Meta mensal de quilômetros',
                  suffixText: 'km',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: widget.controller.carregando ? null : _salvar,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Salvar planejamento'),
              ),
              const SizedBox(height: 24),
              if (resumo == null || !resumo.possuiPlanejamento)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Nenhum planejamento configurado para este mês.',
                    ),
                  ),
                )
              else ...[
                Text(
                  'Planejado x realizado',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const _CabecalhoComparacao(),
                _ComparacaoLinha(
                  'Quilômetros',
                  '${_numero(resumo.kmRealizados)} km',
                  '${_numero(resumo.planejamento!.metaKmMensal)} km',
                ),
                _ComparacaoLinha(
                  'Dias com jornada concluída',
                  _numero(resumo.diasTrabalhados),
                  _numero(resumo.planejamento!.diasPlanejados),
                ),
                _Linha(
                  'Média planejada por dia',
                  '${_numero(resumo.mediaPlanejadaKmDia ?? 0, casas: 1)} km/dia',
                ),
                _Linha(
                  'Meta atingida',
                  resumo.percentualMeta == null
                      ? '—'
                      : '${_numero(resumo.percentualMeta!, casas: 1)}%',
                ),
                const Divider(height: 28),
                Text(
                  'Restante / necessário',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                _Linha('Km restantes', '${_numero(resumo.kmRestantes)} km'),
                _Linha(
                  'Dias de trabalho restantes',
                  _numero(resumo.diasPlanejadosRestantes),
                ),
                Text(
                  'Dias planejados menos dias distintos com Jornada concluída; não são dias de calendário restantes.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                _Linha(
                  'Média necessária por dia',
                  '${_numero(resumo.mediaNecessariaKmDia ?? 0, casas: 1)} km/dia',
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Linha extends StatelessWidget {
  final String rotulo;
  final String valor;

  const _Linha(this.rotulo, this.valor);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(child: Text(rotulo)),
        const SizedBox(width: 12),
        Flexible(child: Text(valor, textAlign: TextAlign.end)),
      ],
    ),
  );
}

class _CabecalhoComparacao extends StatelessWidget {
  const _CabecalhoComparacao();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(top: 12, bottom: 4),
    child: Row(
      children: [
        Expanded(child: Text('Indicador')),
        SizedBox(width: 82, child: Text('Realizado', textAlign: TextAlign.end)),
        SizedBox(width: 82, child: Text('Planejado', textAlign: TextAlign.end)),
      ],
    ),
  );
}

class _ComparacaoLinha extends StatelessWidget {
  final String indicador;
  final String realizado;
  final String planejado;

  const _ComparacaoLinha(this.indicador, this.realizado, this.planejado);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(child: Text(indicador)),
        SizedBox(width: 82, child: Text(realizado, textAlign: TextAlign.end)),
        SizedBox(width: 82, child: Text(planejado, textAlign: TextAlign.end)),
      ],
    ),
  );
}
