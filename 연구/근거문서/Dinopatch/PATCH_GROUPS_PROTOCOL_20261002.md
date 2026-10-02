---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [PATCH_GROUPS_PROTOCOL_20261002.md](file:///E:/DH/Sandbox/Dinopatch/docs/PATCH_GROUPS_PROTOCOL_20261002.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# Ordered patch groups: Cable development probe

Approved probe: compare independent patch matching with ordered 3x3 and 5x5
neighborhood matching, then test normal rotation/translation sensitivity.

- Same saved split as cable_relations_20260929_130732: FIT179 normal,
  CAL45 normal, original TEST150 (58 normal / 92 anomalous).
- Frozen DINOv2-with-registers-base, input392, normalized patch features.
- No NG reference images, optimizer, augmentation, SAM, VLM or registration.
- Sample128 centers per FIT image, then seed42 select12000 centers. Every
  center has a complete5x5 footprint. All branches use the same reference centers.
- Concatenate neighborhood features in row-major spatial order, L2 normalize,
  compare by exact cosine distance to one entire reference neighborhood.
  Matches may come from any position in any FIT image. No independent neighbor
  minima, graph training, position restriction or distance approximation.
- single/group3/group5 use identical query centers with a fully observed5x5
  footprint. single_full separately measures full-grid coverage using the same
  single-patch bank. This distinguishes scoring support from grouping effects.
- Query validity is inferred from RGB >2 in any channel, then conservative
  area downsampling and erosion. Synthetic transform metadata is not an input.
- Score: mean largest1% distances. CAL q95 higher. NG iff score > threshold.
- fusion3/fusion5: maximum of independently CAL-normalized single and group
  scores, then a further q95 calibration on the same CAL images. This is a
  development calibration rule, not a distribution-free false-alarm guarantee.
- Evaluate all150 originals and58 normal images under rotation15 degrees and
  translation(+5%,-4%). Transformed labels are unconfirmed; report source-label
  sensitivity. No transformed defect recall is claimed.
- The data and prior failures were already observed. No independent final
  generalization claim. Do not tune weights/thresholds on these results.

Use the existing local comparison artifact convention: source hashes and split,
source-code snapshots, full banks and center provenance, CAL scores, frozen
thresholds, per-image scores, numeric patch maps and matching indices, all266
image cards, distributions, HTML, replay validation and a file-hash manifest.
Maps represent whole-neighborhood discrepancies at their centers, not exact
defect pixels. Rightmost image highlights the nearest normal5x5 neighborhood
for the largest group5 distance. Original datasets and public API stay unchanged.

Runner: `.venv/Scripts/python.exe -m tools.experiment_patch_groups`
Tests: `.venv/Scripts/python.exe -m unittest tests.test_patch_groups`
