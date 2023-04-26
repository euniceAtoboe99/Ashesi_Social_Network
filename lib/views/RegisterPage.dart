import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LoginPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  final _emailController = TextEditingController();
  final _majorController = TextEditingController();
  final _passwordController = TextEditingController();

  final _studentIdNumberController = TextEditingController();
  final _dOBController = TextEditingController();
  final _yearGroupController = TextEditingController();
  final _campusResidenceController = TextEditingController();
  final _bestFoodController = TextEditingController();
  final _bestMovieController = TextEditingController();

  Future<void> _submitForm() async {
    final url =
        'https://us-central1-ashesi-social-network-384320.cloudfunctions.net/ashesiSocialNetwork/users_data';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': _nameController.text,
        'studentIdNumber': _studentIdNumberController.text,
        'dOB': _dOBController.text,
        'yearGroup': _yearGroupController.text,
        'campusResidence': _campusResidenceController.text,
        'bestFood': _bestFoodController.text,
        'bestMovie': _bestMovieController.text,
        'email': _emailController.text,
        'Major': _majorController.text,
        'password': _passwordController.text,
      }),
    );
    if (response.statusCode == 200) {
      // Registration successful, display success message and navigate to login page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful.'),
        ),
      );
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      // Registration failed, display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register here to connect'),
          backgroundColor: Colors.brown,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _studentIdNumberController,
                    decoration: InputDecoration(labelText: 'Name:'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name:';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Student ID'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Student ID:';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email:'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email:';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dOBController,
                    decoration: InputDecoration(labelText: 'Date of Birth:'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date of Birth:';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _yearGroupController,
                    decoration: InputDecoration(labelText: 'Year Group:'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Year Group:';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _majorController,
                    decoration: InputDecoration(labelText: 'Major:'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'I major in:';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _campusResidenceController,
                    decoration: InputDecoration(labelText: 'Residence Type'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Residence Type ';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _bestFoodController,
                    decoration: InputDecoration(labelText: 'Best food'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Best food';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _bestMovieController,
                    decoration: InputDecoration(labelText: 'Best Movie?'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Best Movie';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Enter password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitForm();

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        backgroundColor: Colors.brown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
