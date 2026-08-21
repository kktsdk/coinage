import 'package:coinage/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class InviteFriendsItem extends StatelessWidget {
  const InviteFriendsItem({super.key});

  static const String inviteUrl = 'https://www.7solutions.co.th/jobs';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return InkWell(
      onTap: () {
        SharePlus.instance.share(ShareParams(text: inviteUrl));
      },
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_add_alt_1_rounded, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  localizations.inviteFriends,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.red),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFe5e7eb)),
        ],
      ),
    );
  }
}
