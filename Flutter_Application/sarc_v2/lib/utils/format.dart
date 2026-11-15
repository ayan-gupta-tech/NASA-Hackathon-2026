import '../core/i18n.dart';

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String formatDate(DateTime d) =>
    '${d.day} ${_months[d.month - 1].tr} ${d.year}';

String formatDateTime(DateTime d) {
  final h = d.hour.toString().padLeft(2, '0');
  final m = d.minute.toString().padLeft(2, '0');
  return '${formatDate(d)}, $h:$m';
}

String timeAgo(DateTime d) {
  final diff = DateTime.now().difference(d);
  if (diff.inMinutes < 1) return 'just now'.tr;
  if (diff.inMinutes < 60) return '${diff.inMinutes} ${'min ago'.tr}';
  if (diff.inHours < 24) return '${diff.inHours} ${'h ago'.tr}';
  if (diff.inDays < 7) return '${diff.inDays} ${'d ago'.tr}';
  return formatDate(d);
}
