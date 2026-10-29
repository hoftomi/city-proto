#!/usr/bin/env python3
"""Translations are sourced from the backend: tron-nelkul/backend/src/main/resources/i18n/<lang>/<namespace>.json.

This script merges them into the app's fallback (assets/translations/<lang>.json). The app uses it only when
it cannot reach the server on first launch (afterwards it uses the cache). Run it whenever the backend
translations change:  python3 tools/sync_translations.py
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
    print(lang, len(out), 'namespaces')
