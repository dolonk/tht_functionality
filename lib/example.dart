import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class BarCodeGenerator extends StatefulWidget {
  const BarCodeGenerator({Key? key}) : super(key: key);

  @override
  State<BarCodeGenerator> createState() => _BarCodeGeneratorState();
}

class _BarCodeGeneratorState extends State<BarCodeGenerator> {
  final TextEditingController controller = TextEditingController();
  String data = "";
  String encodingType = 'Code128';
  String errorMessage = "";

  final List<String> supportedEncodingTypes = [
    'Code128',
    'UPC-A',
    'UPC-E',
    'EAN-8',
    'EAN-13',
    'Code93',
    'Code39',
    'CodeBar',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BarCode Generator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BarcodeWidgetContainer(
              data: data,
              encodingType: encodingType,
            ),
            const SizedBox(height: 24),
            DataTextField(
              controller: controller,
              onChanged: (value) {
                setState(() {
                  data = value;
                });
              },
            ),
            const SizedBox(height: 24),
            EncodingTypePicker(
              selectedType: encodingType,
              supportedTypes: supportedEncodingTypes,
              onTypeChanged: (value) {
                setState(() {
                  encodingType = value;
                  errorMessage = ""; // Reset error message when the encoding type changes
                });
              },
              onConfirm: (value) {
                setState(() {
                  encodingType = value;
                  if (!_checkDataLength(value)) {
                    errorMessage = 'Invalid data length for $value';
                  } else {
                    errorMessage = "";
                  }
                });
              },
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _checkDataLength(String encodingType) {
    switch (encodingType) {
      case 'UPC-A':
        return data.length == 12;
      case 'UPC-E':
        return data.length == 6;
      case 'EAN-8':
        return data.length == 7;
      case 'EAN-13':
        return data.length == 13;
      default:
        return true; // No length restriction for other encoding types
    }
  }
}

class BarcodeWidgetContainer extends StatelessWidget {
  final String data;
  final String encodingType;

  const BarcodeWidgetContainer({
    required this.data,
    required this.encodingType,
  });

  Barcode _getBarcode() {
    switch (encodingType) {
      case 'Code128':
        return Barcode.code128();
      case 'UPC-A':
        return Barcode.upcA();
      case 'UPC-E':
        return Barcode.upcE();
      case 'EAN-8':
        return Barcode.ean8();
      case 'EAN-13':
        return Barcode.ean13();
      case 'Code93':
        return Barcode.code93();
      case 'Code39':
        return Barcode.code39();
      case 'CodeBar':
        return Barcode.codabar();
      default:
        return Barcode.code128(); // Default to Code 128
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 100, left: 30, right: 20),
      height: 80,
      width: 300,
      child: BarcodeWidget(
        barcode: _getBarcode(),
        data: data,
        drawText: true,
        color: Colors.grey.shade700,
        width: double.infinity,
        height: 70,
      ),
    );
  }
}

class DataTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const DataTextField({super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black45,
        ),
        decoration: const InputDecoration(
          hintText: "Type the Data",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffD6D6D6)),
          ),
        ),
      ),
    );
  }
}

class EncodingTypePicker extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onConfirm;
  final List<String> supportedTypes;

  const EncodingTypePicker({super.key,
    required this.selectedType,
    required this.onTypeChanged,
    required this.onConfirm,
    required this.supportedTypes,
  });

  void _showPicker(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter<String>(pickerData: supportedTypes),
      hideHeader: true,
      selecteds: [supportedTypes.indexOf(selectedType)],
      title: const Text('Select Encoding Type'),
      onConfirm: (Picker picker, List<int> value) {
        final selectedValue = supportedTypes[value.first];
        onConfirm(selectedValue); // Invoke the onConfirm callback with the selected value
      },
    ).showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: InkWell(
        onTap: () => _showPicker(context),
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Encoding Type',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffD6D6D6)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(selectedType),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}













