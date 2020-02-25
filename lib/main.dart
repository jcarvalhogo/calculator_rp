import 'package:calculator_rp/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

//import 'package:screenshot_share_image/screenshot_share_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator Royal',
      theme: ThemeData(
        canvasColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: Material(child: MyHomePage(title: 'Calculator Royal')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<int> _parcelas = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24
  ];

  TextEditingController _valorVendaController = TextEditingController();
  TextEditingController _valorEntradaController = TextEditingController();
  TextEditingController _saldoAPagarController = TextEditingController();
  TextEditingController _valorDasParcelasController = TextEditingController();
  TextEditingController _valorParceladoController = TextEditingController();
  TextEditingController _valortotalDaVendaController = TextEditingController();
  TextEditingController _montanteTotalAcrescimoController =
      TextEditingController();

  FocusNode focusValorVenda = FocusNode();

  final NumberFormat _formatCurrency = NumberFormat("#,##0.00", "pt_BR");

  double _valorEntrada = 0.0;
  double _valorEntradaMinima = 0.0;
  double _valorDaVenda = 0.0;
  double _saldoAPagar = 0.0;
  double _valorDasParcelas = 0.0;
  double _valorParcelado = 0.0;
  double _valorTotalVenda = 0.0;
  double _montanteTotalAcrescimo = 0.0;

  bool isMinimo = true;
  bool isErroValorVenda = false;
  bool isErroEntrada = false;

  Color _corCampoValorDaVenda;
  Color _corCampoEntrada;
  Color _corCamposEditavel;

  String _labelEntrada = 'Entrada';
  String _labelSaldoAPagar = 'Saldo a pagar sem acréscimo';
  int _quantidadeParcelas = 24;

  Future<void> _showErro(String erro) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.all(10.0),
          buttonPadding: EdgeInsets.all(10.0),
          titlePadding: EdgeInsets.all(0.0),
          actionsPadding: EdgeInsets.all(10.0),
          insetPadding: EdgeInsets.all(10.0),
          content: Container(
            alignment: Alignment.center,
            height: 60.0,
            child: Text(
              erro,
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'FECHAR',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Container _appBarTopo(double largura) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 17),
      width: largura,
      height: 80,
      color: Color.fromARGB(255, 42, 96, 153),
      child: Text(
        'Royal Prestige',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Container _fundoApp() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/fundo.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container _logo() {
    return Container(
      margin: EdgeInsets.only(top: 50, left: 20),
      width: 58,
      height: 58,
      child: Image.asset('images/logo.png'),
    );
  }

  Text _textLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 18,
        color: Color.fromARGB(255, 42, 96, 153),
      ),
    );
  }

  _calcular(
      {@required double valorVenda,
      @required double valorEntrada,
      @required int parcelas,
      @required bool minimo}) {
    _valorEntradaMinima = _valorDaVenda * 0.05;
    if (minimo) {
      _corCampoValorDaVenda = _corCamposEditavel;
      _corCampoEntrada = _corCamposEditavel;
      _valorEntrada = _valorEntradaMinima;
      _labelEntrada = 'Entrada 5%';
      _labelSaldoAPagar = 'Saldo a pagar sem acréscimo';
    } else {
      _labelEntrada = 'Entrada';
      _labelSaldoAPagar = 'Saldo a pagar';
    }

    if (_valorEntrada > _valorDaVenda) {
      _valorEntrada = _valorDaVenda;
    }

    if (_valorEntrada == _valorDaVenda) {
      _quantidadeParcelas = 1;
      _valorDasParcelas = 0.0;
    }

    _valorEntradaController.text =
        'R\$ ${_formatCurrency.format(_valorEntrada)}';
    _saldoAPagar = _valorDaVenda - _valorEntrada;
    _saldoAPagarController.text = 'R\$ ${_formatCurrency.format(_saldoAPagar)}';

    _valorParcelado =
        _saldoAPagar + (_saldoAPagar * (_quantidadeParcelas / 100));

    _valorParceladoController.text =
        'R\$ ${_formatCurrency.format(_valorParcelado)}';

    _valorTotalVenda = _valorEntrada + _valorParcelado;
    _valortotalDaVendaController.text =
        'R\$ ${_formatCurrency.format(_valorTotalVenda)}';

    _montanteTotalAcrescimo = _valorTotalVenda - _valorDaVenda;
    _montanteTotalAcrescimoController.text =
        'R\$ ${_formatCurrency.format(_montanteTotalAcrescimo)}';

    if (_saldoAPagar > 0) {
      _valorDasParcelas = _valorParcelado / _quantidadeParcelas;
      _valorDasParcelasController.text =
          'R\$ ${_formatCurrency.format(_valorDasParcelas)}';
    }
  }

  Widget _camposTexto(
    Color color, {
    bool enabled = false,
    int index = -1,
    Color textColor = Colors.white,
    TextEditingController controller,
    FocusNode focusNode,
  }) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      autofocus: false,
      textInputAction: TextInputAction.done,
      style: TextStyle(fontSize: 16.0, color: textColor),
      keyboardType: TextInputType.number,
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly,
        CurrencyPtBrInputFormatter(maxDigits: 8)
      ],
      onSubmitted: (value) {
        if (index == 0) {
          _valorDaVenda =
              double.parse(value.replaceAll(RegExp('[^0-9]'), "")) / 100;
          isMinimo = true;
          _corCampoValorDaVenda = _corCamposEditavel;
          _corCampoEntrada = _corCamposEditavel;
          _calcular(
            valorVenda: _valorDaVenda,
            valorEntrada: 0.0,
            parcelas: _quantidadeParcelas,
            minimo: true,
          );
        } else if (index == 1) {
          isMinimo = false;
          _valorEntrada =
              double.parse(value.replaceAll(RegExp('[^0-9]'), "")) / 100;
          _valorDaVenda = double.parse(
                  _valorVendaController.text.replaceAll(RegExp('[^0-9]'), "")) /
              100;

          if (_valorDaVenda == 0.0) {
            _zerarTodosValores();
            _showErro('Defina o valor da venda');
            _corCampoValorDaVenda = Colors.red.withOpacity(0.60);
          } else {
            setState(() {
              _corCampoValorDaVenda = _corCamposEditavel;
            });
            if (_valorEntrada >= _valorEntradaMinima) {
              _corCampoEntrada = _corCamposEditavel;
              _calcular(
                valorVenda: _valorDaVenda,
                valorEntrada: _valorEntrada,
                parcelas: _quantidadeParcelas,
                minimo: false,
              );
            } else {
              _corCampoEntrada = Colors.red.withOpacity(0.60);
              _showErro('O valor da entrada não pode ser menor do que 5%');
            }
          }
        }
      },
      enabled: enabled,
      decoration: InputDecoration(
        filled: true,
        fillColor: color,
        contentPadding: const EdgeInsets.only(left: 5.0, bottom: 0.0, top: 0.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _dropdownButtonParcelas() {
    return Container(
      alignment: Alignment.center,
      width: 80,
      //padding: EdgeInsets.symmetric(horizontal: 30, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(5), topLeft: Radius.circular(5)),
      ),
      child: DropdownButton<int>(
        icon: Icon(
          Icons.arrow_downward,
          color: Colors.black54,
        ),
        iconSize: 24,
        elevation: 16,
        underline: SizedBox(),
        value: _quantidadeParcelas,
        style: TextStyle(fontSize: 18, color: Colors.black87),
        onChanged: (int newValue) {
          setState(() {
            _quantidadeParcelas = newValue;
            _calcular(
              valorVenda: _valorDaVenda,
              valorEntrada: _valorEntrada,
              parcelas: _quantidadeParcelas,
              minimo: isMinimo,
            );
          });
        },
        items: _parcelas.map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
      ),
    );
  }

  Widget _campos() {
    double _separador = 5.0;
    return Positioned(
      top: 110,
      left: 20,
      right: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _textLabel('Valor da Venda'),
          _camposTexto(
            _corCampoValorDaVenda,
            focusNode: focusValorVenda,
            textColor: Colors.black87,
            enabled: true,
            index: 0,
            controller: _valorVendaController,
          ),
          SizedBox(height: _separador),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _textLabel(_labelEntrada),
              _camposTexto(
                _corCampoEntrada,
                textColor: Colors.black87,
                enabled: true,
                index: 1,
                controller: _valorEntradaController,
              ),
            ],
          ),
          SizedBox(height: _separador),
          _textLabel(_labelSaldoAPagar),
          _camposTexto(
            Color.fromARGB(120, 42, 96, 153),
            controller: _saldoAPagarController,
          ),
          SizedBox(height: _separador),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  _textLabel('Parcelas'),
                  _dropdownButtonParcelas(),
                ],
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _textLabel('Valor das Parcelas'),
                  SizedBox(
                    width: 180,
                    child: _camposTexto(
                      Color.fromARGB(120, 42, 96, 153),
                      enabled: false,
                      controller: _valorDasParcelasController,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: _separador),
          _textLabel('Valor Parcelado'),
          _camposTexto(
            Color.fromARGB(120, 42, 96, 153),
            controller: _valorParceladoController,
          ),
          SizedBox(height: _separador),
          _textLabel('Valor Total da Venda'),
          _camposTexto(
            Color.fromARGB(120, 42, 96, 153),
            controller: _valortotalDaVendaController,
          ),
          SizedBox(
            height: 7,
          ),
          _textLabel('Montante Total'),
          Padding(
            padding: EdgeInsets.only(right: 70),
            child: _camposTexto(Color.fromARGB(120, 42, 96, 153),
                controller: _montanteTotalAcrescimoController),
          ),
          SizedBox(
            height: 7,
          ),
        ],
      ),
    );
  }

/*
  Future<void> _initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    Future.delayed(const Duration(seconds: 5), () {
      ScreenshotShareImage.takeScreenshotShareImage();
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }*/

  Widget _buttonSend() {
    return Positioned(
      bottom: 15,
      right: 15,
      child: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 42, 96, 153),
          onPressed: () {
            //_initPlatformState();
          },
          child: Icon(
            Icons.send,
            color: Colors.white,
          )),
    );
  }

  _zerarTodosValores() {
    _valorVendaController.text = 'R\$ 0,00';
    _valorEntradaController.text = 'R\$ 0,00';
    _saldoAPagarController.text = 'R\$ 0,00';
    _valorDasParcelasController.text = 'R\$ 0,00';
    _valorParceladoController.text = 'R\$ 0,00';
    _valortotalDaVendaController.text = 'R\$ 0,00';
    _montanteTotalAcrescimoController.text = 'R\$ 0,00';
  }

  @override
  void dispose() {
    //focusValorVenda.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _corCamposEditavel = Colors.white60;
    _corCampoValorDaVenda = _corCamposEditavel;
    _corCampoEntrada = _corCamposEditavel;

    _valorVendaController.text = 'R\$ 0,00';
    _valorEntradaController.text = 'R\$ 0,00';
    _saldoAPagarController.text = 'R\$ 0,00';
    _valorDasParcelasController.text = 'R\$ 0,00';
    _valorParceladoController.text = 'R\$ 0,00';
    _valortotalDaVendaController.text = 'R\$ 0,00';
    _montanteTotalAcrescimoController.text = 'R\$ 0,00';
  }

  @override
  Widget build(BuildContext context) {
    double _larguraTela = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        _fundoApp(),
        _appBarTopo(_larguraTela),
        _logo(),
        _campos(),
        //_buttonSend(),
      ],
    );
  }
}
