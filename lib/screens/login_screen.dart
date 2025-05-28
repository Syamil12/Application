import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  Future<bool> loginUser(String email, String password) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email' : email,
          'password' : password,
          })
        );

        if (response.statusCode == 201){
          print('Response: ${response.body}');
          return true;
        } else {
          print('Failed: ${response.statusCode}');
          return false;
        }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(padding:const EdgeInsets.symmetric(horizontal: 30, vertical: 106),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text('Welcome',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4894FE),
                    ),
                  ),
                ),
                const SizedBox(height: 88),
                Text(
                  'Email', 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'example@example.com',
                    filled: true,
                    fillColor: Color(0xFFECF1FF),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty){
                      return 'Please enter your email';
                    } else if (!value.contains('@')){
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) => email = value!,
                ),
                const SizedBox(height: 20),
                Text(
                  'Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                const SizedBox(height: 12),

                TextFormField(
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: '*************',
                    filled: true,
                    fillColor: Color(0xFFECF1FF),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      }, 
                      icon: Icon(
                        _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                        color: Colors.black,
                        )
                      ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty){
                      return 'Please enter your password';
                    } else if (value.length < 6){
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onSaved: (value) => password = value!,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: (){

                  }, child: Text('Forgot Password', style: TextStyle(color: Color(0xFF4894FE)),)),
                ),
                const SizedBox(height: 37),

                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()){
                        _formKey.currentState!.save();
                        bool success = await loginUser(email, password);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success
                              ? 'Login successful!'
                              : 'Login failed. Try again.'),
                          )
                        );

                        if (success){

                        }
                      }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: 
                      EdgeInsets.symmetric(horizontal: 100, vertical: 14),
                    backgroundColor: Color(0xFF4894FE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )
                  ), 
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Color(0xFF4894FE)
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}