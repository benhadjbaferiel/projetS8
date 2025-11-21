import 'package:flutter/material.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Performance & Insights")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Cartographie des machines", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),




            
            Container(
              height: 200,
              color: Colors.grey[300],
              child: const Center(child: Text("Map Placeholder", style: TextStyle(color: Colors.grey))),
            ),
            const SizedBox(height: 30),

            const Text("Simulation prédictive IA", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              height: 150,
              color: Colors.grey[300],
              child: const Center(child: Text("Predictive Graph Placeholder", style: TextStyle(color: Colors.grey))),
            ),
            const SizedBox(height: 30),

            const Text("Analyse de performance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildStatCard(context, "Machine la plus rentable", "Machine 3"),
                _buildStatCard(context, "Matière la plus recyclée", "Plastique"),
                _buildStatCard(context, "Clients les plus actifs", "John Doe"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value) {
    return Card(
      elevation: 3,
      child: SizedBox(
        width: 200,
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textTheme.bodyLarge!.color)),
              const SizedBox(height: 10),
              Text(value, style: TextStyle(fontSize: 20, color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }
}
