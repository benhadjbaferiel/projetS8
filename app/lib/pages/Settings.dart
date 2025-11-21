import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Users list example
  List<Map<String, String>> users = [
    {"name": "Admin", "role": "Administrateur"},
    {"name": "Technicien", "role": "Maintenance"},
  ];

  // Machines example
  List<String> machines = ["Machine 1", "Machine 2", "Machine 3"];

  // IA parameters example
  double qualityThreshold = 90;
  Map<String, double> bottlePrices = {"Plastique": 0.5, "Verre": 0.8, "Carton": 0.3};

  // Notifications toggles
  bool notifyFullMachine = true;
  bool notifyDeposit = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paramètres / Administration")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Gestion des utilisateurs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...users.map((user) => Card(
                  child: ListTile(
                    title: Text(user["name"]!),
                    subtitle: Text("Rôle: ${user["role"]}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Modifier ${user['name']}")),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              users.remove(user);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                )),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  users.add({"name": "Nouvel utilisateur", "role": "Utilisateur"});
                });
              },
              icon: const Icon(Icons.add),
              label: const Text("Ajouter utilisateur"),
            ),
            const Divider(height: 40, thickness: 2),

            const Text("Gestion des machines", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...machines.map((machine) => Card(
                  child: ListTile(
                    title: Text(machine),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.build, color: Colors.blue),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Calibration $machine")),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              machines.remove(machine);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                )),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  machines.add("Nouvelle machine");
                });
              },
              icon: const Icon(Icons.add),
              label: const Text("Ajouter machine"),
            ),
            const Divider(height: 40, thickness: 2),

            const Text("Paramètres IA", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Seuil qualité : ${qualityThreshold.toStringAsFixed(0)}%"),
            Slider(
              value: qualityThreshold,
              min: 50,
              max: 100,
              divisions: 10,
              label: qualityThreshold.toStringAsFixed(0),
              onChanged: (val) {
                setState(() {
                  qualityThreshold = val;
                });
              },
            ),
            const SizedBox(height: 10),
            ...bottlePrices.keys.map((k) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$k (€ par bouteille)"),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: bottlePrices[k]!.toString()),
                        onSubmitted: (val) {
                          setState(() {
                            bottlePrices[k] = double.tryParse(val) ?? bottlePrices[k]!;
                          });
                        },
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                    )
                  ],
                )),
            const Divider(height: 40, thickness: 2),

            const Text("Notifications & Alertes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text("Notifier quand machine pleine"),
              value: notifyFullMachine,
              onChanged: (val) => setState(() => notifyFullMachine = val),
            ),
            SwitchListTile(
              title: const Text("Notifier nouveau dépôt"),
              value: notifyDeposit,
              onChanged: (val) => setState(() => notifyDeposit = val),
            ),
          ],
        ),
      ),
    );
  }
}
