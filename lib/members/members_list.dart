import 'package:archery_club/constant/brand_colors.dart';
import 'package:archery_club/home.dart';
import 'package:archery_club/members/create_members.dart';
import 'package:archery_club/members/detail_members.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MembersList extends StatefulWidget {
  const MembersList({Key? key}) : super(key: key);

  @override
  State<MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference members = firestore.collection('members');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Club Member",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: BrandColor.colorPrimary,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => _selectedMenu(value, context),
            itemBuilder: (context) {
              return Menu.choices.map((String choice) {
                return PopupMenuItem(
                  child: Text(choice),
                  value: choice,
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: members.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: snapshot.data.docs.map<Widget>((doc) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => DetailMembersScreen())));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                child: ClipRRect(
                                  child: Image.asset('assets/img/user.png'),
                                  borderRadius : BorderRadius.circular(50)
                                ),
                              ),
                              title: Text(doc.data()['name']),
                              subtitle: Text(doc.data()['gender']),
                              trailing: const Text("Lihat Detail"),
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return Text('0');
                    }
                  })
            ],
          ),
        ),
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: ListView.builder(
      //     itemCount: 5,
      //     itemBuilder: (context, index) {
      //       return Card(
      //         child: ListTile(
      //           leading: const CircleAvatar(),
      //           title: Text("Anggota ${index + 1}"),
      //           subtitle: const Text("Subtitle"),
      //           trailing: const Text("Lihat Detail"),
      //         ),
      //       );
      //     },
      //   ),
      // ),
    );
  }

  void _selectedMenu(String choice, BuildContext context) {
    setState(() {
      if (choice == Menu.addMember) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreateMembers()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home()));
      }
    });
  }
}

class Menu {
  static const String addMember = 'Add New Member';
  static const String excelMigration = 'Excel Migration';

  static const List<String> choices = <String>[addMember, excelMigration];
}
