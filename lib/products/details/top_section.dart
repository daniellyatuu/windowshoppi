import 'package:flutter/material.dart';
import 'package:windowshoppi/account/account.dart';

class TopSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22.0,
        child: CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('images/shop.jpg'),
        ),
      ),
      title: Text(
        'account name',
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        'location',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: OutlineButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: Colors.red,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PageAccount(),
            ),
          );
        },
        child: Text('visit'),
      ),
    );
  }
}
