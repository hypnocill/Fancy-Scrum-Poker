import 'package:flutter/material.dart';

import 'package:fancyscrumpoker/src/bloc/settings/settings_bloc_provider.dart';
import 'package:fancyscrumpoker/src/config/config.dart';
import 'package:fancyscrumpoker/src/config/settings.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share/share.dart';

const _defaultTextColor = Color.fromRGBO(235, 235, 235, 1);
const _darkGrey = Color.fromRGBO(81, 82, 89, 1);
const _listTileDefaultIcon = Icon(Icons.keyboard_arrow_right, size: 18.0, color: _defaultTextColor);

class DrawerMixin {
  Widget buildDrawer(BuildContext context) {
    SettingsBloc _bloc = SettingsBlocProvider.of(context);

    return StreamBuilder(
      stream: _bloc.getSettingsStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }

        return _buildDrawer(context, _bloc, snapshot.data as Settings);
      },
    );
  }

  Widget _buildDrawer(BuildContext context, SettingsBloc bloc, Settings settings) {
    final String selectedTitle = settings.getSelectedScreenOption();

    return Drawer(
      child: Container(
        color: Color.fromRGBO(36, 36, 38, 1),
        child: Column(
          children: <Widget>[
            Expanded(
              // put this inside a method of its own
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: 150,
                    child: DrawerHeader(
                      child: Center(
                        child: Text(''),
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/drawer_header_2.jpg'),
                        ),
                        color: _darkGrey,
                      ),
                    ),
                  ),
                  Container(
                    color: selectedTitle == Config.CARD_TEXT_DEFAULT_TITLE ? _darkGrey : null,
                    child: ListTile(
                        trailing: _listTileDefaultIcon,
                        title: Text(
                          Config.CARD_TEXT_DEFAULT_TITLE.toUpperCase(),
                          style: TextStyle(color: _defaultTextColor),
                        ),
                        onTap: () {
                          bloc.setSelectedScreen(Config.CARD_TEXT_DEFAULT_TITLE);
                          Navigator.pop(context);
                        }),
                  ),
                  Container(
                    color: selectedTitle == Config.CARD_TEXT_FIBONACCI_TITLE ? _darkGrey : null,
                    child: ListTile(
                        trailing: _listTileDefaultIcon,
                        title: Text(
                          Config.CARD_TEXT_FIBONACCI_TITLE.toUpperCase(),
                          style: TextStyle(color: _defaultTextColor),
                        ),
                        onTap: () {
                          bloc.setSelectedScreen(Config.CARD_TEXT_FIBONACCI_TITLE);
                          Navigator.pop(context);
                        }),
                  ),
                  Container(
                    color: selectedTitle == Config.CARD_TEXT_SIZES_TITLE ? _darkGrey : null,
                    child: ListTile(
                        trailing: _listTileDefaultIcon,
                        title: Text(
                          Config.CARD_TEXT_SIZES_TITLE.toUpperCase(),
                          style: TextStyle(color: _defaultTextColor),
                        ),
                        onTap: () {
                          bloc.setSelectedScreen(Config.CARD_TEXT_SIZES_TITLE);
                          Navigator.pop(context);
                        }),
                  ),
                  Divider(thickness: 1.0),
                  ListTile(
                    trailing: _listTileDefaultIcon,
                    title: Text(
                      'HISTORY',
                      style: TextStyle(color: _defaultTextColor),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/stats');
                    },
                  ),
                  Divider(thickness: 1.0),
                  SwitchListTile(
                    dense: true,
                    inactiveThumbColor: _darkGrey,
                    activeColor: Color.fromRGBO(217, 217, 217, 1),
                    onChanged: (newValue) => bloc.toggleShakeOnRevealSetting(),
                    value: settings?.getShakeOnRevealSetting(),
                    title: Text(
                      'Reveal Vote on Shake',
                      style: TextStyle(color: _defaultTextColor),
                    ),
                  ),
                  SwitchListTile(
                    dense: true,
                    inactiveThumbColor: _darkGrey,
                    activeColor: Color.fromRGBO(217, 217, 217, 1),
                    onChanged: (newValue) => bloc.toggleKeepScreenOn(),
                    value: settings?.getKeepScreenOn(),
                    title: Text(
                      'Keep Screen On While Voting',
                      style: TextStyle(color: _defaultTextColor),
                    ),
                  ),
                  SwitchListTile(
                    dense: true,
                    inactiveThumbColor: _darkGrey,
                    activeColor: Color.fromRGBO(217, 217, 217, 1),
                    onChanged: (newValue) => bloc.toggleAlwaysAskForTaskNameSetting(),
                    value: settings?.getAlwaysAskForTaskNameSetting(),
                    title: Text(
                      'Always Ask for Task Name',
                      style: TextStyle(color: _defaultTextColor),
                    ),
                  ),
                ],
              ),
            ), //// END OF LIST VIEW!!!
            Divider(),
            Container(
              padding: EdgeInsets.only(bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/about');
                    },
                    child: Icon(Icons.info, size: 45.0, color: _defaultTextColor),
                  ),
                  InkWell(
                    onTap: _shareAppAction,
                    child: Icon(Icons.share, size: 45.0, color: _defaultTextColor),
                  ),
                  InkWell(
                    onTap: _reviewAppAction,
                    child: Icon(Icons.star, size: 45.0, color: _defaultTextColor),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _shareAppAction() {
    Share.share(
        'Check out a Fancy Scrum Planning App - https://play.google.com/store/apps/details?id=com.fancyscrumpoker',
        subject: 'Fancy Scrum Planning App');
  }

  void _reviewAppAction() {
    LaunchReview.launch();
  }
}
