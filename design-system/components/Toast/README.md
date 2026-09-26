# Toast

Rövid visszajelzés egy akció vagy feldolgozás után, négy hangnemben.

**Mit ad a hívó:** `tone` (`info` | `ok` | `warn` | `danger`), `title`, `children`, opcionálisan `icon`.

- A cím azt mondja meg, mi történt („Lebuktál Feketerévben”), a törzs pedig a következményt és a teendőt.
- A `danger` hangnem `role="alert"`, a többi `status`.
