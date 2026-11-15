import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants.dart';
import '../core/i18n.dart';
import '../core/theme.dart';
import '../data/india_regions.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/common_widgets.dart';
import 'main_shell.dart';

/// Sign-in / registration: name, mobile number, state and district.
/// Used first-time (no [existing]) and for editing the profile.
class LoginScreen extends StatefulWidget {
  final UserProfile? existing;
  const LoginScreen({super.key, this.existing});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _mobile;
  late final TextEditingController _districtText;
  String? _state;
  String? _districtChoice; // used when the state is Sikkim
  bool _agree = false;
  bool _saving = false;

  bool get _editing => widget.existing != null;
  bool get _isSikkim => _state == IndiaRegions.sikkim;

  @override
  void initState() {
    super.initState();
    final p = widget.existing;
    _name = TextEditingController(text: p?.name ?? '');
    _mobile = TextEditingController(text: p?.mobile ?? '');
    _districtText = TextEditingController();
    _state = p?.state;
    if (p != null) {
      if (p.state == IndiaRegions.sikkim &&
          IndiaRegions.sikkimDistricts.contains(p.district)) {
        _districtChoice = p.district;
      } else {
        _districtText.text = p.district;
      }
      _agree = true;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _mobile.dispose();
    _districtText.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final district =
        _isSikkim ? (_districtChoice ?? '') : _districtText.text.trim();
    await profileStore.save(
      UserProfile(
        name: _name.text.trim(),
        mobile: _mobile.text.trim(),
        state: _state ?? '',
        district: district,
      ),
    );
    if (!mounted) return;
    if (_editing) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _editing ? AppBar(title: const Tr('Edit profile')) : null,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            children: [
              if (!_editing) ...[
                const LanguagePicker(),
                const SizedBox(height: 16),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(SarcColors.dark ? 24 : 0),
                    child: Image.asset(
                      AppConst.logoFull,
                      width: 170,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.satellite_alt,
                        size: 64,
                        color: SarcColors.navy,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Tr(
                  'Sign in',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: SarcColors.navy,
                  ),
                ),
                const SizedBox(height: 6),
                Tr(
                  'Tell us where you live so SARC can show information for '
                  'your area.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: SarcColors.textMuted, height: 1.4),
                ),
                const SizedBox(height: 24),
              ],
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Full name'.tr,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (v) => (v ?? '').trim().length < 2
                    ? 'Please enter your name'.tr
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _mobile,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  labelText: 'Mobile number'.tr,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  prefixText: '+91  ',
                ),
                validator: (v) => RegExp(r'^[6-9]\d{9}$').hasMatch((v ?? '').trim())
                    ? null
                    : 'Enter a valid 10-digit mobile number'.tr,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _state,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'State / Union Territory'.tr,
                  prefixIcon: const Icon(Icons.map_outlined),
                ),
                items: [
                  for (final s in IndiaRegions.states)
                    DropdownMenuItem(value: s, child: Text(s)),
                ],
                onChanged: (v) => setState(() {
                  _state = v;
                  _districtChoice = null;
                  _districtText.clear();
                }),
                validator: (v) =>
                    v == null ? 'Please select your state'.tr : null,
              ),
              const SizedBox(height: 14),
              if (_isSikkim)
                DropdownButtonFormField<String>(
                  key: const ValueKey('district-dropdown'),
                  value: _districtChoice,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'District'.tr,
                    prefixIcon: const Icon(Icons.location_city_outlined),
                  ),
                  items: [
                    for (final d in IndiaRegions.sikkimDistricts)
                      DropdownMenuItem(value: d, child: Text(d)),
                  ],
                  onChanged: (v) => setState(() => _districtChoice = v),
                  validator: (v) =>
                      v == null ? 'Please select your district'.tr : null,
                )
              else
                TextFormField(
                  key: const ValueKey('district-text'),
                  controller: _districtText,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'District'.tr,
                    prefixIcon: const Icon(Icons.location_city_outlined),
                  ),
                  validator: (v) => (v ?? '').trim().length < 2
                      ? 'Please enter your district'.tr
                      : null,
                ),
              const SizedBox(height: 14),
              if (!_editing)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _agree,
                  onChanged: (v) => setState(() => _agree = v ?? false),
                  title: const Tr(
                    'I understand that SARC stores these details on this '
                    'device and does not replace official warnings.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: (_saving || (!_editing && !_agree)) ? null : _submit,
                child: Tr(_editing ? 'Save changes' : 'Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
