import 'package:flutter/material.dart';

class HistoryReportsPage extends StatefulWidget {
  const HistoryReportsPage({super.key});

  @override
  State<HistoryReportsPage> createState() => _HistoryReportsPageState();
}

class _HistoryReportsPageState extends State<HistoryReportsPage> {
  String selectedMachine = "Toutes";
  String selectedClient = "Tous";
  String selectedMaterial = "Tout";
  DateTimeRange? selectedDate;

  final List<String> machines = ["Toutes", "Machine 1", "Machine 2", "Machine 3"];
  final List<String> clients = ["Tous", "Alice", "Bob", "Charlie"];
  final List<String> materials = ["Tout", "Plastique", "Carton", "Verre"];

  final List<Map<String, dynamic>> history = [
    {
      "machine": "Machine 1",
      "client": "Alice",
      "material": "Plastique",
      "amount": 5.0,
      "date": "2025-11-20",
    },
    {
      "machine": "Machine 2",
      "client": "Bob",
      "material": "Carton",
      "amount": 7.5,
      "date": "2025-11-21",
    },
    {
      "machine": "Machine 1",
      "client": "Charlie",
      "material": "Verre",
      "amount": 3.0,
      "date": "2025-11-22",
    },
  ];

  List<Map<String, dynamic>> get filteredHistory {
    return history.where((h) {
      bool machineMatch = selectedMachine == "Toutes" || h["machine"] == selectedMachine;
      bool clientMatch = selectedClient == "Tous" || h["client"] == selectedClient;
      bool materialMatch = selectedMaterial == "Tout" || h["material"] == selectedMaterial;
      return machineMatch && clientMatch && materialMatch;
    }).toList();
  }

  Future<void> pickDateRange() async {
    DateTime now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique & Rapports"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // -------------- Filters --------------
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedMachine,
                    items: machines.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => selectedMachine = val!),
                    decoration: const InputDecoration(labelText: "Machine"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedClient,
                    items: clients.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => selectedClient = val!),
                    decoration: const InputDecoration(labelText: "Client"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedMaterial,
                    items: materials.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => selectedMaterial = val!),
                    decoration: const InputDecoration(labelText: "Matériau"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: pickDateRange,
                    child: Text(selectedDate == null
                        ? "Sélectionner période"
                        : "${selectedDate!.start.day}/${selectedDate!.start.month} - ${selectedDate!.end.day}/${selectedDate!.end.month}"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // -------------- Export Buttons --------------
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Export PDF !")));
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Export PDF"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Export Excel !")));
                  },
                  icon: const Icon(Icons.grid_on),
                  label: const Text("Export Excel"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // -------------- History Table --------------
            Expanded(
              child: filteredHistory.isEmpty
                  ? const Center(child: Text("Aucune donnée pour les filtres sélectionnés"))
                  : ListView.builder(
                      itemCount: filteredHistory.length,
                      itemBuilder: (context, index) {
                        final h = filteredHistory[index];
                        return Card(
                          child: ListTile(
                            title: Text("${h['client']} - ${h['material']}"),
                            subtitle: Text("${h['machine']} | ${h['amount']} kg | ${h['date']}"),
                          ),
                        );
                      },
                    ),
            ),

            // -------------- Placeholder Charts --------------
            Container(
              height: 150,
              margin: const EdgeInsets.only(top: 20),
              color: Colors.grey[200],
              child: const Center(
                child: Text(
                  "Graphiques : évolution mensuelle & machine efficace",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
