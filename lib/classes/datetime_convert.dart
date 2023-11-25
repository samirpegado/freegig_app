class DateTimeConvert {
  // Função para converter a string de data para DateTime
  DateTime parseDate(String dateString) {
    // Divide a string em partes: dia, mês e ano
    List<String> dateParts = dateString.split('-');

    // Converte as partes para inteiros
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    // Retorna o objeto DateTime
    return DateTime(year, month, day);
  }
}
