# NavBar

Bottom navigation on dark wood, with a bronze top border. Every tab gets a game icon. The selected tab's icon goes into a glowing, bronze-framed field, and its label turns bronze.

**What the caller provides:** `items` (`[{id, label, icon, art?, badge?}]`), `active`, `onChange`.

- The `icon` name is automatically mapped to a game icon: `terkep`, `varos`, `kem`, `pp`, `legit`.
