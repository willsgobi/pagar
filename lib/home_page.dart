import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'conclusao_page.dart';

/*
* Informações importantes antes de começar a desenvolver
*
* Crie seu cadastro de teste no site da Cielo
* https://cadastrosandbox.cieloecommerce.cielo.com.br/Home/Register
*
* Você irá precisar de merchantId e merchantKey
*
* Este é o cartão padrão para usar como teste na SandBox!
*
* 4024.0071.5376.3191 -> Operação realizada com sucesso
* 4024.0071.5376.3192 -> Não Autorizada
* 4024.0071.5376.3193 -> Cartão Expirado
* 4024.0071.5376.3194 -> Cartão Bloqueado
* 4024.0071.5376.3195 -> Time Out
* 4024.0071.5376.3196 -> Cartão Cancelado
* 4024.0071.5376.3197 -> Problemas com o Cartão de Crédito
* 4024.0071.5376.3198 -> Operation Successful / Time Out
*
*As informações de Cód.Segurança (CVV) e validade podem ser aleatórias, mantendo o formato - CVV (3 dígitos) Validade (MM/YYYY).
*
* */

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool carregando = false;

  String merchantId = '';
  String merchantKey = '';

  final _formKey = GlobalKey<FormState>();

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _valorCompraController = TextEditingController();
  TextEditingController _numeroCartaoController =
      TextEditingController(text: '4024.0071.5376.3191');
  TextEditingController _validadeController = TextEditingController();

  var numeroFortato = new MaskTextInputFormatter(
      mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});
  var validadeFortato = new MaskTextInputFormatter(
      mask: '##/####', filter: {"#": RegExp(r'[0-9]')});
  var codigoFortato =
      new MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'img/logo.png',
          height: 25,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _valorCompraController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Valor da Compra'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor, digite o valor da compra.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: 'Nome do cliente'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor, digite o nome do cliente.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _numeroCartaoController,
                  decoration: InputDecoration(labelText: 'Número do cartão'),
                  inputFormatters: [
                    numeroFortato,
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor, digite o número do cartão.';
                    }
                    return null;
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _validadeController,
                        decoration: InputDecoration(labelText: 'Válidade'),
                        inputFormatters: [
                          validadeFortato,
                        ],
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Por favor, digite a válidade do cartão.';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Código de Segurança'),
                        inputFormatters: [
                          codigoFortato,
                        ],
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Por favor, digite código de segurança.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                carregando
                    ? Center(
                        child: LinearProgressIndicator(),
                      )
                    : RaisedButton(
                        child: Text('Pagar'),
                        color: Color(0xff3EAEEF),
                        textColor: Colors.white,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            pagarCielo(
                              valorCompra: int.fromEnvironment(
                                  _valorCompraController.text),
                              nomeCliente: _nomeController.text,
                              numeroCartao: _numeroCartaoController.text,
                              validadeCartao: _validadeController.text,
                            );
                          }
                        },
                      ),
                SizedBox(
                  height: 16,
                ),
                Image.asset(
                  'img/bandeiras.png',
                  width: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pagarCielo({
    @required String nomeCliente,
    @required int valorCompra,
    @required String numeroCartao,
    @required String validadeCartao,
  }) async {
    setState(() {
//      carregando = true;
    });

    String url = "https://apisandbox.cieloecommerce.cielo.com.br/1/sales/";

    Map<String, dynamic> body = {
      "MerchantOrderId": "Compra001",
      "Customer": {"Name": nomeCliente},
      "Payment": {
        "Type": "CreditCard",
        "Amount": valorCompra,
        "Installments": 1,
        "SoftDescriptor": "Pagar",
        "CreditCard": {
          "CardNumber": numeroCartao,
          "Holder": nomeCliente,
          "ExpirationDate": validadeCartao,
          "SecurityCode": "123",
          "Brand": "Visa",
          "CardOnFile": {"Usage": "Used", "Reason": "Unscheduled"}
        },
        "IsCryptoCurrencyNegotiation": true
      }
    };

    Map<String, String> headers = {
      'content-type': 'application/json',
      'merchantId': merchantId,
      'merchantKey': merchantKey,
    };

    http.Response response = await http.post(
      url,
      body: jsonEncode(body),
      headers: headers,
    );

    var transacao = jsonDecode(response.body);
    print(transacao);
    if (transacao != null) {
      if (transacao['Payment']['Status']) {
        setState(() {
          carregando = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConclusaoPage(
                    cliente: transacao['Customer']['Name'],
                  )),
        );
      } else {
        setState(() {
          carregando = false;
        });
        AlertDialog alertDialog = AlertDialog(
          content: Text('Erro ao Logar usuário!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
        await showDialog(context: context, child: alertDialog);
      }
    }
  }
}
