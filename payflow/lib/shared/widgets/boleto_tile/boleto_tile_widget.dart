import 'package:flutter/material.dart';
import 'package:payflow/shared/models/boleto_model.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';

class BoletoTileWidget extends StatelessWidget {
  final BoletoModel boletoModel;
  const BoletoTileWidget({Key? key, required this.boletoModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        boletoModel.name!,
        style: TextStyles.titleListTile,
      ),
      subtitle: Text(
        "Vence em ${boletoModel.dueDate}",
        style: TextStyles.captionBody,
      ),
      trailing: Text.rich(
        TextSpan(
          text: "R\$ ",
          style: TextStyles.trailingRegular,
          children: [
            TextSpan(
              text: "${boletoModel.value!.toStringAsFixed(2)}",
              style: TextStyles.trailingBold,
            ),
          ],
        ),
      ),
    );
  }
}
