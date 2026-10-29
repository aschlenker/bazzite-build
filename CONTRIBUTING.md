# Contributing

## Format

```bash
npx prettier --write *.md
shfmt -l -w build
```

## Check

```bash
shellcheck -x -s bash -o all build
```
