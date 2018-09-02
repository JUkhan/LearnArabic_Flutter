import 'package:flutter/material.dart';
import '../blocs/StateMgmtBloc.dart';

class DrawerWidget extends StatelessWidget {
  final StateMgmtBloc block;
  DrawerWidget(this.block);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: StreamBuilder(
                initialData: '',
                stream: block.bookBloc.bookName,
                builder: (_, snapshot)=>Text(snapshot.data),
              ),
              accountEmail: StreamBuilder<String>(
                  initialData: '',
                  stream: block.bookBloc.lessonInfo,
                  builder: (_, snapshot) {
                    return snapshot.data.isEmpty
                        ? Text('')
                        : OutlineButton(                           
                            child: Text(snapshot.data,),
                            onPressed: () {
                               Navigator.pushReplacementNamed(context, '/book');
                            },
                          );
                  }),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: AssetImage('assets/launcher.png'),
              )),
          getTile(context, 'Home', Icons.home, '/'),
         
          getTile(context, 'Book1', Icons.favorite, '/book1'),
         
          getTile(context, 'Book2', Icons.favorite, '/book2'),
          Divider(),
          getTile(context, 'Book Marks', Icons.star, '/markbook'),
        
          getTile(context, 'Settings', Icons.settings, '/setting'),
         
        ],
      ),
    );
  }

  ListTile getTile(
      BuildContext context, String title, IconData icon, String navigateTo,
      [bool isSelected = false]) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: () {
        block.navAction(navigateTo);
        if (navigateTo.startsWith('/book'))
          Navigator.pushReplacementNamed(context, '/lessons');
        else
          Navigator.pushReplacementNamed(context, navigateTo);
      },
      selected: isSelected,
    );
  }
}
