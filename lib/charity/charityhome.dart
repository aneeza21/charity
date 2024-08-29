import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import './add_beneficiary_page.dart';

class CharityHome extends StatefulWidget {
  const CharityHome({super.key});

  @override
  _CharityHomeState createState() => _CharityHomeState();
}

class _CharityHomeState extends State<CharityHome> {
  int _selectedIndex = 0;
  List<Map<dynamic, dynamic>> _beneficiaries = [];

  @override
  void initState() {
    super.initState();
    _fetchBeneficiaries();
  }

  void _fetchBeneficiaries() {
    DatabaseReference beneficiaryRef = FirebaseDatabase.instance.ref('beneficiaries');
    beneficiaryRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _beneficiaries = data.entries.map((entry) {
          return {
            'key': entry.key,
            ...entry.value,
          };
        }).toList();
      });
    });
  }

  void _navigateToAddBeneficiaryPage({Map<dynamic, dynamic>? beneficiary}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBeneficiaryPage(
          beneficiary: beneficiary,
        ),
      ),
    );
    if (result == true) {
      _fetchBeneficiaries();
    }
  }

  void _deleteBeneficiary(String key) async {
    DatabaseReference beneficiaryRef = FirebaseDatabase.instance.ref('beneficiaries/$key');
    await beneficiaryRef.remove();
    _fetchBeneficiaries();
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      _navigateToAddBeneficiaryPage();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "C H A R I T Y",
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: _selectedIndex == 0 ? _buildHomeContent() : _buildProfileContent(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 45, 195, 137),
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeContent() {
    return ListView.builder(
      itemCount: _beneficiaries.length,
      itemBuilder: (context, index) {
        final beneficiary = _beneficiaries[index];
        return ListTile(
          leading: beneficiary['imagePath'] != null
              ? Image.network(beneficiary['imagePath'])
              : null,
          title: Text(beneficiary['name']),
          subtitle: Text(beneficiary['description']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _navigateToAddBeneficiaryPage(beneficiary: beneficiary);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteBeneficiary(beneficiary['key']);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileContent() {
    // Add your profile content here
    return Center(child: Text("Profile"));
  }
}
