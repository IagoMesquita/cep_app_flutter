import 'package:flutter/cupertino.dart';

mixin CepTECMixin {
 final cepTEC = TextEditingController();

 void onDispose() {
  cepTEC.dispose();
 } 
}