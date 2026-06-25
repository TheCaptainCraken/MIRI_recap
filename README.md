# Notes Template

A [Typst](https://typst.app) template for typesetting polished class notes: covers, chapters, theorem-like environments, callouts, booktabs tables, themed plots, a bibliography, and a cohesive palette and font set, all behind a single `#import "utils.typ": *`.

## Learn the template

`main.typ` is the **field guide**. It documents every utility twice: once as a copy-paste snippet, once rendered right below it. Reading it (in source and rendered side by side) is how you learn what the template can do.

Two ways to read it:

- **Grab the latest PDF.** Every push to `main` builds the guide and publishes it to the [Releases](../../releases) page. Download the newest `main.pdf` and read it — no toolchain required.
- **Compile it yourself.** Install [Typst](https://github.com/typst/typst), then:

  ```bash
  typst compile main.typ --font-path fonts   # → main.pdf
  typst watch main.typ --font-path fonts      # live preview while reading
  ```

## Start your own notes

Once you know your way around, `main.typ` is just an example — replace it with your own writing.

1. **Get the template.** This repo is a GitHub template, so click **Use this template → Create a new repository**. Or clone it and point it at a fresh remote:

   ```bash
   git clone https://github.com/TheCaptainCraken/notes_template.git my-notes
   cd my-notes
   rm -rf .git && git init            # start your own history
   git remote add origin git@github.com:<you>/my-notes.git
   ```

2. **Make `main.typ` yours.** Either rename the guide out of the way and write a fresh file, or empty it and start typing:

   ```bash
   mv main.typ guide.typ              # keep the guide around for reference
   # ...then write a new main.typ, starting from the skeleton below
   ```

   Delete `guide.typ` whenever you no longer need the reference. A minimal `main.typ`:

   ```typ
   #import "utils.typ": *

   #cover(title: [My Notes], author: [Your Name])
   #show: book
   #toc()

   = First Chapter
   #lettrine[Your notes start here...]
   ```

3. **Enable the PDF release workflow.** The included Action (`.github/workflows/build-pdf.yml`) compiles `main.typ` with the bundled fonts and publishes `main.pdf` to **Releases** on every push to `main`. It needs write access once:

   - **Settings → Actions → General → Workflow permissions → Read and write permissions.**

   No secrets to configure — it uses the automatic `GITHUB_TOKEN`.

4. **Push.**

   ```bash
   git add -A
   git commit -m "Start my notes"
   git push -u origin main
   ```

   Each push builds the PDF and creates a dated release. Grab the latest from the **Releases** page any time.

## What's in the box

| File / dir | Purpose |
| --- | --- |
| `main.typ` | The field guide: replace with your own notes. |
| `utils.typ` | The barrel import; re-exports everything from `utils/`. |
| `utils/` | The template internals (cover, environments, plots, theme). |
| `themes/` | Palette and font definitions. |
| `fonts/` | Bundled fonts, passed via `--font-path fonts`. |
| `references.bib` | Example bibliography for `#references(..)`. |
| `.github/workflows/build-pdf.yml` | Builds and releases `main.pdf` on every push. |

For the full list of utilities and how to use each one, read the guide (`main.typ` / the released `main.pdf`).
