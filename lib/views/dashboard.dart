import 'dart:math';
import 'package:flutter/material.dart';
import 'WelcomePage.dart';
import 'editprofile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ProfilePage.dart';

class Basics extends StatelessWidget {
  const Basics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedTab = "Feed";
  Color selectedColor = Colors.white;

//change here
  Widget _buildFeedWidget() {
    return FutureBuilder(
      future: _getAllUsersTextData(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          final allUsersTextData = snapshot.data!;
          return ListView.builder(
            itemCount: allUsersTextData.length,
            itemBuilder: (BuildContext context, int index) {
              final userTextData = allUsersTextData[index];
              return ListTile(
                title: Text(userTextData['text']),
                subtitle: userTextData['user'] != null
                    ? Text(userTextData['user'])
                    : null,
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<dynamic>> _getAllUsersTextData() async {
    final response = await http.get(Uri.parse(
        'https://us-central1-ashesi-social-network-384320.cloudfunctions.net/ashesiSocialNetwork/all_users_text_data'));
    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body) as Map<String, dynamic>;
      final allUsersTextData =
          decodedJson['all_users_text_data'] as List<dynamic>;
      return allUsersTextData;
    } else {
      throw Exception('Failed to fetch all users text data');
    }
  }

  final emailController = TextEditingController();

  Widget _buildCreateWidget() {
    final TextEditingController textEditingController = TextEditingController();
    final TextEditingController emailEditingController =
        TextEditingController();

    Future<void> _createTextData(String email) async {
      // First, get the user's user_id from their email
      final http.Response response = await http.get(
        Uri.parse(
            'https://us-central1-ashesi-social-network-384320.cloudfunctions.net/ashesiSocialNetwork/users_data/current_user_id_from_email?email=$email'),
      );
      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get user_id from email')),
        );
        return;
      }
      final user_id = jsonDecode(response.body)['user_id'];

      // Then, create the text data for the user
      final textData = <String, dynamic>{
        'text': textEditingController.text,
      };
      final http.Response textResponse = await http.post(
        Uri.parse(
            'https://us-central1-ashesi-social-network-384320.cloudfunctions.net/ashesiSocialNetwork/users_text_data/$user_id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(textData),
      );
      if (textResponse.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Text data created successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create text data')),
        );
      }
    }

    return Column(
      children: <Widget>[
        TextFormField(
          controller: emailEditingController,
          decoration: InputDecoration(
            labelText: 'Email',
          ),
        ),
        TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            labelText: 'Text Data',
          ),
        ),
        ElevatedButton(
          onPressed: () => _createTextData(emailEditingController.text),
          child: Text('Create'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("Make a post"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.brown),
            label: 'Create New Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.brown),
            label: 'Feed Page',
          ),
        ],
        onTap: (index) {
          setState(() {
            if (index == 0) {
              selectedTab = "Create";
            } else if (index == 1) {
              selectedTab = "Feed";
            }
          });
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: Text(
                "Dashboard",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),

            ListTile(
              title: const Text("My Profile"),
              onTap: () async {
                Navigator.pop(context);
                final BuildContext dialogContext = context; // capture context
                final email = await showDialog<String>(
                  context: dialogContext, // use captured context
                  builder: (BuildContext context) {
                    String inputText = '';
                    return AlertDialog(
                      title: const Text('Enter Your Email'),
                      content: TextField(
                        onChanged: (value) {
                          inputText = value;
                        },
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(inputText);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => email != null
                        ? ProfilePage(email: email)
                        : const SizedBox.shrink(), // or some other fallback
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Update Profile"),
              onTap: () async {
                Navigator.pop(context);
                final BuildContext dialogContext = context; // capture context
                final email = await showDialog<String>(
                  context: dialogContext, // use captured context
                  builder: (BuildContext context) {
                    String inputText = '';
                    return AlertDialog(
                      title: const Text('Enter Your Email'),
                      content: TextField(
                        onChanged: (value) {
                          inputText = value;
                        },
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(inputText);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                // Fetch the user ID using the email entered by the user
                final response = await http.get(Uri.parse(
                    'https://us-central1-ashesi-social-network-384320.cloudfunctions.net/ashesiSocialNetwork/users_data/current_user_id_from_email?email=$email'));
                if (response.statusCode == 200) {
                  final userId = json.decode(response.body)['user_id'];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfilePage(email: email!, userId: userId!),
                    ),
                  );
                } else {
                  // Handle error when user is not authenticated
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('User not authenticated'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),

            // import 'ProfilePage.dart';

            ListTile(
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: selectedTab == "Feed" ? _buildFeedWidget() : _buildCreateWidget(),
    );
  }
}
