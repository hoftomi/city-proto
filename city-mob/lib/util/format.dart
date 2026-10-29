import 'package:easy_localization/easy_localization.dart';

/// Hungarian formatting: decimal comma, real minus sign, en dash.
String num1(double v) => v.toStringAsFixed(1).replaceAll('.', ',');

String signed(int v) => v > 0 ? '+$v' : (v < 0 ? '−${-v}' : '±0');

/// Integer without decimals, otherwise with one decimal place.
String numText(double v) => v == v.roundToDouble() ? v.round().toString() : num1(v);

/// Name of a power branch (OrderView.branch) and city district.
String branchName(String b) => const {'trade', 'politics', 'espionage', 'common'}.contains(b) ? 'format.branch.$b'.tr() : b;

/// The city view's districts: Marketplace (shops), Town Hall (parliament), Underworld (spy network).
String districtName(String d) => branchName(d);

/// In local time (the server sends timestamps in UTC).
String hhmm(DateTime t) {
  final d = t.toLocal();
  return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

String dateLong(DateTime t) {
  final d = t.toLocal();
  return 'format.date_long'.tr(namedArgs: {'month': 'format.month.${d.month}'.tr(), 'day': '${d.day}', 'weekday': 'format.weekday.${d.weekday}'.tr(), 'time': hhmm(d)});
}

String relativeDays(DateTime t) {
  final d = t.toLocal();
  final now = DateTime.now();
  final days = DateTime(d.year, d.month, d.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  if (days <= 0) return 'format.today_at'.tr(namedArgs: {'time': hhmm(d)});
  if (days == 1) return 'format.tomorrow'.tr();
  return 'format.in_days'.tr(namedArgs: {'days': '$days'});
}

/// Duration as „1 ó 20 p” (0 p for negative time).
String durText(Duration d) {
  final m = (d.inSeconds / 60).ceil().clamp(0, 1000000);
  final h = m ~/ 60, mm = m % 60;
  if (h == 0) return 'format.dur_m'.tr(namedArgs: {'m': '$mm'});
  return mm == 0 ? 'format.dur_h'.tr(namedArgs: {'h': '$h'}) : 'format.dur_hm'.tr(namedArgs: {'h': '$h', 'm': '$mm'});
}

/// Short date and time: „09.27. 14:05”.
String shortDateTime(DateTime t) {
  final d = t.toLocal();
  return '${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}. ${hhmm(d)}';
}
