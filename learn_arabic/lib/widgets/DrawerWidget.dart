import 'package:flutter/material.dart';
import '../blocs/util.dart';
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
         
          getTile(context, 'Madinah Arabic Reader Book 1', Icons.book, '/book1', block.bookBloc.isBookNo(1)),
         
          getTile(context, 'Madinah Arabic Reader Book 2', Icons.book, '/book2', block.bookBloc.isBookNo(2)),
          Divider(),
          getTile(context, 'Book Marks', Icons.star, '/markbook'),
        
          getTile(context, 'Settings', Icons.settings, '/setting'),
          getTile(context, 'Rate Apps', Icons.thumb_up, '/rateApps'),
          getTile(context, 'আল হাদীস (Al Hadith)', Icons.thumb_up, '/alhadith'),
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
        else if(navigateTo.startsWith('/rateApps'))
          Util.launchUrl('https://play.google.com/store/apps/details?id=com.zaitun.learnarabic');
        else if(navigateTo.startsWith('/alhadith'))
          Util.launchUrl('https://play.google.com/store/apps/details?id=com.ihadis.ihadis&hl=en');
        else
          Navigator.pushReplacementNamed(context, navigateTo);
      },
      selected: isSelected,
    );
  }
}
