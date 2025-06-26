import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Patient{
  final String mrn;
  final String name;
  final String sex;

  Patient({required this.mrn, required this.name, required this.sex});

  factory Patient.fromJson(Map<String, dynamic> json){
    return Patient(
      mrn: json['mrn'], 
      name: json['name'], 
      sex: json['sex'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Patient> allPatients = [];
  List<Patient> patients = [];
  bool isLoading = true;

  @override
  void dispose(){
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    fetchPatients();
  }

    Future<void> fetchPatients() async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if(token == null){
      print('No token found');
      return;
    }

    final response = await http.get(Uri.parse('http://147.93.106.230:8000/api/patients'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept' : 'application/json',
      }
    );

    try{
      final raw = utf8.decode(response.bodyBytes);
      print('Raw response: $raw');

      final decoded = json.decode(raw);
      final List<dynamic> data = decoded['data']['data'];

      setState(() {
        allPatients = data.map((json) => Patient.fromJson(json)).toList();
        patients = List.from(allPatients);
        isLoading = false;
      });  
    }catch (e) {
      print('JSON Decode error: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid JSON response')),
      );      
    }

    // if (response.statusCode == 200) {
    //   final decoded = json.decode(utf8.decode(response.bodyBytes));
    //   final List<dynamic> data = decoded['data']['data'] ?? [];
    //   setState(() {
    //     patients = data.map((json) => Patient.fromJson(json)).toList();
    //     isLoading = false;
    //   });
    // }else {
    //   setState(() => isLoading = false);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Failed to load patients')),
    //   );
    // }
  }

  void filterPatients(String query){
    final filtered = allPatients.where((patient){
      final nameLower = patient.name.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      patients = filtered;
    });
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE7F3FA),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
              color: const Color(0xFFE7F3FA),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.account_circle, size: 48),
                        const SizedBox(height: 15),
                        const Text(
                          "welcome !",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          "Ruchita",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "How is it going today ?",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/doctor.png',
                    height: 239,
                    width: 160,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6FA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: filterPatients,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search..',
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Patient List",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final patient = patients[index];
                      final avatarIcon = patient.sex.toLowerCase() == 'female'
                          ? Icons.female
                          : Icons.male;

                      return Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  const Color(0xFF4894FE).withOpacity(0.2),
                              child: Icon(avatarIcon,
                                  size: 30, color: const Color(0xFF4894FE)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('MRN: ${patient.mrn}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(patient.name,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text('Gender: ${patient.sex}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: patients.length,
                  ),
                ),
        ],
      ),
    );
  }
}

// class PatientListWidget extends StatefulWidget {
//   const PatientListWidget({super.key});

//   @override
//   State<PatientListWidget> createState() => _PatientListWidgetState();
// }

// class _PatientListWidgetState extends State<PatientListWidget> {
//   List<Patient> patients = [];
//   bool isLoading = true;
  
//   @override
//   void initState(){
//     super.initState();
//     fetchPatients();
//   }

  // Future<void> fetchPatients() async{
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('auth_token');

  //   if(token == null){
  //     print('No token found');
  //     return;
  //   }

  //   final response = await http.get(Uri.parse('http://147.93.106.230:8000/api/patients'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Accept' : 'application/json',
  //     }
  //   );

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     setState(() {
  //       patients = data.map((json) => Patient.fromJson(json)).toList();
  //       isLoading = false;
  //     });
  //   }else {
  //     setState(() => isLoading = false);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to load patients')),
  //     );
  //   }
  // }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading){
//       return const Center(child: CircularProgressIndicator());
//     }

//     return ListView.builder(
//       itemCount: patients.length,
//       itemBuilder: (context, index){
//         final patient = patients[index];
//         final avatarIcon = patient.sex.toLowerCase() == 'female'
//           ? Icons.female
//           : Icons.male;

//         return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 8,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 24,
//                 backgroundColor: const Color(0xFF4894FE).withOpacity(0.2),
//                 child: Icon(avatarIcon, size: 30, color: Color(0xFF4894FE)),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'ID: ${patient.mrn}',
//                       style: const TextStyle(fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 4),
//                     Text(patient.name,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     )),
//                   const SizedBox(height: 2),
//                   Text('Gender: ${patient.sex}'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }