import 'package:application/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

var nameController = TextEditingController();
var emailController = TextEditingController();
var passwordController = TextEditingController();

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  String name = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 106),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4894FE),
                    ),
                  ),
                ),
                SizedBox(height: 88),

                Text('Full Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                TextFormField(
                  controller: nameController,
                  decoration: _inputDecoration(),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter your name' : null,
                  onSaved: (value) => name = value!,
                ),
                SizedBox(height: 18),

                Text('Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: _inputDecoration(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) => email = value!,
                ),
                SizedBox(height: 18),

                Text('Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 12),
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration().copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  onSaved: (value) => password = value!,
                ),
                SizedBox(height: 30),

                Center(
                  child: ElevatedButton(
                    onPressed: (){
                      signup();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 14),
                      backgroundColor: Color(0xFF4894FE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => LoginScreen()),); // go back to login
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Color(0xFF4894FE)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signup() async{
    if (nameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
      try {
        var response =await http.post(Uri.parse('http://147.93.106.230:8000/api/register'), body: {
        'name' : nameController.text,
        'email': emailController.text,
        'password': passwordController.text
         }
        );
        if(response.statusCode == 200){
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        } else if(response.statusCode == 422){
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('This email is already registered')),);
        } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sign up failed. Please try again')),);
          }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occured: $e')),);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all the fields')),);
    }
  }

}

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Color(0xFFECF1FF),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),
    );
  }