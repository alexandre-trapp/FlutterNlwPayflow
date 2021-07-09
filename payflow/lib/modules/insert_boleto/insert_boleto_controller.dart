class InsertBoletoController {
  String? validateName(String? value) =>
      value?.isEmpty ?? true ? "O nome não pode ser vazio" : null;

  String? validateDueDate(String? value) =>
      value?.isEmpty ?? true ? "A data de vencimento não pode ser vazia" : null;

  String? validateMoneyValue(String? value) =>
      value?.isEmpty ?? true ? "Insira um valor maior que R\$ 0,00" : null;

  String? validateBarcode(String? value) =>
      value?.isEmpty ?? true ? "O código do boleto não pode ser vazio" : null;
}
