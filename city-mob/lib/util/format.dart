import 'package:easy_localization/easy_localization.dart';

/// Hungarian formatting: decimal comma, real minus sign, en dash.
String num1(double v) => v.toStringAsFixed(1).replaceAll('.', ',');

String signed(int v) => v > 0 ? '+$v' : (v < 0 ? '−${-v}' : '±0');

/// Money as a coin string with unit markers, from whole bronze (1 gold = 10 silver = 100 bronze).
/// Only the non-zero denominations, biggest first: 435 → „4 [gold] 3 [silver] 5 [bronze]”,
/// 400 → „4 [gold]”, 35 → „3 [silver] 5 [bronze]”, 0 → „0 [gold]”. Negative amounts get a leading „−”;
/// with [signed], non-negative amounts get a leading „+” („+0 [gold]”).
String coinText(int bronze, {bool signed = false}) {
  final abs = bronze.abs();
  final gold = abs ~/ 100, silver = abs % 100 ~/ 10, rest = abs % 10;
  final parts = [
    if (gold > 0) '$gold [gold]',
    if (silver > 0) '$silver [silver]',
    if (rest > 0) '$rest [bronze]',
  ];
  final body = parts.isEmpty ? '0 [gold]' : parts.join(' ');
  if (bronze < 0) return '−$body';
  return signed ? '+$body' : body;
}

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
