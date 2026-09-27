import 'package:easy_localization/easy_localization.dart';

/// Magyar formázás: tizedesvessző, valódi mínuszjel, nagykötőjel.
String num1(double v) => v.toStringAsFixed(1).replaceAll('.', ',');

String signed(int v) => v > 0 ? '+$v' : (v < 0 ? '−${-v}' : '±0');

/// Egész szám tizedes nélkül, különben egy tizedesjeggyel.
String numText(double v) => v == v.roundToDouble() ? v.round().toString() : num1(v);

/// Hatalmi ág (OrderView.branch) és városnegyed neve.
String branchName(String b) => const {'keresk', 'polit', 'kem', 'kozos'}.contains(b) ? 'format.branch.$b'.tr() : b;

/// A városnézet negyedei: Vásártér (Üzletek), Városháza (Parlament), Alvilág (kémhálózat).
String districtName(String d) => branchName(d);

const _tinctures = {'voros', 'kek', 'zold', 'arany', 'bibor', 'fekete', 'narancs', 'szeder'};

String tinctureName(String t) => _tinctures.contains(t) ? 'format.tincture.$t'.tr() : t;

/// Helyi idő szerint (a szerver UTC-ben küldi az időpontokat).
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

/// Időtartam „1 ó 20 p” alakban (negatív időnél 0 p).
String durText(Duration d) {
  final m = (d.inSeconds / 60).ceil().clamp(0, 1000000);
  final h = m ~/ 60, mm = m % 60;
  if (h == 0) return 'format.dur_m'.tr(namedArgs: {'m': '$mm'});
  return mm == 0 ? 'format.dur_h'.tr(namedArgs: {'h': '$h'}) : 'format.dur_hm'.tr(namedArgs: {'h': '$h', 'm': '$mm'});
}

/// Rövid dátum és idő: „09.27. 14:05”.
String shortDateTime(DateTime t) {
  final d = t.toLocal();
  return '${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}. ${hhmm(d)}';
}
