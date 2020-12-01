import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:windowshoppi/src/account/account_files.dart';
import 'package:windowshoppi/src/bloc/bloc_files.dart';
import 'package:windowshoppi/src/utilities/expandable_text.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationStates>(
      builder: (context, state) {
        if (state is IsAuthenticated) {
          var data = state.user;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    print('change profile picture');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300], width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                        shape: BoxShape.rectangle,
                      ),
                      child: Icon(
                        Icons.account_box,
                        color: Colors.grey[300],
                        size: 70,
                      ),
                    ),
                  ),
                ),
                Text(
                  '${data.accountName}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                if (data.group == 'vendor')
                  if (data.email != null)
                    Text(
                      '${data.email}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                if (data.group == 'windowshopper') Divider(),
                if (data.group == 'vendor')
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: FaIcon(
                                  FontAwesomeIcons.phone,
                                  size: 15.0,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text('${data.call}'),
                              dense: true,
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: Color(0xFF06B862),
                                child: FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                              title: data.whatsapp != null
                                  ? Text('${data.whatsapp}')
                                  : WhatsappNumberPopUp(),
                              dense: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8.0,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ' ${data.businessBio}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                      if (data.accountBio != null)
                        Container(
                          alignment: Alignment.centerLeft,
                          child: ExpandableText(
                            text: '${data.accountBio}',
                            trimLines: 3,
                            readLess: true,
                          ),
                        ),
                    ],
                  ),
                if (data.group == 'windowshopper')
                  Column(
                    children: [
                      if (data.email != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.email,
                                size: 16,
                                color: Colors.grey,
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: ' ${data.email}',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ' (private)',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.call,
                              size: 16,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: ' ${data.call}',
                                  style: Theme.of(context).textTheme.bodyText1,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' (private)',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (data.accountBio != null)
                        Container(
                          alignment: Alignment.centerLeft,
                          child: ExpandableText(
                            text: '${data.accountBio}',
                            trimLines: 3,
                            readLess: true,
                          ),
                        ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: OutlineButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  data.group == 'windowshopper'
                                      ? UpdateProfileInit()
                                      : VendorUpdateProfileInit(),
                            ),
                          );
                        },
                        child: Text('edit profile'),
                      ),
                    ),
                    if (data.group == 'windowshopper')
                      SizedBox(
                        width: 8.0,
                      ),
                    if (data.group == 'windowshopper')
                      Expanded(
                        flex: 2,
                        child: RaisedButton(
                          color: Colors.teal,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => IntroScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'switch to business account',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
