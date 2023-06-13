
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TimeOfDayFormat {
  h_colon_mm_space_a,
  h_colon_mm_colon_ss_space_a,
  H_colon_mm,
  H_colon_mm_colon_ss,
}

class MyTimePicker extends StatefulWidget {
  @override
  _MyTimePickerState createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  late TimeOfDay _selectedTime;
  late TimeOfDayFormat _selectedFormat;
  late DateTime _selectedDate;
  late DateFormat _selectedFormatDate;

  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.now();
    _selectedFormat = TimeOfDayFormat.h_colon_mm_space_a;
    _selectedDate = DateTime.now();
    _selectedFormatDate = DateFormat.yMMMMd();
  }

  Future<void> _showTimePickerDialog() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (selectedTime != null) {
      setState(() {
        _selectedTime = selectedTime;
      });
    }
  }

  Future<void> _showFormatSelectionDialog() async {
    final selectedFormat = await showDialog<TimeOfDayFormat>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Time Format'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('h:mm a'),
                leading: Radio<TimeOfDayFormat>(
                  value: TimeOfDayFormat.h_colon_mm_space_a,
                  groupValue: _selectedFormat,
                  onChanged: (TimeOfDayFormat? value) {
                    setState(() {
                      _selectedFormat = value!;
                    });
                    Navigator.of(context).pop(value);
                  },
                ),
              ),
              ListTile(
                title: const Text('h:mm:ss a'),
                leading: Radio<TimeOfDayFormat>(
                  value: TimeOfDayFormat.h_colon_mm_colon_ss_space_a,
                  groupValue: _selectedFormat,
                  onChanged: (TimeOfDayFormat? value) {
                    setState(() {
                      _selectedFormat = value!;
                    });
                    Navigator.of(context).pop(value);
                  },
                ),
              ),
              ListTile(
                title: const Text('HH:mm'),
                leading: Radio<TimeOfDayFormat>(
                  value: TimeOfDayFormat.H_colon_mm,
                  groupValue: _selectedFormat,
                  onChanged: (TimeOfDayFormat? value) {
                    setState(() {
                      _selectedFormat = value!;
                    });
                    Navigator.of(context).pop(value);
                  },
                ),
              ),
              ListTile(
                title: const Text('HH:mm:ss'),
                leading: Radio<TimeOfDayFormat>(
                  value: TimeOfDayFormat.H_colon_mm_colon_ss,
                  groupValue: _selectedFormat,
                  onChanged: (TimeOfDayFormat? value) {
                    setState(() {
                      _selectedFormat = value!;
                    });
                    Navigator.of(context).pop(value);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedFormat != null) {
      setState(() {
        _selectedFormat = selectedFormat;
      });
    }
  }

  String _getFormattedTime() {
    final dateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    switch (_selectedFormat) {
      case TimeOfDayFormat.h_colon_mm_space_a:
        return DateFormat('h:mm a').format(dateTime);
      case TimeOfDayFormat.h_colon_mm_colon_ss_space_a:
        return DateFormat('h:mm:ss a').format(dateTime);
      case TimeOfDayFormat.H_colon_mm:
        return DateFormat('HH:mm').format(dateTime);
      case TimeOfDayFormat.H_colon_mm_colon_ss:
        return DateFormat('HH:mm:ss').format(dateTime);
      default:
        throw Exception('Invalid TimeOfDayFormat');
    }
  }

  Future<void> _showDatePickerDialog() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  Future<void> _showFormatSelectionDateDialog() async {
    DateFormat? selectedFormat;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Date Format'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFormatRadioListTile('No', null),
              _buildFormatRadioListTile('yyyy-MM-dd', 'yyyy-MM-dd'),
              _buildFormatRadioListTile('dd/MM/yyyy', 'dd/MM/yyyy'),
              _buildFormatRadioListTile('MMMM d, yyyy', 'MMMM d, yyyy'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (selectedFormat != null) {
      setState(() {
        _selectedFormatDate = selectedFormat;
      });
    }
  }

  Widget _buildFormatRadioListTile(String label, String? format) {
    final isSelected = _selectedFormatDate.pattern == format;

    return RadioListTile<String>(
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      value: format ?? '',
      groupValue: _selectedFormatDate.pattern,
      onChanged: (String? value) {
        setState(() {
          _selectedFormatDate = DateFormat(value!);
        });
        Navigator.of(context).pop(); // Close the dialog
      },
      activeColor: Colors.blue,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  String _getFormattedDate() {
    return _selectedFormatDate.format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Picker'),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            color: Colors.grey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Selected Time:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _getFormattedTime(),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showTimePickerDialog,
                    child: const Text('Select Time'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _showFormatSelectionDialog,
                    child: const Text('Select Format'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 300,
            width: double.infinity,
            color: Colors.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Selected Date:',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  _getFormattedDate(),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showDatePickerDialog,
                  child: const Text('Select Date'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _showFormatSelectionDateDialog,
                  child: const Text('Select Format'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

