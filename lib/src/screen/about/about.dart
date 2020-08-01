import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

const PRIVACY_POLICY_URL = 'https://fancy-scrum-poker.web.app/';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              _buildMainAppDescription(),
              SizedBox(height: 15.0),
              Divider(),
              SizedBox(height: 15.0),
              _buildContactDetailsDescription(),
              SizedBox(height: 15.0),
              _buildContactEmailButton(),
              SizedBox(height: 15.0),
              Divider(),
              SizedBox(height: 15.0),
              _buildAppPrivacyPolicyDescription(),
              SizedBox(height: 15.0),
              _buildPrivacyPolicyButton(),
              SizedBox(height: 15.0),
              Divider(),
              _buildAppDetailedDescription(),
            ],
          ),
        ),
      ),
    );
  }

  RichText _buildMainAppDescription() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 16.0,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Fancy Scrum Poker',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: ' (v1.0.0)',
          ),
          TextSpan(
            text: ' is a free app aimed at assisting you during ' +
                'your Scrum plannings and in particular - during the task voting.',
          )
        ],
      ),
    );
  }

  Text _buildContactDetailsDescription() {
    return Text(
      'To report a bug, request a feature, ask any questions' + ' or just to say hello, you can: ',
      style: TextStyle(
        fontSize: 16.0,
      ),
    );
  }

  FlatButton _buildContactEmailButton() {
    return FlatButton(
      color: Color.fromRGBO(81, 82, 89, 1),
      onPressed: _sendEmail,
      child: Text(
        'SEND AN EMAIL',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  ExpansionTile _buildAppDetailedDescription() {
    return ExpansionTile(
      title: Text('Detailed App Functionality'),
      children: <Widget>[
        Text(
          '\n\nWith this App, you can vote for your tasks with different types ' +
              'of cards. You have the options to vote for unnamed or named tasks.' +
              '\nIf you decide to vote for named tasks - you can do it either using ' +
              'the action button in the corner of the home screen or by selecting' +
              ' the option in the Drawer menu to be always prompted to enter a task name.' +
              '\nThen you will have to type a task name and vote for it.' +
              '\n\nAfter you have voted for a named task, the task' +
              '(its name, vote, time, vote type) will be added to your daily record.' +
              '\nAll daily records that have at least one named voted task will be ' +
              'stored in your History, which you can view from the Drawer menu on the home screen',
        ),
        SizedBox(height: 25.0),
        Text(
          'IMPORTANT',
          style: TextStyle(color: Colors.red[300], fontWeight: FontWeight.w600),
        ),
        Text(
          '\nThe named tasks you vote for are ONLY stored on your device!' +
              '\nThe data is not backed up or sent anywhere.\nIt means that you will ' +
              'lose the records of the named tasks you voted for forever if' +
              ' you delete a daily record within the App, ' +
              'clear the App cache, uninstall/install the App or perform any other action' +
              ' that wipes your locally stored data!',
        ),
        SizedBox(height: 8.0)
      ],
    );
  }

  Text _buildAppPrivacyPolicyDescription() {
    return Text(
      'You can check the privacy policy of the App by going to ' +
          '${PRIVACY_POLICY_URL} or via the button below:',
    );
  }

  void _sendEmail() async {
    final Email email = Email(
      subject: 'Fancy Scrum Poker user',
      recipients: ['hypnocill@gmail.com'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  FlatButton _buildPrivacyPolicyButton() {
    return FlatButton(
      color: Color.fromRGBO(81, 82, 89, 1),
      onPressed: _launchPrivacyPolicyUrl,
      child: Text(
        'PRIVACY POLICY',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  void _launchPrivacyPolicyUrl() async {
    try {
      if (await canLaunch(PRIVACY_POLICY_URL)) {
        await launch(PRIVACY_POLICY_URL);
      }
    } catch (e) {
      print('Exception - Cannot launch privacy policy url!');
    }
  }
}
