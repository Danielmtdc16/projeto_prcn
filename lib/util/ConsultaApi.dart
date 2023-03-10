import 'dart:convert' as convert;

import 'package:projeto_procon/models/autuacao.dart';
import 'package:projeto_procon/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:projeto_procon/util/shared_var.dart';

class ConsultaApi {
  static var url_webservice = 'https://apiprocon.inforpiaui.app.br/apinota';
  static var url_login = url_webservice + '/loginapi';

  static Future<int> login(String username, String password, context) async {
    try{
      var response = await http.get(Uri.parse(url_login+"/"+username.trim()+"/"+password));
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['id'] != null) {
          User user = User.fromJson(jsonResponse, password);
          await SharedVar.setUser(user);
          return 1;
        }
        return 2;
      } else {
        return 0;
      }
    }catch(e){
      return 3;
    }
  }

  Future<List<Autuacao>> getAutuacoes() async{
    var _autuacoes = <Autuacao>[];
    try{
      var url = Uri.parse(ConsultaApi.url_webservice+"/listanotaautos/0/0/0");
      var response = await http.get(url);
      if(response.statusCode == 200){
        var autuacaoesJson = convert.jsonDecode(response.body);
        await SharedVar.setOffline("0");
        for(var autuacaoJson in autuacaoesJson){
          _autuacoes.add(Autuacao.fromJson(autuacaoJson));
          _autuacoes.last.salvo_servidor = 1;
        }
        await SharedVar.setAutos(convert.jsonEncode(_autuacoes));
      }else{
        await SharedVar.setOffline("1");
      }
    }catch(e){
      await SharedVar.setOffline("1");
    }
    var autuacaoesJson = convert.jsonDecode(await SharedVar.getAutoCelulars());
    for(var autuacaoJson in autuacaoesJson){
      Autuacao autuacao = Autuacao.fromJson(autuacaoJson);
      autuacao.salvo_servidor = 0;
      _autuacoes.add(autuacao);
    }

    return _autuacoes;
  }

  Future<List<Autuacao>> getAutuacoesOffline() async{
    var _autuacoes = <Autuacao>[];
    var autuacaoesJson = convert.jsonDecode(await SharedVar.getAutos());
    await SharedVar.setOffline("1");
    for(var autuacaoJson in autuacaoesJson){
      _autuacoes.add(Autuacao.fromJson(autuacaoJson));
    }
    var autuacaoesCelular = convert.jsonDecode(await SharedVar.getAutoCelulars());
    for(var autuacaoJson in autuacaoesCelular){
      Autuacao autuacao = Autuacao.fromJson(autuacaoJson);
      autuacao.salvo_servidor = 0;
      _autuacoes.add(autuacao);
    }

    return _autuacoes;
  }
  Future<List<Autuacao>> getAutuacoesOfflineCelular() async{
    var _autuacoes = <Autuacao>[];
    var autuacaoesJson = convert.jsonDecode(await SharedVar.getAutoCelulars());
    for(var autuacaoJson in autuacaoesJson){
      _autuacoes.add(Autuacao.fromJson(autuacaoJson));
    }
    return _autuacoes;
  }

  static Future<int> salvar_auto(Autuacao autuacao, context) async {
    var params = convert.jsonEncode({
      'notaauto': autuacao.toJson()});
    int idAuto = 0;
    print(params);
    try {
      Map<String, String> headers = {"Content-Type":  "application/json; charset=UTF-8"  };
      var response = await http.post(
          Uri.parse(url_webservice+"/savenotaauto"),headers: headers, body: params);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        idAuto = Autuacao
            .fromJson(jsonResponse)
            .id;
      }
    }catch(e){
      return 0;
    }
    return idAuto;
  }

  static Future<int> update_auto(Autuacao autuacao, context) async {
    var params = convert.jsonEncode({
      'notaauto': autuacao.toJson()});
    int idAuto = 0;
    try {
      Map<String, String> headers = {"Content-Type":  "application/json; charset=UTF-8"  };
      var response = await http.put(
          Uri.parse(url_webservice+"/alterarnotaauto/"+autuacao.id.toString()),headers: headers, body: params);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        idAuto = Autuacao
            .fromJson(jsonResponse)
            .id;
      }
    }catch(e){
      return 0;
    }
    return idAuto;
  }

  static Future<int> enviar_email(Autuacao autuacao, context) async {
    try{
      var url = Uri.parse(ConsultaApi.url_webservice+"/enviaremailautuado/"+autuacao.id.toString());
      var response = await http.get(url);
      print(ConsultaApi.url_webservice+"/enviaremailautuado/"+autuacao.id.toString());
      print(response.body);
      if(response.statusCode == 200){
        var jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse);
        if (jsonResponse['id'] != null) {
          return 1;
        }
      }
    }catch(e){
    }
    return 0;
  }

  static Future<http.StreamedResponse> uploadImagem(String path_imagem, int id) async {
    http.MultipartRequest request = http.MultipartRequest('PUT', Uri.parse(url_webservice+'/alterarnotaauto/'+id.toString()));
    if(path_imagem != null) {
      File _file = File(path_imagem);
      request.files.add(http.MultipartFile('notaauto[assinatura_imagem]', _file.readAsBytes().asStream(), _file.lengthSync(), filename: _file.path.split('/').last));
    }
    http.StreamedResponse response = await request.send();
    return response;
  }



}