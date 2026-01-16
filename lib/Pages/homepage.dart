import 'package:messagingapp/Services/chats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchcontroller = TextEditingController();
  bool issearching = false;
  String searchtext = '';
  @override
  Widget build(BuildContext context) {
    final currentuser1 = FirebaseAuth.instance.currentUser;
//     User has properties like:

// email

// uid

// displayName

// photoURL
    return Scaffold(
      appBar: AppBar(
        title: issearching
            ? TextFormField(
                controller: _searchcontroller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search email...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    searchtext = value.toLowerCase();
                  });
                },
              )
            : const Text('Home'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (issearching) {
                  _searchcontroller.clear();
                  searchtext = '';
                }
                issearching = !issearching;
              });
            },
            icon: Icon(issearching ? Icons.clear : Icons.search, size: 20),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: const [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://wallpapers.com/images/hd/aesthetic-laptop-drawing-kzs2xmyje63oewbt.jpg',
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aman',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('amanranabhat30@gmail.com'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact'),
              onTap: () async {
                final Uri githubUri = Uri.parse('https://github.com/AmanRB13');

                if (await canLaunchUrl(githubUri)) {
                  await launchUrl(
                    githubUri,
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Could not open GitHub'),
                    ),
                  );
                }
              },
            ),
            TextButton(
              onPressed: () {},
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  currentuser1 == null
                      ? 'No User'
                      : 'You: ${currentuser1.email} ',
                ),
              ),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Log out',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/auth');
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          final currentUser = FirebaseAuth.instance.currentUser;

          final users = snapshot.data!.docs.where((doc) {
            final email = doc['email'].toString().toLowerCase();
            final uid = doc['uid'];

            if (uid == currentUser!.uid) return false;

            return email.contains(searchtext);
          }).toList();

          if (users.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final email = users[index]['email'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chatsscreen(
                          receiverUid: users[index]['uid'],
                          receiverEmail: users[index]['email'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent.shade100.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, size: 25, color: Colors.black),
                        Expanded(
                          child: Center(
                            child: Text(
                              email,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
