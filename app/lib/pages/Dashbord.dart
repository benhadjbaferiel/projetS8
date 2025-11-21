import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// IMPORT TES PAGES
import 'package:app/pages/AnalyticsPage.dart';
import 'package:app/pages/Settings.dart';
import 'package:app/pages/clients.dart';
import 'package:app/pages/historique.dart';
import 'package:app/pages/machines.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool darkMode = false;

  // --- Fake alerts ---
  List<String> alerts = [
    "Machine 12 hors service",
    "Niveau de stockage élevé sur Machine 4",
    "Client 1020 a dépassé sa limite"
  ];

  // --- Fake machine locations (à changer selon ta BD) ---
  List<Map<String, dynamic>> machineLocations = [
    {
      "name": "Machine Alger",
      "lat": 36.7538,
      "lng": 3.0588,
    },
    {
      "name": "Machine Oran",
      "lat": 35.6911,
      "lng": -0.6417,
    },
    {
      "name": "Machine Constantine",
      "lat": 36.3650,
      "lng": 6.6147,
    },
  ];

  // Filters
  String? selectedCity;
  String? selectedMachine;
  String? selectedObjectType;
  DateTimeRange? selectedDate;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        brightness: darkMode ? Brightness.dark : Brightness.light,
        colorSchemeSeed: Colors.green,
      ),

      home: Scaffold(
        body: Row(
          children: [
            _buildSidebar(),
            Expanded(child: _buildMainContent()),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SIDEBAR
  // ------------------------------------------------------------
  Widget _buildSidebar() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: darkMode ? Colors.grey[900] : Colors.grey[200],
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            "INGRECYC",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: darkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          _menuItem(Icons.recycling, "Machines", () => _go(MachinesPage())),
          _menuItem(Icons.person, "Clients", () => _go(ClientsPage())),
          _menuItem(Icons.attach_money, "Transactions", () {}),
          _menuItem(Icons.warning, "Alertes", () {}),
          _menuItem(Icons.analytics, "Analyse", () => _go(AnalyticsPage())),
          _menuItem(Icons.history, "Historique", () => _go(HistoryReportsPage())),
          _menuItem(Icons.settings, "Paramètres", () => _go(SettingsPage())),

          const Spacer(),

          SwitchListTile(
            title: Text(
              "Dark Mode",
              style: TextStyle(color: darkMode ? Colors.white : Colors.black),
            ),
            value: darkMode,
            onChanged: (v) => setState(() => darkMode = v),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: darkMode ? Colors.white : Colors.black87),
      title: Text(title,
          style:
              TextStyle(color: darkMode ? Colors.white : Colors.black87)),
      onTap: onTap,
    );
  }

  void _go(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  // ------------------------------------------------------------
  // MAIN CONTENT
  // ------------------------------------------------------------
  Widget _buildMainContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(),
          const SizedBox(height: 20),
          _buildFilters(),
          const SizedBox(height: 20),
          _buildStatsCards(),
          const SizedBox(height: 20),

          // ---------------- MAP HERE ----------------
          Expanded(child: buildMap()),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // TOP BAR (Alertes + profil)
  // ------------------------------------------------------------
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Profile
        Row(
          children: const [
            CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 10),
            Text("Admin", style: TextStyle(fontSize: 18)),
          ],
        ),

        // Notifications
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications, size: 32),
              onPressed: () => _showAlerts(),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                child: Text(
                  "${alerts.length}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // FILTERS BAR
  // ------------------------------------------------------------
  Widget _buildFilters() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _dropdownFilter("Ville", ["Alger", "Oran", "Constantine"],
                (v) => setState(() => selectedCity = v)),
            const SizedBox(width: 10),
            _dropdownFilter("Machine", ["M1", "M2", "M3"],
                (v) => setState(() => selectedMachine = v)),
            const SizedBox(width: 10),
            _dropdownFilter("Type", ["Plastique", "Canette", "Verre"],
                (v) => setState(() => selectedObjectType = v)),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.date_range),
              label: const Text("Période"),
              onPressed: _pickDate,
            )
          ],
        ),
      ),
    );
  }

  Widget _dropdownFilter(
    String label,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButton<String>(
      hint: Text(label),
      value: null,
      items: items
          .map((e) =>
              DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }

  // ------------------------------------------------------------
  // STATS CARDS
  // ------------------------------------------------------------
  Widget _buildStatsCards() {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        _statCard(Icons.memory, "Machines actives", "12", Colors.green),
        _statCard(Icons.recycling, "Total recyclé", "180 kg", Colors.blue),
        _statCard(Icons.euro, "Argent distribué", "120 €", Colors.orange),
        _statCard(Icons.auto_awesome, "Score IA", "92%", Colors.purple),
      ],
    );
  }

  Widget _statCard(
      IconData icon, String title, String value, Color color) {
    return Container(
      width: 220,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const Spacer(),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 22)),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // MAP (KHARITA)
  // ------------------------------------------------------------
  Widget buildMap() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(36.7538, 3.0588), // Alger
            initialZoom: 6.0,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            ),
            MarkerLayer(
              markers: machineLocations.map((machine) {
                return Marker(
                  point: LatLng(machine["lat"], machine["lng"]),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.location_on,
                      size: 40, color: Colors.red),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // ALERT POPUP
  // ------------------------------------------------------------
  void _showAlerts() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Alertes"),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: alerts
                .map((msg) => ListTile(
                      leading: const Icon(Icons.warning,
                          color: Colors.red),
                      title: Text(msg),
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          )
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PICK DATE RANGE
  // ------------------------------------------------------------
  void _pickDate() async {
    DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (result != null) {
      setState(() => selectedDate = result);
    }
  }
}
