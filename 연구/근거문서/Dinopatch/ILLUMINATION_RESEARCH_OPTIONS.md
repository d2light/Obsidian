---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [ILLUMINATION_RESEARCH_OPTIONS.md](file:///E:/DH/Sandbox/Dinopatch/docs/ILLUMINATION_RESEARCH_OPTIONS.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# Alternatives to photometric preprocessing

These are experiment proposals, not demonstrated improvements on waterseal.
Keep bright-only fitting and calibration separate from development validation;
reserve new acquisition periods for final evaluation. Do not optimize thresholds
on the already inspected dark OK/NG collection.

## Diagnose before choosing the intervention

For paired exposure changes of the same images, report individual score changes,
normal/defect group means, change dispersion, and the normal/defect score gap.
Similar means alone do not establish parallel shifts. Synthetic darkening cannot
reproduce sensor noise, saturation, defocus, moving reflections or ageing lights.
The current bright/dark real groups contain different samples and acquisition
conditions, so they cannot isolate a causal illumination effect.

## Priority 1: separate common score elevation from localized peaks

Using an independently defined object region, compare the existing top-k score
against top-k minus a robust typical patch score and a robust standardized score.
This tests the hypothesis that lighting elevates many patches while a defect
elevates a localized subset. An all-image median is not sufficient when background
dominates. A large defect can also elevate the median and be suppressed. Keep the
absolute score and an extraction/quality flag; calibrate every rule on normal
calibration images, not NG examples. No new backbone training is required.

## Priority 2: compare feature normalization and normal variation models

Try feature centering or a small adapter with paired-view consistency rather than
enumerating arbitrary transformed images in the memory bank. Preserve localized
defect sensitivity and check for feature collapse. Another comparator is a normal
feature distribution that accounts for directions with high normal variability;
it does not automatically model unseen lighting. Position-conditioned models need
reliable registration and must retain registration failures in the denominator.

PaDiM models normal patch embeddings using multivariate Gaussian distributions:
https://arxiv.org/abs/2011.08785
SimpleNet uses a shallow feature adapter and feature-space synthetic anomalies:
https://arxiv.org/abs/2303.15140
These papers motivate comparators; neither citation proves illumination robustness
for this dataset. AnomalyDINO is also a relevant vision-only baseline:
https://arxiv.org/abs/2405.14529

## Priority 3: reference-based photometric matching and separate shape evidence

After registration, estimate brightness differences from stable corresponding
normal regions using an outlier-resistant fit, then inspect the residual. A
damaged region must not determine the correction. Shape/edge evidence can be a
separate signal for tears and missing material; it will not cover all surface
defects. Keep a separate registration/extraction-failure outcome.

## Priority 4: slow drift monitoring with guarded recalibration

If actual production ordering and gradual drift are available, track brightness,
contrast and typical scores over time. Rare defects make robust statistics
plausible, not guaranteed safe. Preserve an immutable reference, bounded updates
and rollback; add only confirmed normal samples to the reference bank. Do not
silently label recent traffic normal or continually raise the threshold.

## Quality and acquisition are separate controls

Measure clipping, noise, contrast and visibility. Defer/reacquire when evidence
is insufficient rather than treating normalization or a VLM explanation as
recovered information. Evaluate false positives, missed defects, review rate,
processing time and retained defect-score separation together. Compare one
intervention at a time before combining effective ones.
