# Historical presentation resources

These self-contained source snapshots live under `archive/` to distinguish them
from the other talks. Original files are unchanged; ordinary merge commits retain
both repositories' full reachable Git histories, including original authorship.
Old commits and stage tags retain their original root-relative paths, not the
archive prefixes. This is preservation, not maintained or deployment-ready code.

## Web414: Backbone Twidget — June 14, 2012

- [Archived files](2012-06-14-web414-backbone-twidget/README.md)
- Source: https://github.com/Version2beta/backbone-twidget-presentation
- Imported `master`: `3a2f58435c52906e53598c429b28acf46bcb5265`.
- Presented by Rob Martin and Arlen Walker (`@Arlen`, GitHub `paladin`),
  as recorded in the original README.
- Original root files: `README.md`, `index.html`, `css/`, `js/`, `libs/`.
- Original tags `s1` through `s12` are available in this repository as
  `archive/backbone-twidget-presentation/s1` through
  `archive/backbone-twidget-presentation/s12`, pointing to the original commits.
  For example, inspect a stage without changing your checkout:
  `git show archive/backbone-twidget-presentation/s1:js/bbtwitter.js`.
  Fetch them with `git fetch origin 'refs/tags/archive/backbone-twidget-presentation/*:refs/tags/archive/backbone-twidget-presentation/*'`.
- Bundled Backbone, jQuery and Underscore and the legacy Twitter search JSONP
  endpoint are historical. Do not assume the demo or external links still work.

## SLC Python: IPython and pandas — 2014

- [Archived files](2014-slc-python-ipython-pandas/README.md)
- Source: https://github.com/Version2beta/ipython-pandas-explorer
- Imported `master`: `b56b1083ee28cbf59d9a2da6e2c8ab9b5cd979e5`.
- Original root files: `README.md`, `.gitignore`, `requirements.txt`,
  `busfinder.py`, `busfinder.ipynb`, `slc-pandas.ipynb`, `data/`.
- Original Rob Martin commits and Faris Chebib's Ubuntu guidance, including
  the SLCPython PR #1 merge, remain in Git history. No source tags existed.
- The original notebooks, revenue CSV, bus-finder example and dependency list
  are preserved. Python 2-era examples, old IPython/Ubuntu/pyzmq instructions,
  HTTP service endpoints and packages are historical, not current setup advice.
  No code, notebooks, dependency installations or external services were run
  or tested during import.

## Perhap shopping demo — 2017

- [Archived files and presentation notes](2017-perhap-shopping/README.md)
- Source: https://github.com/Version2beta/shopping-perhap
- Imported `master`: [`ebb9597ca3670439cc2e2134f40a6b65c032e586`](https://github.com/Version2beta/shopping-perhap/commit/ebb9597ca3670439cc2e2134f40a6b65c032e586)
  (September 5, 2017; this is the source commit date, not a verified talk date).
- Rob Martin's presentation notes demonstrate a Perhap shopping-cart reducer
  using IEx and localhost HTTP requests. Original BSD 3-Clause attribution and
  license are retained in [LICENSE](2017-perhap-shopping/LICENSE).
- All original root files, including `lib/`, `config/`, `test/`, `mix.exs` and
  `mix.lock`, are unchanged under `2017-perhap-shopping/`. All three original
  commits and their merge topology remain reachable through the import merge;
  historical commits retain root-relative paths. No source tags existed.
- Elixir 1.5-era code, the machine-local Perhap dependency path and legacy
  dependencies are historical, not current setup advice. No code, installs or
  services were run. This snapshot does not replace or modify current Perhap.

The source repositories remain intact; importing these materials does not
retire or delete them. Existing source URLs and historical README wording are
kept for provenance, even where links or stage instructions refer to the old
repository layout.
