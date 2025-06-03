import 'package:flutter/material.dart';
import 'custom_textfield.dart.dart';

class AlimentoDensidadWidget extends StatelessWidget {
  final TextEditingController lbsHaConsumoController;
  final TextEditingController lbsHaActualCampoController;
  final TextEditingController fcaCampoController;
  final TextEditingController fcaConsumoController;
  final TextEditingController rendimientoLbsSacoController;

  const AlimentoDensidadWidget({
    super.key,
    required this.lbsHaConsumoController,
    required this.lbsHaActualCampoController,
    required this.fcaCampoController,
    required this.fcaConsumoController,
    required this.rendimientoLbsSacoController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        margin: const EdgeInsets.only(top: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _LabelText('LBS/Ha Consumo'),
            CustomTextField(
              controller: lbsHaConsumoController,
              label: '0.00',
              keyboardType: TextInputType.number,
              isReadOnly: false,
            ),
            const _LabelText('LBS/Ha Actual Campo'),
            CustomTextField(
              controller: lbsHaActualCampoController,
              label: '0.00',
              keyboardType: TextInputType.number,
              isReadOnly: false,
            ),
            const _LabelText('FCA CAMPO'),
            CustomTextField(
              controller: fcaCampoController,
              label: '0.00',
              keyboardType: TextInputType.number,
              isReadOnly: false,
            ),
            const _LabelText('FCA CONSUMO'),
            CustomTextField(
              controller: fcaConsumoController,
              label: '0.00',
              keyboardType: TextInputType.number,
              isReadOnly: false,
            ),
            const _LabelText('Rendimiento lbs/saco'),
            CustomTextField(
              controller: rendimientoLbsSacoController,
              label: '0.00',
              keyboardType: TextInputType.number,
              isReadOnly: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _LabelText extends StatelessWidget {
  final String text;

  const _LabelText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
      ),
    );
  }
}
