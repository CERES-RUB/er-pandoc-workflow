# Entangled Religions typesetting

## Workflow

Der Workflow besteht aus drei Schritten:

1. Konvertierung eines DOCX-Dokuments in Markdown.
2. Bereinigung des Dokuments und redaktionelle Überarbeitung.
3. Konvertierung des Markdown-Dokuments in PDF (mittels LaTeX).

### Konvertierung DOCX → Markdown

Für jedes Dokument wird ein neues Verzeichnis unter `articles` angelegt, z.B. `articles/Autor_Kurztitel`. Hier wird die Docx-Datei gespeichert.

Die Konversion wird dann aus dem Hauptordner heraus über das Skript `convert.sh` angestoßen:

```bash
./convert.sh articles/Autor_Kurztitel/Autor_Kurztitel.docx
```

Wenn Ubuntu unter Windows verwendet wird, muss man vorher in den entsprechenden Ordner wechseln:

```bash
cd /mnt/c/Users/USERNAME/sciebo/ER_Workflow/
```

### Bereinigung

1. **Kopfdaten**  Jedem Markdown-Dokument muss ein Satz mit Kopfdaten vorangestellt werden. Ein Beispielsatz der erforderlichen Felder findet sich in der Datei `template/metadata.md`.
2. **Literaturverweise** Die Literaturverweise im Dokument werden durch Referenzen auf die Zotero-Datenbank ersetzt. *Noch ausarbeiten!*

Darüberhinaus sollte allgemein überprüft werden, ob die Formatierungen richtig übernommen wurden, und ggf. das Markdown mit den untenstehenden Funktionen angepasst werden.

## Markdown

ER nutzt [pandoc](http://pandoc.org/MANUAL.html) und dessen Markdown-Erweiterungen.

### Sprachen

Die Hauptsprache des Dokuments wird in den Metadatan über die Variable `lang` gesetzt, z.B.:

```yaml
lang: en
```

Weitere Sprachen können entweder für ganze Abschnitte oder für einzelne Segmente gesetzt werden, indem [Divs und Spans](http://pandoc.org/MANUAL.html#divs-and-spans) genutzt werden:

```markdown
::: {lang="de"}

Der Text ist deutsch.

:::

This is an English sentence with parts [auf Deutsch]{lang="de"}.
```

### Abbildungen und Tabellen

Abbildungen werden als „gleitende Objekte“ gesetzt, das heißt sie haben keinen festen Platz, sondern werden günstig (meist oben auf einer Seite) gesetzt. Im Text sollte daher immer über eine Nummer auf die Abbildung verwiesen werden. Dazu wird eine ID vergeben, die immer mit `fig:` anfängt:

```markdown
See figure @fig:afigure.

![A caption for the figure](figure1.tif){#fig:afigure}

```

Tabellen werden derzeit standardmäßig an der Stelle gesetzt, an der sie im Text erscheinen, nicht als gleitende Objekte.[^1] Dennoch sollte hier die Tabelle referenziert werden. Die Tabellenbeschriftung wird dabei in einer separaten Zeile mit dem Anfang `Table:` definiert. Hier haben die IDs immer das Präfix `tbl:`.

[^1]: Das sollte in Zukunft konfigurierbar sein.

```markdown
Table: Sample grid table. {#tbl:atable}

+---------------+---------------+--------------------+
| Fruit         | Price         | Advantages         |
+===============+===============+====================+
| Bananas       | $1.34         | - built-in wrapper |
|               |               | - bright color     |
+---------------+---------------+--------------------+
| Oranges       | $2.10         | - cures scurvy     |
|               |               | - tasty            |
+---------------+---------------+--------------------+
```

Falls die automatischen Spaltenbreiten kein gutes Ergebnis liefern, können sie explizit definiert werden. Hierfür werden für die Anzahl der Spalten Bruchteile definiert, die sich auf 1 addieren, also z.B.:

```markdown
Table: Sample grid table. {#tbl:atable colwidth=".3 .2 .5"}

+---------------+---------------+--------------------+
| Fruit         | Price         | Advantages         |
+===============+===============+====================+
| Bananas       | $1.34         | - built-in wrapper |
|               |               | - bright color     |
+---------------+---------------+--------------------+
| Oranges       | $2.10         | - cures scurvy     |
|               |               | - tasty            |
+---------------+---------------+--------------------+
```

### Absatzzählung

Die Absätze des Artikels werden automatisch nummeriert. Innerhalb von Listen gibt es eine Besonderheit: Kompakte Listen ohne Leerzeile zwischen Einträgen werden als ein einzelner Absatz gezählt, bei nicht-kompakten Listen wird jeder Eintrag als ein Absatz gezählt:

```markdown
Eine Absatznummer:

* Kompakte
* Liste

Zwei Absatznummern:

* Nicht-kompakte

* Liste
```

Sollen für einen Abschnitt die Absätze nicht nummeriert werden, so muss dieser in ein DIV mit der Klasse `noparnums` gefasst werden. Dies ist etwas sinnvoll für die Acknowledgements, eine Autorenbiographie o.ä.

```markdown
::: noparnums

# Acknowledgements

The author thanks …

:::
```

## Bibliographie

### Zotero

Die Literaturangaben aller Artikel werden in einer gemeinsamen Zotero-Bibliothek verwaltet. Um die Konsistenz zwischen verschiedenen Bearbeitenden sicherzustellen, wird zusätzlich das Plugin [Better BibTeX](https://retorque.re/zotero-better-bibtex/) verwendet.

In den Einstellungen unter *Bearbeiten → Einstellungen → Better BibTeX* wird folgendes Format für den Zitierschlüssel eingestellt: `[auth:lower]_[veryshorttitle:lower]_[year]`

Zitierschlüssel sollten für alle Einträge angepinnt werden (*Rechtsklick → Better BibTeX → BibTeX-Key anheften*).

