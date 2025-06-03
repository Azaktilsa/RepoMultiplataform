class ResultadoData {
  String campo;
  String valor;

  ResultadoData(this.campo, this.valor);

  bool estaCompleto() {
    return campo != null && valor!.isNotEmpty;
  }
}
