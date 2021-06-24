import 'package:flutter/material.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';

class BarcodeScannerPage extends StatefulWidget {
  BarcodeScannerPage({Key? key}) : super(key: key);

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Escaneie o código de barras do boleto",
          style: TextStyles.buttonBackground,
        ),
        leading: BackButton(
          color: AppColors.background,
        ),
      ),
      body: Column(
        children: [
          Expanded(child: Container(color: Colors.black)),
          Expanded(child: Container(color: Colors.transparent)),
          Expanded(child: Container(color: Colors.black)),
        ],
      ),
    );
  }
}
