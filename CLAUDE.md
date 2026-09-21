# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

A minimal Express REST API (`/users`, `/health`) on Node 22 with an in-memory store and no database.

## Commands

```
npm run dev                                    # node --watch, http://localhost:3000
npm test                                       # node --test (built-in runner)
npm run lint                                   # eslint .
node --test tests/users.test.js                # a single file
node --test --test-name-pattern "returns 404"  # a single test
```

`make help` lists the Docker equivalents (`make up`, `make sh`, `make test`). CI runs lint and test on every push.

## Conventions

- Use CommonJS (`require` / `module.exports`), not ESM — there is no `"type": "module"` and ESLint parses `sourceType: "script"`.
- Read and write users through `db/store.js`, never by touching its array directly.
- Return errors as `res.status(code).json({ error: "..." })`, not plain text — 400 for missing fields, 404 for not found.
- Add no runtime dependencies beyond Express; put new data helpers in `db/store.js`.
- Read config from `process.env` with an inline default and document it in `.env.example`. Never read or commit `.env`.

## Architecture

- `server.js` builds and exports `app`, and calls `app.listen` only under `require.main === module` so tests can import it without binding a port. Keep that guard.
- `routes/` holds one router per resource, each mounted at its own prefix in `server.js`. A new resource is a new file plus one `app.use` line.
- `db/store.js` is the only data layer. Its state is module-level, so it persists across requests and is shared by every test in a run — don't assert on exact list length.
- `tests/` uses `node:test` and `node:assert` with supertest against the imported `app`.
