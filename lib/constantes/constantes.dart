import 'package:flutter/material.dart';

const Color kVermelha = Color(0xFFCB0912);
const Color kCinzaClaro = Color(0xFFABABAB);
const Color kCinzaMuitoClaro = Color(0xFFE4E4E4);
const Color kAzulClaro = Color(0xFF4BA9BA);

const TextStyle ktextoLogin = TextStyle(fontSize: 30, fontFamily: 'Poppins', color: kVermelha);
const TextStyle kdescricao = TextStyle(fontWeight: FontWeight.w300, color: kCinzaClaro);
const TextStyle kEstiloTextoContainerPersonalizado = TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w300);

const double kalturaEspacamento = 30;
const double kalturaContainerPersonalizado = 50;
const double kalturaCardDeAutuacao = 80;

const List<String> klistaDeEstados = <String>['Estado','PI', 'AL', 'AP',
'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG',
'PA', 'PB', 'PR', 'PE', 'AC', 'RJ', 'RN', 'RS', 'RO', 'RR',
'RO', 'RR', 'SC', 'SP', 'SE', 'TO'];

const InputDecoration kDecoracaoDeCampos = InputDecoration(
  hintStyle: TextStyle(color: Colors.black54),
  enabledBorder: OutlineInputBorder(borderSide: BorderSide(
      color: Colors.transparent
  ),),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(
      color: Colors.transparent
  ),),
  fillColor: kCinzaMuitoClaro,
  filled: true,
  floatingLabelBehavior: FloatingLabelBehavior.never,
);
