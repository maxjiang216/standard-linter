# Releasing

## Tag policy

- **Stable line for consumers:** a moving major tag, for example `v1`, should point to the latest compatible release of that line.
- **Immutability for audits:** also create a concrete tag for each cut, e.g. `v1.0.0`, `v1.1.0`, that is never force-pushed.

## Steps to publish a new release

1. Ensure the default branch passes CI and any local `pre-commit` checks you use.
2. Update this document or `README.md` if behavior or file layout changes.
3. Create an annotated tag:

   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0: initial tool matrix and configs"
   git tag -f v1
   git push origin v1.0.0
   git push -f origin v1
   ```

   (Using `-f` on `v1` is only appropriate if your policy allows the major pointer to move to the latest minor.)

4. In consumer repositories, reference either:
   - `uses: your-org/code-standards/.github/workflows/standards.yml@v1.0.0` for a fixed snapshot, or
   - `uses: .../standards.yml@v1` to track non-breaking changes within a major.

## When to move to v2

Create `v2` if any of the following are true and would break existing consumers:

- Renaming or moving config files under `configs/`
- Changing the `workflow_call` input names in `.github/workflows/standards.yml`
- Removing a tool that consumers already rely on, or making failure modes stricter in a way that is not plausibly a bugfix

## Machine-readable inventory

- Config files live under `configs/`
- The reusable entrypoint is `.github/workflows/standards.yml`
- The consumer-facing bootstrap lives in `scripts/bootstrap.sh` and `scripts/download-configs.sh`
