import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:projeto_procon/constantes/constantes.dart';
import 'package:projeto_procon/models/autuacao.dart';
import 'package:projeto_procon/models/user.dart';
import 'package:projeto_procon/pages/tela_opcap_assinatura.dart';

import 'package:projeto_procon/util/ConsultaApi.dart';
import 'package:projeto_procon/util/messages.dart';
import 'package:projeto_procon/util/nav.dart';
import 'package:projeto_procon/util/shared_var.dart';
import 'package:projeto_procon/widgets/menu_user.dart';
import '../widgets/text_field.dart';
import '../widgets/container_personalizado.dart';
import '../util/consultaCEP.dart';

// ignore: must_be_immutable
class TelaCadastroAuto extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String path_assinatura;
  Autuacao? autuacao;

  // ignore: non_constant_identifier_names
  TelaCadastroAuto({Key? key, this.path_assinatura = '', this.autuacao}) : super(key: key);

  @override
  State<TelaCadastroAuto> createState() => _TelaCadastroAutoState();
}

class _TelaCadastroAutoState extends State<TelaCadastroAuto> {
  String dataLocalAutuacao = "Data da Infração";
  String timeLocalAutuacao = "Horário da Infração";

  String dataCominacaoLegal = "Data da Infração";
  String timeCominacaoLegal = "Horário da Infração";

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      setState(() {
        timeLocalAutuacao = value!.format(context).toString();
      });
    });
  }

  String data3via = "Selecione a Data";

  final _razaoSocialController = TextEditingController();
  final _nomeFantasiaController = TextEditingController();
  final _atividadeController = TextEditingController();
  final _cnpjCpfController = TextEditingController();
  final _cepEmpresaController = TextEditingController();
  final _logradouroEmpresaController = TextEditingController();
  final _numeroEmpresaController = TextEditingController();
  final _bairroEmpresaController = TextEditingController();
  final _cidadeEmpresaController = TextEditingController();
  final _nomeResponsavelController = TextEditingController();
  final _cpfRgResponsavelController = TextEditingController();
  final _cepResponsavelController = TextEditingController();
  final _logradouroResponsavelController = TextEditingController();
  final _numeroResponsavelController = TextEditingController();
  final _bairroResponsavelController = TextEditingController();
  final _cidadeResponsavelController = TextEditingController();
  final _telefoneResponsavelController = TextEditingController();
  final _localAutuacaoController = TextEditingController();
  final _irregularidadeController = TextEditingController();


  preencherCampos(){

    Autuacao? autuacao = widget.autuacao;

    if (autuacao != null){

      // Preenchendo Dados da Empresa
      _razaoSocialController.text = autuacao.razaosocial;
      _nomeFantasiaController.text = autuacao.nome_fantasia;
      _atividadeController.text = autuacao.atividade;
      _cnpjCpfController.text = autuacao.cnpj_cpf;
      dropValueTipoInscricao = ValueNotifier(autuacao.tipo_inscricao);
      _cepEmpresaController.text = autuacao.cep;
      _logradouroEmpresaController.text = autuacao.logradouro;
      _numeroEmpresaController.text = autuacao.numero;
      _bairroEmpresaController.text = autuacao.bairro;
      _cidadeEmpresaController.text = autuacao.cidade;
      dropValueEmpresa = ValueNotifier(autuacao.estado);

      // Preenchendo Dados do Responsável
      _nomeResponsavelController.text = autuacao.responsavel;
      _cpfRgResponsavelController.text = autuacao.cpf_rg;
      _cepResponsavelController.text = autuacao.cep_responsavel;
      _logradouroResponsavelController.text = autuacao.logradouro_responsavel;
      _numeroResponsavelController.text = autuacao.numero_responsavel;
      _bairroResponsavelController.text = autuacao.bairro_responsavel;
      _cidadeResponsavelController.text = autuacao.cidade_responsavel;
      dropValueResponsavel = ValueNotifier(autuacao.estado_responsavel);
      _telefoneResponsavelController.text = autuacao.telefone_responsavel;

      // Preenchendo Dados Local de Autuação
      _localAutuacaoController.text = autuacao.local_autuacao;
      timeLocalAutuacao = '${autuacao.data_autuacao.hour}:${autuacao.data_autuacao.minute}';
      dataLocalAutuacao = '${autuacao.data_autuacao.day}/${autuacao.data_autuacao.month}/${autuacao.data_autuacao.year}';

      //Preechendo Dados Cominação legal
      _irregularidadeController.text = autuacao.comunicacao_legal;

    }
  }

  Uint8List? imagem;

  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  final _formKey = GlobalKey<FormState>();

  var dropValueEmpresa = ValueNotifier('');
  var dropValueResponsavel = ValueNotifier('');
  var dropValueTipoInscricao = ValueNotifier('');

  late String estadoEmpresa;
  late String estadoResponsavel;
  late String tipoInscricao;

  @override
  Widget build(BuildContext context) {
    preencherCampos();
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Cadastro Novo Auto",
            style: kTextosDosInputsTelaCadastro.copyWith(fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: <Widget>[MenuUser()]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text("Dados da Empresa",
                      style: kTextosPrincipaisTelaCadastro),
                  const SizedBox(
                    height: 10,
                  ),
                  MeuTextField(
                    hintTextInput: "Razão Social",
                    style: kTextosDosInputsTelaCadastro,
                    controller: _razaoSocialController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MeuTextField(
                    hintTextInput: "Nome de Fantasia",
                    style: kTextosDosInputsTelaCadastro,
                    controller: _nomeFantasiaController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MeuTextField(
                    hintTextInput: "Atividade",
                    style: kTextosDosInputsTelaCadastro,
                    controller: _atividadeController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MeuTextField(
                    hintTextInput: "CNPJ/CPF",
                    style: kTextosDosInputsTelaCadastro,
                    controller: _cnpjCpfController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ValueListenableBuilder(
                    valueListenable: dropValueTipoInscricao,
                    builder: (BuildContext context, String value, _) {
                      return SizedBox(
                        height: 60,
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: 500,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          decoration: kDecoracaoDeCampos,
                          isExpanded: true,
                          hint: const Text(
                            'Tipo de Inscrição',
                            style: kTextosDosInputsTelaCadastro,
                          ),
                          value: value.isEmpty ? null : value,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 20,
                          onChanged: (escolha) {
                            dropValueTipoInscricao.value = escolha.toString();
                            setState(() {
                              tipoInscricao = escolha.toString();
                            });
                          },
                          items: klistaTiposInscricao.map((op) {
                            return DropdownMenuItem(
                              value: op,
                              child: Text(
                                op,
                                style: kTextosDosInputsTelaCadastro,
                              ),
                            );
                          }).toList(),
                          validator: (value) =>
                              value == null ? "Campo Obrigatório" : null,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const MeuTextField(
                    hintTextInput: "FAX",
                    style: kTextosDosInputsTelaCadastro,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MeuTextField(
                          hintTextInput: "CEP",
                          style: kTextosDosInputsTelaCadastro,
                          controller: _cepEmpresaController,
                          tipoDoCampo: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 58,
                          child: ContainerPersonalizado(
                            cor: kAzulClaro,
                            filhoContainer: Text(
                              "Consultar CEP",
                              style: kEstiloTextoContainerPersonalizado
                                  .copyWith(fontSize: 15),
                            ),
                            aoPressionar: _searchCepEmpresa,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MeuTextField(
                    hintTextInput: "Logradouro",
                    style: kTextosDosInputsTelaCadastro,
                    controller: _logradouroEmpresaController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MeuTextField(
                          hintTextInput: "Número",
                          style: kTextosDosInputsTelaCadastro,
                          controller: _numeroEmpresaController,
                          tipoDoCampo: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: MeuTextField(
                          hintTextInput: "Bairro",
                          style: kTextosDosInputsTelaCadastro,
                          controller: _bairroEmpresaController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    Expanded(
                      child: MeuTextField(
                        hintTextInput: "Cidade",
                        style: kTextosDosInputsTelaCadastro,
                        controller: _cidadeEmpresaController,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: dropValueEmpresa,
                        builder: (BuildContext context, String value, _) {
                          return SizedBox(
                            height: 60,
                            child: DropdownButtonFormField<String>(
                              menuMaxHeight: 500,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              decoration: kDecoracaoDeCampos,
                              isExpanded: true,
                              hint: const Text(
                                'Estados',
                                style: kTextosDosInputsTelaCadastro,
                              ),
                              value: value.isEmpty ? null : value,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 20,
                              onChanged: (escolha) {
                                setState(() {
                                  estadoEmpresa = escolha.toString();
                                });
                                dropValueEmpresa.value = escolha.toString();
                              },
                              items: klistaDeEstados.map((op) {
                                return DropdownMenuItem(
                                  value: op,
                                  child: Text(
                                    op,
                                    style: kTextosDosInputsTelaCadastro,
                                  ),
                                );
                              }).toList(),
                              validator: (value) =>
                                  value == null ? "Campo Obrigatório" : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    color: kCinzaClaro,
                    height: 30,
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Dados do Responsável",
                    style: kTextosPrincipaisTelaCadastro,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MeuTextField(
                    hintTextInput: "Nome",
                    style: kTextosDosInputsTelaCadastro,
                    controller: _nomeResponsavelController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MeuTextField(
                    hintTextInput: "CPF/RG",
                    style: kTextosDosInputsTelaCadastro,
                    controller: _cpfRgResponsavelController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MeuTextField(
                          hintTextInput: "CEP",
                          style: kTextosDosInputsTelaCadastro,
                          controller: _cepResponsavelController,
                          tipoDoCampo: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          child: SizedBox(
                        height: 58,
                        child: ContainerPersonalizado(
                          cor: kAzulClaro,
                          filhoContainer: Text(
                            "Consultar CEP",
                            style: kEstiloTextoContainerPersonalizado.copyWith(
                                fontSize: 15),
                          ),
                          aoPressionar: _searchCepResponsavel,
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MeuTextField(
                    hintTextInput: "Logradouro",
                    style: kTextosDosInputsTelaCadastro,
                    controller: _logradouroResponsavelController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MeuTextField(
                          hintTextInput: "Número",
                          style: kTextosDosInputsTelaCadastro,
                          controller: _numeroResponsavelController,
                          tipoDoCampo: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: MeuTextField(
                          hintTextInput: "Bairro",
                          style: kTextosDosInputsTelaCadastro,
                          controller: _bairroResponsavelController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    Expanded(
                      child: MeuTextField(
                        hintTextInput: "Cidade",
                        style: kTextosDosInputsTelaCadastro,
                        controller: _cidadeResponsavelController,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: dropValueResponsavel,
                        builder: (BuildContext context, String value, _) {
                          return SizedBox(
                            height: 60,
                            child: DropdownButtonFormField<String>(
                              menuMaxHeight: 500,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              decoration: kDecoracaoDeCampos,
                              isExpanded: true,
                              hint: const Text(
                                'Estados',
                                style: kTextosDosInputsTelaCadastro,
                              ),
                              value: value.isEmpty ? null : value,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 20,
                              onChanged: (escolha) {
                                setState(() {
                                  estadoResponsavel = escolha.toString();
                                });
                                dropValueResponsavel.value = escolha.toString();
                              },
                              items: klistaDeEstados.map((op) {
                                return DropdownMenuItem(
                                  value: op,
                                  child: Text(
                                    op,
                                    style: kTextosDosInputsTelaCadastro,
                                  ),
                                );
                              }).toList(),
                              validator: (value) =>
                                  value == null ? "Campo Obrigatório" : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  MeuTextField(
                    hintTextInput: "Telefone",
                    style: kTextosDosInputsTelaCadastro,
                    controller: _telefoneResponsavelController,
                    tipoDoCampo: TextInputType.phone,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    color: kCinzaClaro,
                    height: 30,
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text("Local de Autuação",
                      style: kTextosPrincipaisTelaCadastro),
                  const SizedBox(
                    height: 10,
                  ),
                  MeuTextField(
                    hintTextInput: 'Local de Autuação',
                    style: kTextosDosInputsTelaCadastro,
                    controller: _localAutuacaoController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ContainerPersonalizado(
                          aoPressionar: _showTimePicker,
                          cor: kAzulClaro,
                          filhoContainer: Text(
                            timeLocalAutuacao,
                            style: kEstiloTextoContainerPersonalizado.copyWith(
                                fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: ContainerPersonalizado(
                          cor: kAzulClaro,
                          filhoContainer: Text(
                            dataLocalAutuacao,
                            style: kEstiloTextoContainerPersonalizado.copyWith(
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    color: kCinzaClaro,
                    height: 30,
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text("Cominação Legal",
                      style: kTextosPrincipaisTelaCadastro),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Irregularidade Constatada:",
                    style: kTextosPrincipaisTelaCadastro.copyWith(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  MeuTextField(
                    hintTextInput: 'Descreva aqui',
                    style: kTextosDosInputsTelaCadastro,
                    controller: _irregularidadeController,
                    maxLines: 10,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    color: kCinzaClaro,
                    height: 30,
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAzulClaro,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      "Salvar Auto",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _onClickSalvar(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onClickSalvar(context) async {
    if (verificar_campos()) {
      User user = await SharedVar.getUser();
      Autuacao autuacao = Autuacao(
          id: 0,
          razaosocial: _razaoSocialController.text,
          nome_fantasia: _nomeFantasiaController.text,
          atividade: _atividadeController.text,
          cnpj_cpf: _cnpjCpfController.text,
          tipo_inscricao: tipoInscricao,
          telefone1: _telefoneResponsavelController.text,
          cep: _cepEmpresaController.text,
          numero: _numeroEmpresaController.text,
          logradouro: _logradouroEmpresaController.text,
          bairro: _bairroEmpresaController.text,
          cidade: _cidadeEmpresaController.text,
          estado: estadoEmpresa,
          responsavel: _nomeResponsavelController.text,
          cpf_rg: _cpfRgResponsavelController.text,
          cep_responsavel: _cepResponsavelController.text,
          logradouro_responsavel: _logradouroResponsavelController.text,
          numero_responsavel: _numeroResponsavelController.text,
          bairro_responsavel: _bairroResponsavelController.text,
          cidade_responsavel: _cidadeResponsavelController.text,
          estado_responsavel: estadoResponsavel,
          telefone_responsavel: _telefoneResponsavelController.text,
          local_autuacao: _localAutuacaoController.text,
          data_autuacao: DateTime.now(),
          hora: DateTime.now(),
          comunicacao_legal: _irregularidadeController.text,
          user_id: user.id,
          inicialpreenchimento_id: 1,
          assinado: 0,
          email_autuado: "",
          path_assinatura: "");
      bool result = await InternetConnectionChecker().hasConnection;

      if (result == false) {
        autuacao.salvo_servidor = 0;
        Messages().msgInfor("Sem acesso a internet, Salvo Local!", context);
        pushAndRemoveUntil(context, TelaOpcaoAssinatura(autuacao: autuacao));
      } else {
        Messages.showLoadingDialog(context, _keyLoader);
        int resp = await ConsultaApi.salvar_auto(autuacao, context);
        Navigator.of(context, rootNavigator: true).pop(); //close the dialoge;
        if (resp != 0) {
          autuacao.id = resp;
          pushAndRemoveUntil(context, TelaOpcaoAssinatura(autuacao: autuacao));
        } else {
          Messages().msgErro("Sem acesso ao servidor!", context);
          //pushAndRemoveUntil(context, TelaOpcaoAssinatura(autuacao: autuacao));
        }
      }
    }
  }

  // ignore: non_constant_identifier_names
  bool verificar_campos() {
    return true;
  }

  // ignore: non_constant_identifier_names
  bool verificar_campo(
      TextEditingController textController, FocusNode focusNode, String campo) {
    if (textController.text.toString().trim() == "") {
      focusNode.requestFocus();
      Messages().msgInfor("Preencha $campo!", context);
      return false;
    }
    return true;
  }

  Future _searchCepEmpresa() async {
    final cep = _cepEmpresaController.text;

    final resultCep = await ConsultaCEP.fetchCep(cep: cep);

    setState(() {
      _cepEmpresaController.text = resultCep.cep;
      _logradouroEmpresaController.text = resultCep.logradouro;
      _bairroEmpresaController.text = resultCep.bairro;
      _cidadeEmpresaController.text = resultCep.localidade;
    });
  }

  Future _searchCepResponsavel() async {
    final cep = _cepResponsavelController.text;

    final resultCep = await ConsultaCEP.fetchCep(cep: cep);

    setState(() {
      _cepResponsavelController.text = resultCep.cep;
      _logradouroResponsavelController.text = resultCep.logradouro;
      _bairroResponsavelController.text = resultCep.bairro;
      _cidadeResponsavelController.text = resultCep.localidade;
    });
  }
}

