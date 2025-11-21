import 'package:flutter/material.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List<Map<String, dynamic>> clients = [
    {
      "name": "Alice",
      "email": "alice@example.com",
      "balance": 12.5,
      "history": [
        {"machine": "Machine 1", "amount": 5.0, "date": "2025-11-20"},
        {"machine": "Machine 2", "amount": 7.5, "date": "2025-11-21"},
      ],
      "notifications": ["Vous avez gagné 5€ ce mois-ci", "Machine 2 est pleine"],
    },
    {
      "name": "Bob",
      "email": "bob@example.com",
      "balance": 0.0,
      "history": [],
      "notifications": [],
    },
  ];

  void showClientDetail(Map<String, dynamic> client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(client["name"]),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Email: ${client["email"]}"),
              Text("Solde disponible: ${client["balance"]} €"),
              const SizedBox(height: 10),
              const Text("Historique des dépôts:", style: TextStyle(fontWeight: FontWeight.bold)),
              if (client["history"].isEmpty)
                const Text("Aucun dépôt encore")
              else
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    itemCount: client["history"].length,
                    itemBuilder: (context, index) {
                      final h = client["history"][index];
                      return ListTile(
                        title: Text("${h['machine']}"),
                        subtitle: Text("${h['amount']} € - ${h['date']}"),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 10),
              const Text("Notifications:", style: TextStyle(fontWeight: FontWeight.bold)),
              if (client["notifications"].isEmpty)
                const Text("Aucune notification")
              else
                Column(
                  children: client["notifications"]
                      .map<Widget>((n) => Text("- $n", style: const TextStyle(color: Colors.orange)))
                      .toList(),
                ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                client["balance"] = 0.0; // payer le solde
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Le solde de ${client['name']} a été payé.")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Payer l'argent"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Solde converti en points pour ${client['name']}.")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text("Convertir en points"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clients")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: clients.isEmpty
            ? const Center(child: Text("Aucun client inscrit."))
            : ListView.builder(
                itemCount: clients.length,
                itemBuilder: (context, index) {
                  final client = clients[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    child: ListTile(
                      onTap: () => showClientDetail(client),
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(client["name"]),
                      subtitle: Text("Solde: ${client["balance"]} €"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
