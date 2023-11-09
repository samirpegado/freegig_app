class FormatCurrency {
  String formatCurrency(String value) {
    // Remove todos os caracteres não numéricos
    value = value.replaceAll(RegExp(r'[^\d]'), '');

    // Se o valor for vazio, retorne vazio
    if (value.isEmpty) {
      return '';
    }

    // Transforma o valor em um número inteiro
    int intValue = int.parse(value);

    // Formata o número como uma string com duas casas decimais
    String formattedValue =
        (intValue / 100).toStringAsFixed(2).replaceAll('.', ',');

    return formattedValue;
  }
}
