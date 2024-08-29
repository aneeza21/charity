import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:file_picker/file_picker.dart';

class AddBeneficiaryPage extends StatefulWidget {
  final Map<dynamic, dynamic>? beneficiary;

  const AddBeneficiaryPage({Key? key, this.beneficiary}) : super(key: key);

  @override
  _AddBeneficiaryPageState createState() => _AddBeneficiaryPageState();
}

class _AddBeneficiaryPageState extends State<AddBeneficiaryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _documentPath;

  @override
  void initState() {
    super.initState();
    if (widget.beneficiary != null) {
      _nameController.text = widget.beneficiary!['name'];
      _phoneController.text = widget.beneficiary!['phone'];
      _descriptionController.text = widget.beneficiary!['description'];
      _documentPath = widget.beneficiary!['documentPath'];
    }
  }

  void _selectDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _documentPath = result.files.single.path;
      });
    }
  }

  void _saveBeneficiary() async {
    if (_formKey.currentState!.validate() && _documentPath != null) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          DatabaseReference databaseReference;
          if (widget.beneficiary == null) {
            databaseReference = FirebaseDatabase.instance.ref("beneficiaries").push();
          } else {
            databaseReference = FirebaseDatabase.instance.ref("beneficiaries/${widget.beneficiary!['key']}");
          }

          await databaseReference.set({
            'name': _nameController.text,
            'phone': _phoneController.text,
            'description': _descriptionController.text,
            'documentPath': _documentPath,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Beneficiary saved successfully!')),
          );

          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save beneficiary: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields and select a document')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.beneficiary == null ? 'Add Beneficiary' : 'Edit Beneficiary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _selectDocument,
                  child: Text('Select Document'),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _saveBeneficiary,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 45, 195, 137),
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    widget.beneficiary == null ? 'Save Beneficiary' : 'Update Beneficiary',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
