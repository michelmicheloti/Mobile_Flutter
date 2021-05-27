import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:agenda/Utils/globals.dart' as globals;

class Paciente {
  final String _baseUri =
      'https://flutter-mobile-3e560-default-rtdb.firebaseio.com/pacientes';
  final _client = http.Client();
  List<String> listaPaciente = [];
  final String? id;
  final String? nomePaciente;
  final String? clinica;
  final String? valorConsulta;
  final String? dataAtendimento;
  final String? statusAtendimento;

  Paciente(
      {this.id,
      this.nomePaciente,
      this.clinica,
      this.valorConsulta,
      this.statusAtendimento,
      this.dataAtendimento});

  Future<List<String>> carregaPaciente() async {
    try {
      var paciente;
      var response = await _client.get(Uri.parse("$_baseUri.json"));

      globals.listaPacientes.clear();
      if (response.body != "null") {
        Map<String, dynamic> data = json.decode(response.body);
        data.forEach((idPaciente, pacienteData) {
          paciente = {
            idPaciente,
            pacienteData['nomePaciente'],
            pacienteData['clinica'],
            pacienteData['statusAtendimento'],
            pacienteData['valorConsulta'],
            pacienteData['dataAtendimento'],
          };

          globals.listaPacientes.add(paciente.toString());
          listaPaciente.add(paciente.toString());
        });
      }

      return listaPaciente;
    } finally {
      _client.close();
    }
  }

  Future<void> addPaciente() async {
    try {
      var uriResponse = await _client.post(Uri.parse("$_baseUri.json"),
          body: json.encode({
            'nomePaciente': this.nomePaciente,
            'clinica': this.clinica,
            'statusAtendimento': 'false',
            'valorConsulta': this.valorConsulta,
            'dataAtendimento': this.dataAtendimento
          }));

      await carregaPaciente();
      print(uriResponse);
    } finally {
      _client.close();
    }
  }

  Future<void> removePaciente(id) async {
    id = id.toString().replaceAll("[{", "");
    try {
      final http.Response response = await http.delete(
        Uri.parse("$_baseUri/$id.json"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      await carregaPaciente();
      print(response);
    } finally {
      _client.close();
    }
  }

  Future<void> updateStatusAtendimento(id) async {
    id = id.toString().replaceAll("[{", "");
    try {
      final http.Response response = await http.patch(
        Uri.parse("$_baseUri/$id.json"),
        body: json.encode({
          'statusAtendimento': "true",
        }),
      );
      await carregaPaciente();
      print(response);
    } finally {
      _client.close();
    }
  }

  Future<void> update(id) async {
    id = id.toString().replaceAll("[", "");
    try {
      final http.Response response = await http.patch(
        Uri.parse("$_baseUri/$id.json"),
        body: json.encode({
          'nomePaciente': this.nomePaciente,
          'clinica': this.clinica,
          'valorConsulta': this.valorConsulta,
          'dataAtendimento': this.dataAtendimento
        }),
      );
      await carregaPaciente();
      print(response);
    } finally {
      _client.close();
    }
  }
}
