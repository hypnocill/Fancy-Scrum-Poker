import 'package:fancyscrumpoker/src/bloc/settings/settings_bloc_provider.dart';
import 'package:fancyscrumpoker/src/config/config.dart';
import 'package:fancyscrumpoker/src/config/settings.dart';
import 'package:fancyscrumpoker/src/widgets/drawer_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:fancyscrumpoker/src/bloc/task/task_bloc_provider.dart';
import 'package:fancyscrumpoker/src/widgets/singe_card.dart';

class Choice extends StatelessWidget with DrawerMixin {
  final TextEditingController _textFieldController = TextEditingController();

  Choice();

  @override
  Widget build(BuildContext context) {
    TaskBloc _taskBloc = TaskBlocProvider.of(context);
    SettingsBloc _settingsBloc = SettingsBlocProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _titleStreamBuilder(_taskBloc),
      ),
      drawer: buildDrawer(context),
      body: _bodyStreamBuilder(_settingsBloc),
      floatingActionButton: _floatinActionButtonStreamBuilder(_settingsBloc),
    );
  }

  StreamBuilder _titleStreamBuilder(TaskBloc taskBloc) {
    return StreamBuilder(
      stream: taskBloc.getTaskNameStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Text(
          snapshot.data != null ? 'Voting for: ${snapshot.data}' : 'Vote',
          overflow: TextOverflow.fade,
        );
      },
    );
  }

  StreamBuilder _bodyStreamBuilder(SettingsBloc settingsBloc) {
    return StreamBuilder(
      stream: settingsBloc.getSettingsStream(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }
        return _buildGrid(snapshot.data as Settings);
      },
    );
  }

  StreamBuilder _floatinActionButtonStreamBuilder(SettingsBloc settingsBloc) {
    return StreamBuilder(
      stream: settingsBloc.getSettingsStream(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }

        Settings settings = snapshot.data as Settings;

        if (settings.getAlwaysAskForTaskNameSetting()) {
          return Container();
        }

        return _buildFloatinActionButton(context);
      },
    );
  }

  Widget _buildGrid(Settings settings) {
    final bool shouldAskForTaskName = settings.getAlwaysAskForTaskNameSetting();
    final String cardConfigTitle = settings.getSelectedScreenOption();
    final List<String> cardConfig = _getCardConfigFromTitle(cardConfigTitle);

    return AnimationLimiter(
      child: GridView.builder(
        padding: EdgeInsets.all(5),
        itemCount: cardConfig.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (BuildContext context, int index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 700),
            columnCount: 3,
            child: SlideAnimation(
              verticalOffset: 100.0,
              delay: Duration(milliseconds: 100),
              child: _buildCard(
                context,
                cardConfig[index],
                cardConfigTitle,
                shouldAskForTaskName,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, String text, String type, bool shouldAskForTaskName) {
    return GestureDetector(
      child: Hero(
        tag: text,
        child: Material(
          child: SingleCard(
            text,
            Color.fromRGBO(81, 82, 89, 1),
          ),
          type: MaterialType.transparency,
        ),
      ),
      onTap: () async {
        if (!shouldAskForTaskName) {
          _navigateToRevealScreen(context, text, type);
          return;
        }

        await showDialog(
          context: context,
          builder: (context) => _showTaskNamePrompt(context),
        );
        Future.delayed(
          const Duration(milliseconds: 400),
          () {
            _navigateToRevealScreen(context, text, type);
          },
        );
      },
    );
  }

  _navigateToRevealScreen(BuildContext context, String cardText, String cardType) {
    Navigator.pushNamed(
      context,
      '/reveal',
      arguments: {'vote': cardText, 'type': cardType.toLowerCase()},
    );
  }

  _buildFloatinActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => _showTaskNamePrompt(context),
        );
      },
      child: Icon(Icons.add),
    );
  }

  StreamBuilder _showTaskNamePrompt(BuildContext context) {
    TaskBloc _taskBloc = TaskBlocProvider.of(context);

    return StreamBuilder(
      stream: _taskBloc.getTaskErrorStream(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return AlertDialog(
          title: Text(
            snapshot.data ?? 'You will vote for:',
            style: TextStyle(color: snapshot.data != null ? Colors.red[300] : Colors.white),
          ),
          content: TextField(
            keyboardType: TextInputType.text,
            autofocus: true,
            onChanged: (text) => _taskBloc.typeTaskName(text),
            controller: _textFieldController,
            decoration: InputDecoration(hintText: 'Task name'),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () async {
                String taskName = _taskBloc.getTypedTaskNameStream().value;
                if (await _taskBloc.taskExistInDatabase(taskName)) {
                  _taskBloc.setError(
                    'Task "${taskName}" already exists in your records!' +
                        '\nTask names should be unique.' +
                        '\nPlease choose anoter name or delete the daily record containing the task!',
                  );
                  return;
                }

                _taskBloc.saveTaskNameToState(taskName);
                Navigator.of(context).pop();
                _textFieldController.clear();
                _taskBloc.setError(null);
              },
            )
          ],
        );
      },
    );
  }

  List<String> _getCardConfigFromTitle(String title) {
    switch (title) {
      case Config.CARD_TEXT_DEFAULT_TITLE:
        return Config.CARD_TEXT_DEFAULT;
      case Config.CARD_TEXT_FIBONACCI_TITLE:
        return Config.CARD_TEXT_FIBONACCI;
      case Config.CARD_TEXT_SIZES_TITLE:
        return Config.CARD_TEXT_SIZES;
      default:
        return Config.CARD_TEXT_DEFAULT;
    }
  }
}
