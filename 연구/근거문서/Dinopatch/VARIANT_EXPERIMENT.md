---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [VARIANT_EXPERIMENT.md](file:///E:/DH/Sandbox/Dinopatch/docs/VARIANT_EXPERIMENT.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# DINOv2 variant pilot — 2026-09-28

User authorized the proposed baseline / photo_aug=2 / long_side=980 comparison.
First stage: industrial bolt and water_seal, six runs. MVTec/VisA expansion and
new boundary/ROI algorithms are outside this initial pilot.

## Fixed protocol

- Same cleaned dataset, seed 42, DINOv2 register-base, coreset 30,000,
  align=auto, mask=auto_bg, existing top-k rule.
- Variants: baseline (700, aug0), photo_aug2 (700, aug2), resolution980 (980, aug0).
- Reserve 20% (rounded up) of each normal training pool for threshold calibration.
  Shuffle deterministically once; reuse exactly the same partition for all variants.
- From each existing test label, allocate half (rounded down) for development
  validation. The other half remains a final holdout and receives no model scores.
  head_defect remains unlabeled/excluded. Exact decoded-image hashes must be disjoint
  between training, calibration, development validation and final holdout.
- Threshold: calibration-normal empirical 95th percentile, higher interpolation.
  Target FPR is approximately 5% on calibration, not a guarantee on new images.
  No thresholds or k selected from the development NG labels.
- Report image AUROC, actual validation FPR/recall/confusion, pixel AUROC and
  AU-PRO@30% FPR, fit time and synchronized per-image inference time.
- Raw maps: float32, original image dimensions and coordinates. Reverse automatic
  alignment when needed. Visual overlays are display-normalized only.
- Localization metric grid: aspect-preserving long side 256 for every variant;
  nearest-neighbor GT, bilinear score resizing. Record if a GT region disappears.
- Comparisons are exploratory single-seed results, not a final independent benchmark
  or directly comparable to older full-test measurements. Scene-near-duplicates
  are not ruled out by exact image hashing.

## Artifact adapter

No shared ExperimentArtifacts writer exists in this standalone workspace.
Add a small local adapter in tools/experiment_artifacts.py with create()/finish(),
using the model-experiment-artifacts folder convention. Each successful run contains
split/source hashes, all bank-training originals (masters), calibration/validation
originals, actual checkpoint, calibration and prediction CSVs, raw maps/overlays,
metrics/outcome lists, plots and a searchable relative-link HTML report.
Final-holdout originals remain in datasets; only their provenance is recorded.
Loss/optimizer/MLflow/export statuses explicitly indicate not applicable or not run.

## Execution plan

- [x] Add small runnable checks for deterministic split, fixed calibration threshold,
  perfect/reversed localization metrics and artifact validation corruption detection.
- [x] Implement the local artifact writer, validator CLI and sequential comparison
  runner without changing the detector's algorithm.
- [x] Run the six GPU experiments with cached weights, recording failures explicitly.
- [x] Independently validate every successful run, inspect representative maps, create
  a comparison report, and report which changes helped and their practical limits.

Ruling: Implement within the existing user workspace; no Git repository is present.
Ruling: This is the explicitly authorized comparison, not a new approval stage.

## Execution notes

- Normal feature extraction now streams images and photometric variants, retaining
  CPU feature grids rather than every full-resolution augmented PIL and CUDA grid.
  Feature order, RNG calls and values match the previous materialized path exactly
  in a runnable regression check. Auto-background calibration explicitly transfers
  its queries to the bank device. No scoring or bank-selection rule changed.
- The initial bolt baseline at `DinoPatch_20260928_160958_bolt_baseline_full_ls700`
  is a preliminary run before this memory change. It remains preserved but is excluded
  from the final six-run comparison. The repeated baseline has identical scores and
  localization metrics and uses the same detector code as the other five runs.
- Fixed counts: bolt fit151/calibration38/validation107/holdout108;
  water_seal fit355/calibration89/validation142/holdout142.
- Validation contains bolt 100 OK + 7 NG; water_seal 130 OK + 12 NG.
  Native GT components: bolt27, water_seal14; none disappear at the metric grid.
- Individual experiment reports are verified for file hashes, image provenance,
  split separation, prediction identities, calibration threshold, recomputed image
  and localization metrics, outcome lists, checkpoint provenance and HTML assets.
- All six completed successfully. No detector default was changed after inspecting
  validation outcomes. See [results](file:///E:/DH/Sandbox/Dinopatch/docs/VARIANT_RESULTS.md) and the linked comparison.
- After observing slow native-map writes, the final two water_seal runs used lossless
  ZIP compression level 1 instead of NumPy's default level 6. Decoded float32 values
  are identical; compression/report time is outside the reported inference timing.
