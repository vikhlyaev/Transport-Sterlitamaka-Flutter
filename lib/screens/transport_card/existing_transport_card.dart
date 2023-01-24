import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transport_sterlitamaka/resources/resources.dart';
import 'package:transport_sterlitamaka/theme/user_colors.dart';

class ExistingTransportCardWidget extends StatelessWidget {
  const ExistingTransportCardWidget({super.key});

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
                inputFormatters: [
                  UpperCaseTextFormatter(),
                  LengthLimitingTextInputFormatter(8),
                ],
                decoration: const InputDecoration(
                  hintText: 'Введите ID карты',
                  labelText: 'ID карты',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
                  onPressed: () => print('existing'),
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
