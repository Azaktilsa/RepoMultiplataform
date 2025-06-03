import 'package:flutter/material.dart';
import 'datos_generales_table.dart';
import 'crecimiento_consumo_table.dart';
import 'densidades_diferencias_table.dart';
import 'planificacion_semanal_table.dart';
import 'aireadores_rendimiento_table.dart';
import 'totales_recomendaciones_table.dart';

class ResumenTablas extends StatelessWidget {
  final Map<String, String> data;
  final String typeFinca;

  const ResumenTablas({super.key, required this.data, required this.typeFinca});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DatosGeneralesTable(data: data, typeFinca: typeFinca),
        CrecimientoConsumoTable(data: data, typeFinca: typeFinca),
        DensidadesDiferenciasTable(data: data, typeFinca: typeFinca),
        PlanificacionSemanalTable(data: data, typeFinca: typeFinca),
        AireadoresRendimientoTable(data: data, typeFinca: typeFinca),
        TotalesRecomendacionesTable(data: data, typeFinca: typeFinca),
      ],
    );
  }
}
