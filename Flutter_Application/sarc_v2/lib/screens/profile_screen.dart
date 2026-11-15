import 'package:flutter/material.dart';

import '../core/i18n.dart';
import '../core/theme.dart';
import '../state/app_state.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Tr('Log out?'),
        content: const Tr(
          'Your name, number, state and district will be removed from this '
          'device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Tr('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Tr('Log out'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await profileStore.clear();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: profileStore,
      builder: (context, _) {
        final p = profileStore.profile;
        return Scaffold(
          appBar: AppBar(title: const Tr('My profile')),
          body: p == null
              ? const Center(child: Tr('You are not signed in.'))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    SarcCard(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: SarcColors.blue,
                            child: const Icon(Icons.person,
                                size: 36, color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            p.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: SarcColors.navy,
                            ),
                          ),
                          const Divider(height: 28),
                          _row(Icons.phone_outlined, 'Mobile number',
                              '+91 ${p.mobile}'),
                          const SizedBox(height: 12),
                          _row(Icons.map_outlined, 'State', p.state),
                          const SizedBox(height: 12),
                          _row(Icons.location_city_outlined, 'District',
                              p.district),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LoginScreen(existing: p),
                        ),
                      ),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Tr('Edit details'),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () => _logout(context),
                      icon: Icon(Icons.logout, color: SarcColors.official),
                      label: Tr(
                        'Log out',
                        style: TextStyle(color: SarcColors.official),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: SarcColors.blue),
        const SizedBox(width: 12),
        Tr(label, style: TextStyle(color: SarcColors.textMuted)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
