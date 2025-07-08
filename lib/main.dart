import 'package:flutter/material.dart';

void main() {
  runApp(const ProductivityApp());
}

class ProductivityApp extends StatelessWidget {
  const ProductivityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productivity App',
      debugShowCheckedModeBanner: false,
      home: const ProductivityHomePage(),
    );
  }
}

class ProductivityHomePage extends StatefulWidget {
  const ProductivityHomePage({super.key});

  @override
  State<ProductivityHomePage> createState() => _ProductivityHomePageState();
}

class _ProductivityHomePageState extends State<ProductivityHomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _tasks = [];
  Color _backgroundColor = Colors.white;

  final List<Color> _colorChoices = [
    Colors.white,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.pink.shade100,
    Colors.yellow.shade100,
    Colors.purple.shade100,
  ];

  void _addTask(String task) {
    if (task.trim().isNotEmpty && !_tasks.any((t) => t['title'] == task.trim())) {
      setState(() {
        _tasks.add({'title': task.trim(), 'done': false});
        _controller.clear();
      });
    }
  }

  void _toggleTask(int index, bool? value) {
    setState(() {
      _tasks[index]['done'] = value!;
    });
  }

  void _confirmDeleteTask(int index) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hapus Tugas?"),
          content: Text("Yakin ingin menghapus '${_tasks[index]['title']}'?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tasks.removeAt(index);
                });

                // Tutup dialog setelah perubahan
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text("Yakin"),
            ),
          ],
        );
      },
    );
  }

  double _completionRate() {
    if (_tasks.isEmpty) return 0;
    int completed = _tasks.where((task) => task['done']).length;
    return (completed / _tasks.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    double screenFontSize = MediaQuery.of(context).size.width > 600 ? 20 : 16;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Center(
                child: Text(
                  "PRODUCTIVITY APP",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: "Tugas baru",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _addTask(_controller.text),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () => _confirmDeleteTask(index),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [

                              Expanded(
                                child: Text(
                                  _tasks[index]['title'],
                                  style: TextStyle(
                                    fontSize: screenFontSize,
                                    decoration: _tasks[index]['done']
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                              /// Checkbox selesai
                              Checkbox(
                                value: _tasks[index]['done'],
                                onChanged: (val) => _toggleTask(index, val),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Selesai: ${_completionRate().toStringAsFixed(1)}%",
                style: TextStyle(fontSize: screenFontSize, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Choose Background Color",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _colorChoices.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => _backgroundColor = color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black26),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
