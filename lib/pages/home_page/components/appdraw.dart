import 'package:flutter/material.dart';
import 'package:flutter_log/pages/profile_page/profile_page.dart'; // replace with your actual package names
import 'package:flutter_log/pages/recipe_generation_page/generation_page.dart';
import 'package:flutter_log/pages/add_recipe_page/add_recipe.dart';
import 'package:flutter_log/pages/add_remove_ingredients_page/add_remove_ingredients_page.dart';
import 'package:flutter_log/pages/faqs_page/FAQ_page.dart';
import 'package:flutter_log/pages/about_us_page/about_page.dart';

class AppDrawer extends StatelessWidget {
  final Function _signOut;

  AppDrawer(this._signOut);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.79,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.125,
            child: const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 50),
              ),
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.person, size: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                const Text('User Profile', style: TextStyle(fontSize: 20)),
              ],
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.generating_tokens, size: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                const Text('Generate Recipe', style: TextStyle(fontSize: 20)),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GenerationPage()));
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.cookie, size: 29),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                const Text('Add Recipe', style: TextStyle(fontSize: 20)),
              ],
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddRecipe()));
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.edit, size: 28),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                const Text('Ingredients Manager',
                    style: TextStyle(fontSize: 20)),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddRemoveIngredients()));
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.question_answer, size: 28),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                const Text('FAQ', style: TextStyle(fontSize: 20)),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => FAQ_page()));
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.info, size: 28),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Text('About Us', style: TextStyle(fontSize: 20)),
              ],
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()));
            },
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.logout, size: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                const Text('Log Out', style: TextStyle(fontSize: 20)),
              ],
            ),
            onTap: () {
              _signOut();
            },
          ),
        ],
      ),
    );
  }
}
