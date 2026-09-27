#!/usr/bin/env python3
"""A feliratok forrása a backend: tron-nelkul/backend/src/main/resources/i18n/<nyelv>/<névtér>.json.

Ez a szkript összefésüli őket az app tartalékába (assets/translations/<nyelv>.json). Az app ezt csak akkor
használja, ha az első indításkor nem éri el a szervert (utána a gyorsítótárat). Futtasd, ha a backend
feliratai változtak:  python3 tools/sync_translations.py
"""
import glob
import json
import os

here = os.path.dirname(os.path.abspath(__file__))
src = os.path.join(here, '../../tron-nelkul/backend/src/main/resources/i18n')
dst = os.path.join(here, '../assets/translations')
os.makedirs(dst, exist_ok=True)
for lang in sorted(os.listdir(src)):
    out = {}
    for f in sorted(glob.glob(os.path.join(src, lang, '*.json'))):
        with open(f, encoding='utf-8') as fh:
            out[os.path.basename(f)[:-5]] = json.load(fh)
    with open(os.path.join(dst, f'{lang}.json'), 'w', encoding='utf-8') as fh:
        json.dump(out, fh, ensure_ascii=False, indent=1, sort_keys=True)
        fh.write('\n')
    print(lang, len(out), 'névtér')
