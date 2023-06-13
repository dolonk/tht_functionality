import 'package:flutter/material.dart';

class UserDataTable extends StatefulWidget {
  @override
  _UserDataTableState createState() => _UserDataTableState();
}

class _UserDataTableState extends State<UserDataTable> {
  List<List<TextEditingController>> controllers = [
    [TextEditingController(), TextEditingController()],
    [TextEditingController(), TextEditingController()],
  ];

  void addRow() {
    setState(() {
      controllers.add(List.generate(
          controllers[0].length, (index) => TextEditingController()));
    });
  }

  void removeRow() {
    if (controllers.length > 2) {
      setState(() {
        controllers.removeLast();
      });
    }
  }

  void addColumn() {
    setState(() {
      for (var row in controllers) {
        row.add(TextEditingController());
      }
    });
  }

  void removeColumn() {
    if (controllers[0].length > 2) {
      setState(() {
        for (var row in controllers) {
          row.removeLast();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var row in controllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data Table'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400,
              width: double.infinity,
              color: Colors.black45,
              margin: const EdgeInsets.all(10),
              child: Container(
                height: 100,
                width: 200,
                child: Table(
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  border: TableBorder.all(width: 1.0, color: Colors.black),
                  children: [
                    for (var rowIndex = 0;
                    rowIndex < controllers.length;
                    rowIndex++)
                      TableRow(
                        children: [
                          for (var colIndex = 0;
                          colIndex < controllers[rowIndex].length;
                          colIndex++)
                            TableCell(
                              child: TextFormField(
                                controller: controllers[rowIndex][colIndex],
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 150,
              color: Colors.black45,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: addRow,
                        child: const Text('Add Row'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: removeRow,
                        child: const Text('Remove Row'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: addColumn,
                        child: const Text('Add Column'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: removeColumn,
                        child: const Text('Remove Column'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
