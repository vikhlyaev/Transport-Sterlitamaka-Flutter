import 'dart:developer' as d;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_sterlitamaka/resources/resources.dart';
import 'package:transport_sterlitamaka/secrets.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';

class ExistingTransportCardWidget extends StatefulWidget {
  const ExistingTransportCardWidget({super.key});

  @override
  State<ExistingTransportCardWidget> createState() =>
      _ExistingTransportCardWidgetState();
}

class _ExistingTransportCardWidgetState
    extends State<ExistingTransportCardWidget> {
  final _controller = TextEditingController();
  String? _errorText = null;

  bool validateTransportCardNumber() {
    final cardNumber = _controller.text;

    // ignore: avoid_bool_literals_in_conditional_expressions
    return (cardNumber.length == 8 && cardNumber == Secrets.CORRECT_CARD_NUMBER)
        ? true
        : false;
  }

  Future<bool> saveCardNumber(String cardNumber) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(Secrets.CARD_NUMBER_KEY, cardNumber);
  }

  void addCardButtonPressed() {
    if (validateTransportCardNumber()) {
      saveCardNumber(_controller.text);
      Navigator.of(context).popAndPushNamed('/');
    } else {
      setState(() {
        _errorText = 'Такой карты не существует';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить транспортную карту'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Stack(children: [
          Column(
            children: [
              TextField(
                controller: _controller,
                inputFormatters: [
                  UpperCaseTextFormatter(),
                  LengthLimitingTextInputFormatter(8),
                ],
                decoration: InputDecoration(
                  errorText: _errorText,
                  hintText: 'Введите ID карты',
                  labelText: 'ID карты',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Color(0xFFD7D7D7),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFD7D7D7),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    height: 220,
                    child: const Image(image: AssetImage(Images.card)),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 16,
                    child: Container(
                      width: 120,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: UserColors.red,
                          width: 5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'обратная сторона транспортной карты',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: addCardButtonPressed,
                  child: const Text('Добавить карту'),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
