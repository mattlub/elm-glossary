# glossary-UI-elm

An example UI for a glossary of web development tehnical terms, featuring live search and keyboard control, created with elm.

### Why?
Often technical terms, in English, are hard to learn and remember for beginners or students who do not speak English as their first language. A glossary of key terms with simple definitions (and translations) would be useful for students.

### Local install instructions
Requires elm.
```bash
npm i -g elm
```

```bash
# install the elm packages
elm-package install
```

Use elm-live to run a live-updating development server.
```bash
npm i -g elm-live
```

```bash
# run the live server
elm-live --output=app.js
```

### enhancements
Currently this is just a prototype UI with static data. There are many potential enhancements/different options for solutions. For example:
- ability to add new words/request new words are added
- ability to add new translations/languages
- ability to rate translations
- make a chrome extension version

If anyone would like to work on an enhanced version of this please get in touch!