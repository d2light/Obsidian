---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [IMPLEMENTATION_PLAN.md](file:///E:/DH/Sandbox/Dinopatch/docs/IMPLEMENTATION_PLAN.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# DinoPatch implementation plan

> Execution: implement inline with executing-plans; one independent review after checks.

Goal: expose the existing detector as `dinopatch` and remove train/test image overlap.
Architecture: reuse the local legacy core; setuptools package; one dataset preparation tool.
Tech stack: Python, PyTorch, NumPy, Pillow, OpenCV, scikit-learn, transformers.
Spec: [LIBRARY_DESIGN.md](file:///E:/DH/Sandbox/Dinopatch/docs/LIBRARY_DESIGN.md), amended by the user's approval of
`dinopatch` naming and non-overlapping data on 2026-09-28.

Constraints: preserve source archives and historical scores; modify only this workspace.
No extra framework, new GUI, benchmark retraining, or implicit checkpoint download in checks.

## Review focus

- Stored auto_bg state must produce identical scores/maps after reload.
- Empty/few-shot inputs and incompatible patch grids must give actionable errors.
- Duplicate images may have different names/encodings; compare decoded RGB as well as file bytes.
- Preserve test and pending-label images; quarantine corresponding training images and masks.
- Optional mask weights must not depend on another project's absolute path.

## Tasks

- [x] Write a small unittest check for package import, auto_bg round-trip, invalid input,
  missing GT, and duplicate preparation with renamed/re-encoded images; run and observe failure.
- [x] Copy core modules into `dinopatch/`, rename references, add `pyproject.toml` and
  repair serialization, input validation, and optional model paths. Re-run regression checks.
- [x] Implement `tools/prepare_datasets.py`: decoded RGB hash inventory, dry-run by default,
  `--apply` quarantines overlapping training images/masks under `migration/quarantine/`,
  writes a move journal and a fresh split inventory. Verify idempotence on a tiny temp dataset.
- [x] Apply to all four datasets; audit that no active train hash matches any test hash.
  Preserve test images; refresh counts and document archive-to-current path changes.
- [x] Build/install in a workspace-local environment; import outside the project directory;
  run offline cached DINOv2 fit/score/save/load compatibility probe. No performance claims.
- [x] Update usage/research docs and have an independent reviewer inspect final changes.

## Execution record

Ruling: This folder has no Git repository; work directly in the user-designated workspace.
No worktree or commit steps apply. Existing authorization covers implementation; no second
approval request for the already approved structure. Preserve checkpoints and prior measurements.
Ruling: Preserve test sets and quarantine overlapping training copies, including associated
train masks. Record original and quarantine paths so the migration inventory remains traceable.


## Completed validation

- Five unittest checks pass after reviewer regressions were reproduced and fixed.
- Public import and CLI work from outside the project through the local .venv.
- Offline cached DINOv2/CUDA probe: seven training images, one separate probe image,
  long_side=140 and coreset=32; score/map equality after save/load. Not a benchmark.
- Full decoded-RGB inventory: 296 overlapping training images and 296 corresponding
  masks quarantined; current train/test intersection is empty across all categories.
- All 21,131 imported files rehashed in active or relocated paths; all match provenance.
- Dist wheel contains dinopatch code only, without datasets or legacy adcore.
- Independent reviewer found shared-mask duplicate scheduling and two single-class/
  label-validation reporting defects. Added repro assertions, observed failures,
  fixed all three, and ran the complete five-check suite successfully.
- Scope rulings: near-duplicate scene detection, benchmark retraining, exhaustive optional
  backend validation, and old checkpoint compatibility remain outside this migration.
- Evidence: migration/current_validation.json and output/compatibility/result.json.
