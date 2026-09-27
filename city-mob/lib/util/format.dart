/// Magyar formázás: tizedesvessző, valódi mínuszjel, nagykötőjel.
String num1(double v) => v.toStringAsFixed(1).replaceAll('.', ',');

String signed(int v) => v > 0 ? '+$v' : (v < 0 ? '−${-v}' : '±0');

/// Egész szám tizedes nélkül, különben egy tizedesjeggyel.
String numText(double v) => v == v.roundToDouble() ? v.round().toString() : num1(v);

/// Hatalmi ág (OrderView.branch) és városnegyed neve.
String branchName(String b) => switch (b) {
      'keresk' => 'Vásártér',
      'polit' => 'Városháza',
      'kem' => 'Alvilág',
      'kozos' => 'Közös',
      _ => b,
    };

/// A városnézet negyedei: Vásártér (Üzletek), Városháza (Parlament), Alvilág (kémhálózat).
String districtName(String d) => branchName(d);

String tinctureName(String t) => switch (t) {
      'voros' => 'Vörös',
      'kek' => 'Kék',
      'zold' => 'Zöld',
      'arany' => 'Arany',
      'bibor' => 'Bíbor',
      'fekete' => 'Fekete',
      'narancs' => 'Narancs',
      'szeder' => 'Szeder',
      _ => t,
    };

const _months = ['január', 'február', 'március', 'április', 'május', 'június', 'július', 'augusztus', 'szeptember', 'október', 'november', 'december'];
const _weekdays = ['hétfő', 'kedd', 'szerda', 'csütörtök', 'péntek', 'szombat', 'vasárnap'];

/// Helyi idő szerint (a szerver UTC-ben küldi az időpontokat).
String hhmm(DateTime t) {
  final d = t.toLocal();
  return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

String dateLong(DateTime t) {
  final d = t.toLocal();
  return '${_months[d.month - 1]} ${d.day}., ${_weekdays[d.weekday - 1]}, ${hhmm(d)}';
}

String relativeDays(DateTime t) {
  final d = t.toLocal();
  final now = DateTime.now();
  final days = DateTime(d.year, d.month, d.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  if (days <= 0) return 'ma ${hhmm(d)}';
  if (days == 1) return 'holnap';
  return '$days nap múlva';
}

/// Időtartam „1 ó 20 p” alakban (negatív időnél 0 p).
String durText(Duration d) {
  final m = (d.inSeconds / 60).ceil().clamp(0, 1000000);
  final h = m ~/ 60, mm = m % 60;
  return h > 0 ? (mm == 0 ? '$h ó' : '$h ó $mm p') : '$mm p';
}

/// Rövid dátum és idő: „09.27. 14:05”.
String shortDateTime(DateTime t) {
  final d = t.toLocal();
  return '${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}. ${hhmm(d)}';
}
