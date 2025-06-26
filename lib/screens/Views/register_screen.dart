import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController mrnController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String? selectedGender;
  bool isLoading = false;

  Future<void> registerPatient() async{
    if(!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      setState(() => isLoading = false);
      return;
    }

    final url = Uri.parse('http://147.93.106.230:8000/api/patients');

    try{
      final response = await http.post(
        url,
        headers: {
          'Authorization' : 'Bearer $token',
          'Accept' : 'application/json',
        },
        body: {
          'mrn' : mrnController.text,
          'email' : emailController.text,
          'name' : nameController.text,
          'gender' : selectedGender ?? '',
          'date_of_birth' : dobController.text,
          'weight' : weightController.text,
          'address' : addressController.text,
          'note' : noteController.text,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient registered successfully!')),
        );
        _formKey.currentState?.reset();
        clearFields();
      }else{
        final body = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${body['message'] ?? 'Unknown error'}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void clearFields(){
    mrnController.clear();
    emailController.clear();
    nameController.clear();
    dobController.clear();
    weightController.clear();
    addressController.clear();
    noteController.clear();
    setState(() => selectedGender = null);
  }

  Future<void> selectDate(BuildContext context) async{
    DateTime initialDate = DateTime.now().subtract(const Duration(days: 365 *20));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate, 
      firstDate: DateTime(1900), 
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Patient")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField("MRN", mrnController),
              _buildField("Email", emailController, isEmail: true),
              _buildField("Name", nameController),
              _buildGenderDropdown(),
              _buildDatePicker(context),
              _buildField("Weight", weightController),
              _buildField("Address", addressController),
              _buildField("Note", noteController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : registerPatient, 
                child: isLoading
                ? const CircularProgressIndicator()
                : const Text("Submit")
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildField(String label, TextEditingController controller, {bool isEmail = false}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: controller,
          keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty){
              return 'Please enter $label';
            }
            if (isEmail && !value.contains('@')){
              return 'Invalid email';
            }
            return null;
          },
        ),
      );
    }

  Widget _buildGenderDropdown(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        items: const [
          DropdownMenuItem(value: 'male', child: Text('Male')),
          DropdownMenuItem(value: 'female', child: Text('Female')),
        ], 
        onChanged: (value) => setState(() => selectedGender = value),
        decoration: InputDecoration(
          labelText: "Gender",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => 
          value == null ? 'Please select gender' : null,
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: dobController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Date of Birth",
          suffixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onTap: () => selectDate(context),
        validator: (value) => 
          value == null || value.isEmpty ? 'Please select date of birth' : null,
      ),
    );
  }
}