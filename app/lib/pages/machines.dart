import 'package:flutter/material.dart';

class MachinesPage extends StatefulWidget {
  const MachinesPage({super.key});

  @override
  State<MachinesPage> createState() => _MachinesPageState();
}

class _MachinesPageState extends State<MachinesPage> {
  List<Map<String, dynamic>> machines = [];

  // Controllers
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fillController = TextEditingController();
  final TextEditingController tempController = TextEditingController();
  final TextEditingController humidityController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();

  String status = "Active";

  // ---------------------------
  Color getStatusColor(String status) {
    switch (status) {
      case "Active":
        return Colors.green;
      case "Pleine":
        return Colors.orange;
      case "Hors service":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // ---------------------------
  // Add Machine Dialog
  void showAddMachineDialog() {
    idController.clear();
    nameController.clear();
    fillController.clear();
    tempController.clear();
    humidityController.clear();
    latController.clear();
    lngController.clear();
    status = "Active";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ajouter une machine"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: "ID Machine"),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nom"),
              ),
              TextField(
                controller: latController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Latitude"),
              ),
              TextField(
                controller: lngController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Longitude"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: status,
                items: ["Active", "Pleine", "Hors service"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => status = value ?? "Active",
                decoration: const InputDecoration(labelText: "Statut"),
              ),
              TextField(
                controller: fillController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Remplissage (%)"),
              ),
              TextField(
                controller: tempController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Température (°C)"),
              ),
              TextField(
                controller: humidityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Humidité (%)"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Annuler"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Ajouter"),
            onPressed: () {
              setState(() {
                machines.add({
                  "id": idController.text,
                  "name": nameController.text,
                  "lat": double.tryParse(latController.text) ?? 0,
                  "lng": double.tryParse(lngController.text) ?? 0,
                  "status": status,
                  "fill": int.tryParse(fillController.text) ?? 0,
                  "temperature": int.tryParse(tempController.text) ?? 0,
                  "humidity": int.tryParse(humidityController.text) ?? 0,
                  "lastDeposit": "N/A",
                  "alerts": 0,
                });
              });

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------
  // Machine Details
  void showMachineDetail(Map<String, dynamic> machine) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(machine["name"]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("ID : ${machine["id"]}"),
            Text("Statut : ${machine["status"]}",
                style: TextStyle(color: getStatusColor(machine["status"]))),
            Text("Remplissage : ${machine["fill"]}%"),
            Text("Température : ${machine["temperature"]}°C"),
            Text("Humidité : ${machine["humidity"]}%"),
            Text("Position : ${machine["lat"]}, ${machine["lng"]}"),
            Text("Dernier dépôt : ${machine["lastDeposit"]}"),
            Text("Alertes envoyées : ${machine["alerts"]}"),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Fermer"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Urgence"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                machine["alerts"]++;
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("🚨 Alerte d'urgence envoyée (LOCAL)"),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  // ---------------------------
  void removeMachine(int index) {
    setState(() {
      machines.removeAt(index);
    });
  }

  // ---------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Machines"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddMachineDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: machines.isEmpty
            ? const Center(
                child: Text(
                  "Aucune machine ajoutée.\nCliquez sur + pour ajouter.",
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                itemCount: machines.length,
                itemBuilder: (_, index) {
                  final m = machines[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      onTap: () => showMachineDetail(m),
                      leading: CircleAvatar(
                        backgroundColor: getStatusColor(m["status"]),
                        child: Text(
                          "${m["fill"]}%",
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      title: Text(
                        m["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Statut: ${m["status"]}\nID: ${m["id"]}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeMachine(index),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
