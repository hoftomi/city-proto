/// Magyar formázás: tizedesvessző, valódi mínuszjel, nagykötőjel.
String num1(double v) => v.toStringAsFixed(1).replaceAll('.', ',');

String signed(int v) => v > 0 ? '+$v' : (v < 0 ? '−${-v}' : '±0');

String factionName(String f) => switch (f) {
      'nemesseg' => 'Nemesség',
      'kereskedok' => 'Kereskedők',
      'katonasag' => 'Katonaság',
      _ => f,
    };

String districtName(String f) => switch (f) {
      'nemesseg' => 'Felsőváros',
      'kereskedok' => 'Vásártér',
      'katonasag' => 'Citadella',
      _ => f,
    };

String levelName(String? l) => switch (l) {
      'jelenlet' => 'Jelenlét',
      'partner' => 'Helyi partner',
      'dominans' => 'Domináns',
      'varoskontroll' => 'Városkontroll',
      'protektoratus' => 'Protektorátus',
      _ => 'Nincs jelenlét',
    };

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

String hhmm(DateTime d) => '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

String dateLong(DateTime d) => '${_months[d.month - 1]} ${d.day}., ${_weekdays[d.weekday - 1]}, ${hhmm(d)}';

String relativeDays(DateTime d) {
  final now = DateTime.now();
  final days = DateTime(d.year, d.month, d.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  if (days <= 0) return 'ma ${hhmm(d)}';
  if (days == 1) return 'holnap';
  return '$days nap múlva';
}

String remaining(DateTime target) {
  final m = target.difference(DateTime.now()).inMinutes.clamp(0, 100000);
  final h = m ~/ 60, mm = m % 60;
  return h > 0 ? '$h ó $mm p' : '$mm p';
}
