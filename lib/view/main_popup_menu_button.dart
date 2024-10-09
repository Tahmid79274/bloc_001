import 'package:bloc101/bloc/app_bloc.dart';
import 'package:bloc101/bloc/app_event.dart';
import 'package:bloc101/dialog/delete_account_dialog.dart';
import 'package:bloc101/dialog/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MenuAction { logut, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logut:
            final shouldLogout = await showLogOutDialog(context);
            if (shouldLogout) {
              context.read<AppBloc>().add(const AppEventLogOut());
            }
            break;
          case MenuAction.deleteAccount:
            final shouldDelete = await showDeleteAccountDialog(context);
            if (shouldDelete) {
              context.read<AppBloc>().add(const AppEventDeleteAccount());
            }
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logut,
            child: Text('Logout'),
          ),
          const PopupMenuItem<MenuAction>(
            value: MenuAction.deleteAccount,
            child: Text('Delete'),
          ),
        ];
      },
    );
  }
}
