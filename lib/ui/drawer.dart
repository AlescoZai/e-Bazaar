import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_cart/screens/loginPage.dart';
import 'package:shopping_cart/screens/myAccount.dart';

class MyDrawer extends StatefulWidget {
  // bool darkmode = false;
  // MyDrawer(this.darkmode);
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  bool darkmode = false;
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    firebaseAuth.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  String userName() {
    if (currentUser != null) {
      if (currentUser.displayName == null) {
        return currentUser.email.replaceAll('@gmail.com', '');
      }
      return currentUser.displayName;
    } else {
      return "";
    }
  }

  String email() {
    if (currentUser != null) {
      return currentUser.email;
    } else {
      return "No Email Address";
    }
  }

  // String photoUrl() {
  //   if (currentUser != null) {
  //     return currentUser.photoUrl;
  //   } else {
  //     return "No Photo";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFB33771),
            ),
            // accountEmail: Text("ramubugudi4@gmail.com"),
            accountName: Text("${userName()}"),
            accountEmail: Text("${email()}"),
            currentAccountPicture: GestureDetector(
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text("DarkMode"),
            trailing: Switch(
              value: darkmode,
              onChanged: (val) {
                setState(() {
                  darkmode = val;
                });
              },
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: _showList(
              "Home",
              (Icons.home),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyAccount()));
            },
            child: _showList(
              "My Account",
              (Icons.account_box),
            ),
          ),
          InkWell(
            onTap: () {},
            child: _showList(
              "My Orders",
              (Icons.shopping_basket),
            ),
          ),
          InkWell(
            onTap: () {},
            child: _showList(
              "Favorites",
              (Icons.favorite),
            ),
          ),
          InkWell(
            onTap: () {},
            child: _showList(
              "Settings",
              (Icons.settings),
            ),
          ),
          InkWell(
            onTap: () {},
            child: _showList(
              "About",
              (Icons.adjust),
            ),
          ),
          InkWell(
            onTap: () {},
            child: _showList(
              "Contact",
              (Icons.contact_phone),
            ),
          ),
          InkWell(
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              });

              //    Navigator.of(context).push(MaterialPageRoute(
              //                 builder: (context) => Login()));
            },
            child: _showList(
              "LogOut",
              (Icons.exit_to_app),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showList(String s, IconData i) {
    return ListTile(
      leading: Icon(i),
      title: Text(s),
    );
  }
}
