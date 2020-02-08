import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConclusaoPage extends StatefulWidget {

  String cliente;

  ConclusaoPage({this.cliente});

  @override
  _ConclusaoPageState createState() => _ConclusaoPageState();
}

class _ConclusaoPageState extends State<ConclusaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.check, size: 200,),
              Text('Parabéns!', textAlign: TextAlign.center, style: GoogleFonts.sourceSansPro(fontSize: 32, fontWeight: FontWeight.bold),),
              Text('${widget.cliente}, seu pagamento foi efetuado com sucesso!', textAlign: TextAlign.center, style: GoogleFonts.sourceSansPro(fontSize: 20, fontWeight: FontWeight.w500),),
            ],
          ),
        ),
      ),
    );
  }
}
