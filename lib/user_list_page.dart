import 'package:flutter/material.dart';
import 'add_user_page.dart';
import 'database_helper.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();

}

class _UserListPageState extends State<UserListPage> {
  final _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _users = [];
  int _totalUsers = 0;



  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    final users = await _databaseHelper.getUsers();
    setState(() {

      _users = List<Map<String, dynamic>>.from(users);
      _totalUsers = _users.length;
    });
  }

  void _deleteUser(int userId) async {
    await _databaseHelper.deleteUser(userId);
    setState(() {
      _users.removeWhere((user) => user['id'] == userId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kullanıcı başarıyla silindi.'),
      ),
    );
    _loadUsers();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcılar'),

      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddUserPage()),
                ).then((_) {
                  _loadUsers();
                });
              },

              child: Text('Yeni Kullanıcı Ekle'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Toplam Kullanıcı Sayısı: $_totalUsers',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    title: Text(user['name']),
                    subtitle: Text(user['email']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Kullanıcıyı Sil'),
                              content: Text('Kullanıcıyı silmek istiyor musunuz?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('İptal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteUser(user['id']);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Sil'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
