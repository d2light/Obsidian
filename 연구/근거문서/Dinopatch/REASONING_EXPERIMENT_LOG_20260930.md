---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [REASONING_EXPERIMENT_LOG_20260930.md](file:///E:/DH/Sandbox/Dinopatch/docs/REASONING_EXPERIMENT_LOG_20260930.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# Reasoning inspection execution log

## 2026-10-02 ordered patch groups

User approved comparing normal-only ordered3x3/5x5 patch groups. Completed
`patch_groups_20261002_094823`: original150 plus116 normal transform probes.
Common-support single FP0/FN17/swap0;5x5 FP2/FN10/swap5; single+5x5
FP2/FN9/swap4. Normal rotation15deg FP rose0→23/58 for5x5. This supports
local configuration sensitivity but not rotation robustness. No production
change, original-data mutation, NG fitting, SAM or VLM. Report and explicit
limitations: `docs/PATCH_GROUPS_RESULTS_20261002.md`.120 tests and independent
artifact/threshold/fusion/HTTP audit passed.

## Authorized scope

2026-09-30 user approved the written architecture and requested experiments and continuous records during approximately seven hours of absence. Routine implementation/experiment choices proceed autonomously. No external paid API calls, original-data mutations, or unsupported 100% claims.

## Session start

- Design: `REASONING_INSPECTION_DESIGN_20260930.md`.
- Plan: `superpowers/plans/2026-09-30-reasoning-inspection-experiments.md`.
- Existing SAM: 174/179 normal images have three selected parts, 22/24 synthetic rotations retain three; not classification metrics.
- Hardware: RTX 5080 16GB; cached DINO and local Qwen VLM available through prior code.
- Ruling: execute inline using new tools and fresh timestamped run directories — repository root is not a Git checkout; existing production library remains untouched.
- Ruling: establish a classical geometry control before a learned matcher — this separates correspondence failure from anomaly-feature failure and needs no new dependency. Failure is retained as REVIEW; DINO matching remains a next candidate, not assumed solved.
- Ruling: preserve original brightness/color evidence while testing scalar correction — per-channel fitting could conceal cable color replacement.
- Ruling: full new-data train/test splits follow source-group/type auditing; preserve unsplit IV/bolt copies meanwhile.

## Progress

Implementation starting. This file and timestamped run `status.json`/`progress.json` are the continuation record.

## 2026-10-01 00:06 — first geometry and pilot audit

- Primitive tests: 5 pass; feature/metrics/map/split tests: 5 pass after review fixes.
- SIFT-only normal FIT audit: 39/179 pass correspondence gates; report `output/comparisons/reasoning_geometry_fit_20260930`.
- Initial visual run `reasoning_visual_20261001_000325` completed fit/calibration but **evaluated zero images because code selected role=test while canonical role is validation**. Do not cite it as evaluation. Banks and fit/calibration audit remain useful diagnostic records; original output preserved.
- Independent review also found interpolation across unknown map patches. Fixed by requiring complete linear-interpolation validity, tested at the boundary.
- Pilot fit: raw179 / pose32 / photo32, pose calibration8, below preset minimum10. No pose thresholds manufactured.
- Ruling: dense correspondence gate revised on FIT diagnostics only from 30% /12 inliers to 20% /24 inliers, retaining spatial support and scale constraints — 138 FIT cases failed ratio although some had 35–47 distributed correspondences. This is a development hypothesis, not evidence that the resulting poses are correct. Known-transform controls and failure visualizations must check it. No evaluation predictions existed when choosing the revision.
- Added canonical nonempty evaluation guard, snapshot of feature extractor, and inference autocast metadata. New run required; previous results not overwritten.

## 2026-10-01 — corrected pilot completed

- `output/comparisons/reasoning_visual_20261001_000548`: 179 fit /45 calibration; 18 evaluation originals (2 per category, only2 normal) ×5 conditions ×3 branches =270 rows. All maps/scores and source hashes verified.
- Accepted fit: raw179 / pose93 / photo93. This training-coverage difference is a confound, not an equal-effective-fit ablation.
- Original: raw detects13/16 NG, misses3; pose/photo detect7, miss3 and REVIEW8 of18. Combined dark+pose: raw detects15/16 NG with1/2 normal flagged; pose/photo REVIEW18/18.
- Conclusion: no evidence that current single-reference correspondence improves the detector. Zero false accepts under full REVIEW is not success.
- Launch unchanged-parameter all150-source benchmark to measure normal behavior with adequate normal counts; launch SAM graph/color multiset probe on pilot cases.
- Ruling: graph first comparison is geometry-invariant plus color multiset. It can expose color replacement/duplication, but not a pure positional swap with unchanged color set. This deliberate restricted probe does not fulfill orientation-sensitive graph reasoning yet; report that limit explicitly.

## 2026-10-01 00:21 — full visual results and follow-on controls

- Full visual `reasoning_visual_20261001_000825`: 150 originals (58 OK/92 NG) ×5 conditions ×3 branches =2,250 rows. Source, score/map and checkpoint validations passed.
- Original raw: FP1/FN14/TP78/REVIEW0. Original photo: FP0/FN9/TP48/REVIEW61.
- Combined raw: FP46/FN4/TP88/REVIEW0. Combined photo: FP0/FN1/TP7/REVIEW132. Low automatic FP from the corrected branch is mostly lack of coverage, not successful robust inspection.
- Pose consistency audit `reasoning_pose_audit_20261001_002027`: among36 rotation pairs with both poses accepted,29 have >30px inconsistency. Diagnostic cutoff only; accepted correspondence is not reliable enough.
- Structural pilot `reasoning_structure_20261001_000809`: both cable-swap sources flagged across all5 conditions; outer-jacket defects remain invisible to the internal graph as expected. Full750-case structural run launched `reasoning_structure_20261001_002019`.
- Pilot fusion `reasoning_fusion_20261001_001523`: raw+composition original detects15/16 NG (raw13/16), FP0/2. Combined detects16/16 but FP1/2. Small developer-selected set; no final accuracy claim.
- Semantic graph extension `reasoning_relations_20261001_001931`: fit173/cal45; color identity is used for graph chirality only, never pose selection. Unit tests show rigid-rotation invariance and two-color-swap chirality change; duplicated colors remain ambiguous. Real evaluation report retained.
- First local VLM `reasoning_vlm_20261001_001408` frequently emits 0..1000 boxes despite requested0..1 and numeric evidence IDs. Strict parser marks invalid outputs REVIEW; raw text retained. Some statements falsely say the reference lacks blue insulation. Do not confuse schema errors with calibrated uncertainty or trust its explanations.
- New VLM protocol `reasoning_vlm_20261001_002045` explicitly requests0..1000 boxes and one short sentence; no retroactive reinterpretation of previous outputs. Extra JSON fields cannot overwrite experiment metadata (regression test added).
- Industrial cohort audit: camera1 full-resolution bolt has2699 OK/5 NG; other NG are different cameras/conditions. Cropped OK pair retained separately. No random pooled field split created.
- Ruling: add normal-only moderate augmentation as a control before escalating architectures. Test composite transformation already exposed failure, so subsequent scores remain exploratory; fit/calibration only determine new thresholds.
- Ruling: acquire official Qwen3-VL-4B-Instruct weights for a same-input capacity comparison after 2B protocol checks. No paid API or source-image upload. Reference https://huggingface.co/Qwen/Qwen3-VL-4B-Instruct.

## 2026-10-01 00:33 — correspondence alternatives and recoverable execution

- Augmentation run `reasoning_augmentation_20261001_002345` interrupted after423 saved cases on `PermissionError WinError5` during atomic progress replacement. A native Windows held-reader reproduction produced the same error; replacing succeeded immediately after closing the reader. Exact originating reader is not proven.
- Shared `write_json` now retries temporary PermissionError up to8 attempts (0.025..0.175s waits), propagates permanent errors and preserves the old file. Both cases tested RED→GREEN. Resume validates source/model revision, thresholds, saved row provenance and complete per-case modes before continuing. Resume log preserves initial code snapshot and adds continuation/IO snapshots.
- Geometry-only cached SAM pose `reasoning_visual_sam_20261001_002826` has too few accepted calibration cases to set pose/photo thresholds; all such verdicts remain REVIEW. Do not relax uncertainty gates silently.
- Ruling / explicit design alternative: add `validated_color_identity` as a SEPARATE experimental pose mode. Initial spec disallowed color-led pose because it can hide composition errors; here FIT-derived color cost and uniqueness margin must pass before single global orientation-preserving registration. Duplicate/replaced colors stay unresolved and composition evidence remains independent. Two-color mirror-order swaps are checked by relation chirality. This exception does not prove safety or replace the geometry-only baseline. Cyclic color permutation equivalent to allowed physical rotation remains unidentifiable without an external orientation cue.
- Semantic-anchor pilot `reasoning_visual_sam_20261001_003247` running. Reuses the original raw bank exactly so raw baseline remains comparable. No per-part warp and no anomaly-score-minimizing pose selection.
- Qwen4B weights cached at revision `ebb281ec70b05090aa6165b016eac8ec08e71b17` for subsequent local comparison; not yet a completed model result.

## 2026-10-01 00:40 — augmentation completed, semantic pose and VLM capacity checks

- Augmentation `reasoning_augmentation_20261001_002345` completed all750 cases /1,500 threshold-rule rows, checkpoint/map/source validations passed after documented resume. Original-calibration threshold: original FP0/FN13/TP79; combined FP2/FN14/TP78. Robust-calibration threshold: original and combined FP0/FN17/TP75. Normal denominator58, NG92, REVIEW0 throughout. Raw combined FP46/TP88: augmentation reduces false alarms but also those additional detections. Matching original-baseline TP78 does not imply identical detected defects.
- Added regression for unknown map/score replay; 32 reasoning unit tests pass. Existing completed run had no unknown scores, so its validation was unaffected.
- Semantic SAM pose pilot `reasoning_visual_sam_20261001_003247`: original photo TP4/FN0/REVIEW12 of18; combined TP2/FN0/REVIEW15. Too few resolved defects to claim strong detection. Paired pose audit `reasoning_pose_audit_20261001_003748`: mean rotation discrepancy2.54px among6/18 accepted pairs; combined0.73px among3/18. Much improved conditional consistency, low coverage remains central limitation.
- Revised2B VLM `reasoning_vlm_20261001_002045`: image-only all36 OK, missing32 source-NG instances. Measured original TP7/FN9; combined TP4/FN3/REVIEW10, all10 reviews are schema failures. A concise output format alone did not solve visual inspection.
- 4B launch `reasoning_vlm_20261001_003752` failed before inference because a commit-pinned download has no cached main reference. Fixed by passing the exact downloaded revision to processor/model. Fresh run `reasoning_vlm_20261001_003813` running. No prior results rewritten.
- Fusion now accepts the normal-augmented bank's calibration schema. Joint threshold is still calibrated on original normal images only; joint recalibration may cancel differences between its two starting thresholds. Added focused calibration regression. Full structure remains running; no conclusions from partial rows.

## 2026-10-01 — field baseline protocol fixed before scoring

- Reuse the existing public `Config → fit → score → save/load` implementation and standard `ExperimentArtifacts` writer for two separate field baselines: DINOv2 long-side392, greedy coreset3000, no alignment/background removal, normal calibration maximum×1.2. This is not the same scoring/bank protocol as the cable research experiment; compare within each dataset only. Original acquisitions remain untouched.
- Whole capture-minute groups unioned with exact RGB duplicate groups stay together. Boundary-near products/session correlation are not ruled out. Earliest normal groups totaling at least200 images fit, next at least100 calibration; remainder validation. No defect scores used to choose groups or threshold.
- Bolt camera1 full-resolution cohort:2699 OK/5 NG. Other cameras, unknown camera and cropped OK remain excluded with reasons. Pilot preparation `industrial_split_bolt_cam1_20261001_004329` initially missed three renamed NG files because of a startswith filter; corrected to camera-token search BEFORE training and old split marked superseded. Filename OK tokens never override user folder labels.
- IV audit:1981 unique pixel hashes,120 capture-minute groups, only2 pure-normal groups. Initial pure-group split failed before training. Revised IV protocol assigns chronological groups first; only their OK images enter fit/calibration, their NG are explicitly excluded/unscored and never shifted into validation. Later groups provide both OK/NG validation. This preserves group separation while disclosing unavailable NG counts.
- Group/duplicate/NG-exclusion regression tests pass. Independent review of prior fusion/semantic-pose/VLM changes found no new major defect;16 focused tests rerun by reviewer passed.
- Interim comparison report `reasoning_report_20261001_004104` includes full750-case raw/augmentation curves, distributions, per-defect counts and paired failure cards. Structure/VLM results will be linked in a fresh final report after completion.

## 2026-10-01 00:48 — completed 4B comparison and field training

- Qwen3-VL-4B `reasoning_vlm_20261001_003813` completed72 paired responses. Image-only original TP8/FN8, combined TP7/FN9, normal FP0/2 in both. Measured-evidence original TP12/FN4; combined TP8/FN1/REVIEW7 (one schema error, six explicit REVIEW). Sample16NG/2OK per condition, not full benchmark. Independent image-only judgment remains unreliable.
- Visual audit of response24 (`cut_inner_insulation/000`, original): visible split/cut in lower-right insulation was described as no visible defects. Store this as a concrete hallucination/miss example. No VLM decision overrides numerical inspection.
- Fresh intermediate report `reasoning_report_20261001_004755` draws validated VLM box hypotheses on query images and retains failed/no-box cases. Boxes are not verified defect masks.
- Corrected bolt split `industrial_split_bolt_cam1_20261001_004557`: fit275OK/cal152OK/validation2272OK+5NG, excluded14 other-camera/resolution files. Previous2NG split never trained.
- IV field run `output/experiments/DinoPatch_20261001_004646_iv_ring_normal_baseline_full_ls392`: fit200OK/cal100OK/validation691OK+690NG, excluded196 fit-groupNG+104 calibration-groupNG. Standard writer/model API, original data unchanged.
- Bolt field run `output/experiments/DinoPatch_20261001_004719_bolt_cam1_normal_baseline_full_ls392` launched. Both field runs still scoring when this entry was made.
- Added machine-readable grounded trace generator `tools/report_reasoning_trace.py`. It repeats calibrated visual/structure evidence and unresolved observations, not unverified physical defect causes. Unit tests prohibit turning a two-mask segmentation result into a missing-part conclusion. This is explicit decision logic, not a trained human-like reasoner.
- Before inspecting field metrics, fix a supplementary operating-point comparison: normal calibration q95, q99, maximum and maximum×1.2. All rules will be shown; no automatic best validation rule selection. Reuse scores, no model retraining. Wilson intervals are descriptive under an image-independence assumption, with temporal-correlation caveat.
- Cable-swap breakdown: raw and normal-augmented models both detect0/12 original swaps. Raw combined detects8/12 but augmented combined0/12; raw sensitivity under brightness/pose changes must not be interpreted as learned swap reasoning. Structural evidence must be evaluated separately on all12.

## 2026-10-01 — IV baseline result and supervised comparison ruling

- IV baseline completed and passed standard artifact validation: AUROC0.877088, default maximum×1.2 threshold0.390951, TN691/FP0/TP2/FN688. This operating point is unusable despite zero false alarms.
- Normal-only threshold report `industrial_calibration_20261001_005049`: q95 threshold0.154402 yields TP625/FN65/FP132/TN559; q99/max threshold0.325792 yields TP8/FN682/FP3/TN688. No single shown rule resolves the overlap. No rule selected from validation as a deployed threshold.
- Highest calibration normal `00240_000_OK_20260922_104906.jpeg` responds strongly near the lower ring line; user-confirmed OK label preserved. Do not relabel it to improve metrics or remove it after seeing scores.
- Ruling: add one fixed supervised control using the existing IV FIT-group normal200 + previously excluded FIT-group NG196. Standardized spatial mean/max DINO features with logistic regression C=1 balanced, FIT-only scaling; normal calibration100 q95 threshold. NG calibration-group104 stay excluded, validation691OK+690NG identical to baseline. No supervised hyperparameter sweep. Additional NG supervision explicitly disclosed; not a normal-only anomaly detector or proof of human-like reasoning. Signed linear feature attribution must not be presented as a defect mask.

## 2026-10-01 01:03 — full structural ablation and field results

- Full SAM structure `reasoning_structure_20261001_002019` completed750 cases, mask/graph replay validated. Composition original detects25/92, misses29, reviews41/150 and falsely flags12/58 normals: not a standalone full-defect inspector.
- Full augmented fusion `reasoning_fusion_20261001_005844`: original FP11/FN2/TP90/REVIEW3; combined FP12/FN2/TP89/REVIEW4. Swaps original12NG/12; combined11NG+1REVIEW. Better defect coverage costs false alarms.
- Semantic relation `reasoning_relations_20261001_005842`: all12 original swaps have ambiguous/out-of-normal color identity and REVIEW, not successful semantic-order classification. This MVTec category cannot be equated with the synthetic unchanged-color two-node permutation unit test.
- Component ablations fixed before their evaluation: `reasoning_fusion_20261001_010009` color-only original FP5/FN2/TP90/REVIEW3; combined FP5/FN2/TP89/REVIEW4. `reasoning_fusion_20261001_010015` geometry-only original FP11/FN13/TP79/REVIEW3; combined FP12/FN14/TP77/REVIEW4. Geometry adds false alarms with little useful detection in this setup. Color-only is a development candidate, not independently validated winner.
- Grounded color-fusion trace `reasoning_trace_20261001_010153` records unchanged decisions and measured evidence, without inferring physical missing parts from SAM failures.
- Full semantic-pose command initially omitted --limit0, repeating the18-source pilot in `reasoning_visual_sam_20261001_005841`; preserve as pilot, not full result. Corrected all150-source run `reasoning_visual_sam_20261001_010031` is running. Same model/gates and raw-bank reuse.
- Bolt baseline completed: validation2272OK/5NG, AUROC0.957482, default threshold FP17/TP1/FN4/TN2255. Five NG are insufficient for broad recall conclusions; source images preserved and standard artifact validation passed.
- IV supervised `industrial_supervised_20261001_005309` completed: normal-q95 TP690/FN0/FP58/TN633, AUROC1.0. Compare with normal-only **same q95 policy** TP625/FN65/FP132/TN559, not solely against its maximum×1.2 default. Additional196 NG labels and temporal correlation limits are explicit. Independent review found no leakage/score-replay defect and highlighted this threshold-policy comparison.
- Original supervised logits: normal-validation max−5.6398, NG-validation min5.1617. Native logistic decision0 would separate these observed originals, but this does not establish generalization. Add native0 as a disclosed posthoc default-rule control, not a tuned validation-gap threshold.
- Freeze model and both rules (q95/native0) before evaluating IV brightness0.5, rotation15°, translation(+5%,−4%) and combined conditions on all1,381 validation originals. No retraining or threshold adaptation; synthetic labels remain unconfirmed. `tools/experiment_industrial_stress.py` running, failure cases retained.

## 2026-10-01 01:12 — verification and additional controls

- Bolt calibration report `industrial_calibration_20261001_010205`: q95 FP372/TP5/FN0; q99 FP144/TP4/FN1; max FP45/TP1/FN4; max×1.2 FP17/TP1/FN4. Normal denominator2272, NG5. AUC0.957 does not imply an acceptable operating point.
- Reload audit `industrial_reload_audit_20261001_010322/audit.json`: both public API checkpoints reloaded; one normal calibration, one normal validation and one NG validation per model reproduced all6 stored scores exactly. Environment versions recorded.
- Stress-tool review found a presentation issue: original cards print q95 verdicts while the gallery summary used native0. Numerical predictions unaffected. Future source now labels this explicitly; the running process retains its snapshot. After completion, `tools/report_industrial_stress.py` will create a separate corrected view showing both rules and explaining the original card text. Final report will link the corrected view; original artifact not overwritten.
- Additional fixed color-region ablation: same SAM whole-part masks and full-mask geometry, but RG median uses a distance-transform band at15–55% of maximum internal distance. This is a geometric insulation proxy, not a true material segmentation. Metal centers remain inside whole-part observations. FIT/CAL color references and thresholds rebuilt from normal images only; evaluate the color-only fusion branch.
- Reviewer notes: changing color observability may also change which normal reference rows qualify, so whole-graph score/threshold equality is not assumed. Compare valid FIT/CAL counts; descriptor equality is verified where both observations are valid. Primary new comparison uses color-only fusion. No new major code defect found; related4 tests passed in review.

## 2026-10-01 01:16 — peripheral color statistics result

- `reasoning_color_region_20261001_011051` completed. Both original and band variants have174 valid FIT observations and45 valid calibration observations; geometry threshold unchanged0.334998712. Color threshold0.162907662→0.166217185.
- Band color fusion `reasoning_fusion_20261001_011449`: original FP5/FN2/TP90/REVIEW3, combined FP4/FN2/TP89/REVIEW4; rotation FP5/FN4/TP86/REVIEW8. Whole-part color fusion original identical; combined FP5, rotation TP87. Thus this added region heuristic offers no clear overall improvement. Preserve it as an ablation; prefer the simpler whole-part color candidate for now.
- This result does not support deleting metal centers from part segmentation. Segmentation never changed; only the color statistic region changed.

## 2026-10-01 01:17 — full semantic-pose result

- `reasoning_visual_sam_20261001_010031` completed150 originals×5 conditions×3 branches, validated. Photo branch original FP0/FN4/TP27/REVIEW71; combined FP0/FN2/TP10/REVIEW113. Again, low false alarms largely coexist with insufficient coverage, not a complete robust detector.
- Paired consistency audit `reasoning_pose_audit_20261001_011705`: rotation56/150 pairs both accepted, mean2.43px; combined35/150, mean2.76px. No accepted pair exceeds30px diagnostic cutoff. This supports conditional transformation consistency, not absolute registration truth or high overall defect recall.
- Keep accepted pose/brightness as an explanatory observation and research module. Do not replace the broader appearance+color composition detector with this low-coverage branch.
- Fresh reasoning regression suite:37 tests passed after the color-statistics extension. Industrial4 and atomic-write2 tests are separate suites.

## 2026-10-01 01:26 — IV stress validation and fine-part hypothesis

- IV fixed supervised stress `industrial_stress_20261001_010131` completed1,381 originals×5 conditions=6,905 cases (two decision rules each). Native logit0: FP0/FN0 in all5 conditions, source-label AUROC1.0. This is performance on this existing image collection and its deterministic transformations, not new-product/session or arbitrary-condition generalization.
- Normal-q95 uses the same classifier scores but produces FP58 original,75 dark,690 rotation,191 translation,687 combined out of691 normals; FN0 throughout. The classifier still ranks all690 NG above all normals, but a normal-only quantile operating point shifts badly. Do not apply normal-memory threshold heuristics blindly to a supervised logit.
- Corrected two-rule view: `industrial_stress_report_20261001_012206`. Original cards retain their printed q95 text, explicitly explained next to both current verdicts. Source experiment preserved. Final report will link this corrected view.
- Independent replay `industrial_stress_replay_20261001_012500`: five saved transformed RGB inputs from both classes reproduced classifier scores. Blank black/white controls both yield positive NG logits; they are not part of validation and do not show product understanding. A real inspection system still needs a product-observation/quality state, not an invented defect explanation.
- Remaining original cable misses of the whole-part-color fusion: `missing_wire/000.png` and `missing_wire/007.png`. New fixed hypothesis: inspect enlarged internal parts with separate normal memories, keeping the global detector for outer defects. FIT-only identity quality gates, three392-long-side crop memories with4 mild normal views,4000 patches per identity; normal CAL q95 of max part score. No test threshold tuning. This adds compute/memory and uses already observed development errors; no independent final-accuracy claim.
- Parts are cropped with15% margin; score includes the rectangular neighborhood, not only the SAM mask. Missing identity or part evidence produces REVIEW. Fine branch is added as another normalized evidence channel in fusion; available positive evidence can NG, missing evidence cannot OK.
- Independent code review found no major new defect;13 related tests passed. Report complete-case normal calibration count because an added branch can change the calibration subset. Running fine-part snapshot preceded an extra source-FIT manifest equality guard; audit actual input equality after completion.

## 2026-10-01 01:33 — fine-part result and final consolidation

- `reasoning_parts_20261001_012334` completed750 cases. Original standalone FP0/FN9/TP27/REVIEW60: this is an internal-part observation branch, not a complete detector. `missing_wire/000` standalone score0.435773 exceeds threshold0.399421; `007` score0.386010 remains below threshold. The saved map responds to the reduced copper area in000, but is not a ground-truth defect boundary.
- Three-branch fusion `reasoning_fusion_20261001_013056`: original FP4/FN7/TP85/REVIEW3; dark FP3/FN8/TP83/REVIEW4; rotation FP5/FN3/TP87/REVIEW8; translation FP5/FN3/TP89/REVIEW4; combined FP2/FN3/TP88/REVIEW4. It does not beat the simpler color fusion overall and is not selected as the main candidate.
- Complete original normal calibration remains45 cases with and without fine parts. Adding the fine score raises the original_cal joint threshold1.042456→1.097928. Consequently even000 remains automatic OK after fusion (ratio0.993699); do not report standalone detection as final-system success. No threshold retuning to rescue this case.
- Source FIT manifest equality checked explicitly against both structural config and actual FIT manifest: `5b08346f7c99cf76388bb73be3f5596aa99d0286c1552ad5d4a7aa076aaeb6e6`. Completed artifacts remain unchanged. New evidence trace: `reasoning_trace_20261001_013110`.
- Fresh regression checks passed:41 reasoning,4 industrial,2 atomic-write tests (47 total). Final report includes all completed comparison branches, with whole-part-color fusion retained as the development candidate and fine-part results recorded as an unsuccessful extension.

## 2026-10-01 01:43 — completed first autonomous experiment batch

- Final report: `output/comparisons/reasoning_report_20261001_014218/index.html`; stable entry: `RESEARCH_REPORT.html`; concise research conclusions: `docs/REASONING_RESULTS_20261001.md`.
- All input artifact inventories and SHA256 checks passed before report generation. Full verification of tens of thousands of files took approximately11 minutes; inference had already finished. No artifact discrepancy was encountered.
- Final report has10 paired cable configurations on750 identical cases,50 condition/configuration rows,72 linked comparison cards, separate VLM and field-data results. All166 report-local links/images resolve. Counts plot and fine-part failure card inspected visually. Audit: `output/comparisons/reasoning_final_audit_20261001/audit.json`.
- Independent final read-only review found no material numerical mismatch or overclaim in the result document/report builder, specifically checking fine-part standalone-vs-fusion outcomes and IV supervised stress scope.
- This bounded batch is complete; no training/inference/report process from it remains running. Universal generalization, trained GNN, autonomous VLM tool selection and future independent-session evaluation are not claimed complete. Original datasets and public dinopatch API remain unchanged. Further model stacking is not selected on the current development results alone.

## 2026-10-01 08:30 — image-first dashboard requested

- Added serverless interactive viewer: `output/comparisons/reasoning_dashboard_20261001_082946/index.html`. `RESEARCH_REPORT.html` opens it; previous landing preserved as `RESEARCH_REPORT_20261001_previous.html`.
- Dataset, model/threshold, condition, outcome and filename filters; summary counts, confusion matrix, condition bars, pagination and enlarged cards. Default shows cable fusion's2 misses and5 false alarms.
- Reuses18,337 saved prediction rows across overlapping model/rule/condition combinations, not18,337 independent images. No inference, label or threshold changes. Source prediction hashes, image existence and key counts checked.
- Chrome checks on initial build passed: default7 errors, image/modal loading, IV rotation zero-vs-q95 (0 vs690 FP), bolt special-character paths, pagination, cable_swap search and mobile width. Final build adds visible IV warning: printed card verdict uses q95; current selected-rule verdict is shown above it. Browser audit: `output/comparisons/dashboard_browser_audit_20261001_0828`.

## 2026-10-01 — dashboard access correction

- User saw the root wrapper's fallback links instead of the dashboard. The wrapper depended on meta-refresh; the reported view did not execute that navigation. Embedded-preview restrictions are inferred, not directly inspected in the user's app. Prior file-URL Chrome testing did not cover that access path.
- Started a report-only loopback server at `http://127.0.0.1:8765/` using `tools/serve_results_dashboard.py`; it serves output/docs and rejects other workspace files and directory listings. Root HTML now gives an explicit HTTP browser link instead of meta-refresh. `OPEN_DASHBOARD.cmd` starts the server and opens the browser when run by the user, including after reboot.
- HTTP Chrome verification passed: dashboard rendered, cable errors7, bolt errors21, images and enlarged evidence loaded. Documentation200; unrelated paths403. Audit: `output/comparisons/dashboard_http_audit_20261001/validation.json`. Report server deliberately remains running; headless test browser stopped.

## 2026-10-01 09:50 — fixed-version JEV role workflow completed

- User requested pinned JEV and separated agent roles. Implemented `tools/jev_agents.py` and `tools/experiment_jev_agents.py`; design/result documents are `docs/JEV_AGENT_DESIGN_20261001.md` and `docs/JEV_AGENT_RESULTS_20261001.md`.
- Actual pinned response model `typesafe/jev-1.13-20260917`; observation/appearance/composition → routing → cached tool lookup → critic → judge. Local visual results are reused; no private image upload, label/path input or unselected tool evidence in adaptive judgment.
- Completed36 paired pilot cases in `jev_agents_20261001_094931`, preserving failed and resumed runs. Fixed baseline TP31/FN1/FP0/REVIEW0; selected-tool agents TP3/FN0/FP0/REVIEW32; all-tool agents TP1/REVIEW35; single JEV TP2/REVIEW31. Not an accuracy improvement; high abstention must not be reported as successful detection.
- Probability-rounding parser, logging directory creation, exact-request replay and final reason consistency were fixed with regression checks.12 new tests and41 existing reasoning tests passed. Review found a reason-code contradiction, now fixed and tested. Final requests/source hashes and hidden-evidence checks passed.
- Full details, proposal-vs-policy decisions, reported API cost across resumes, network failures and limitations are preserved in the result document. No test-driven threshold or prompt retuning after observing final metrics.

## 2026-10-01 10:18 — clarify what supported each NG

- User could not connect NG decisions to concrete reasons. Added `tools/report_jev_ng_evidence.py` and `jev_ng_evidence_20261001_101831`, covering all3 adaptive NG outcomes with normal examples, query response locations, actual cited measurements, human review observations and unresolved physical interpretation separately.
- case018: appearance0.46903455 / threshold0.30473340; top1% patch mean replayed exactly. Peak near bottom exterior gap. The fixed normal example is not claimed to be the nearest DINO reference.
- case029/031: primary citation is composition, not a copper-strand count. Replayed color multiset nearest-reference/permutation calculations exactly, locating the largest color-distance contribution at query partP1. Normal FIT references198 and172 respectively. These show statistical deviation, not proof that Jev understood missing wire.
- Locations are post-hoc score/map attribution, not coordinates produced by Jev. No additional API/model inference, label change or threshold tuning. Source hashes unchanged and all final figures/report HTTP200. Earlier figure output101747 retained;101831 fixes clipped figure titles.
# 2026-10-01 10:43 — JEV 판정·설명 분리

사용자 승인 후 기존 검출 판정을 고정한 JEV 설명 및1회 저장 재검사 조회를 구현했다. 최종 `jev_explanation_20261001_103938`:36건, 불량31검출/1미검, 정상오탐0, 판정보류0. 설명 근거는 조회 전36/36, 후35/36일치. 유일 미검출 missing_wire/000 원본에서 부품 확대1.091배가 관찰됐고 JEV 설명은 미해결로 전환했으나 판정은 변경하지 않았다. 새 이미지 추론이나 독립 평가가 아니며 물리적 결함 해석은 입증하지 않았다. 전체113테스트 재실행 통과(첫 실행 임시 폴더 삭제 오류1건 기록),72요청/72이미지 링크 및입력해시/manifest 검증. 자세한 결과: `docs/JEV_EXPLANATION_RESULTS_20261001.md`.
# 2026-10-01 15:51 — 정확도 우선, 기존 기준 유지 부품 추가

사용자가 정확도 연구를 우선하고 속도 개선을 후순위로 지정했다. `parts_rescue_20261001_155115`에서750관측×4정책을 재생했다. 정상 CAL에서 이미 정한 기존 결합·부품 기준을 유지하고 부품 양성만 추가: 원본 오탐5유지, 미탐2→1, 검출90→91, 보류3유지. 다른4조건도 오탐 증가 없이 미탐1~2감소. JEV/새학습/독립검증 아님. 원본missing_wire/000 추가검출,007은 남음. 전체116테스트 통과. 자세한 기록 `docs/PARTS_RESCUE_RESULTS_20261001.md`.
# 2026-10-01 — UniVAD 공식 코드 기반 Cable 평가 완료

사용자 요청에 따라 UniVAD commit64d32873, 정상참조000 1장, 입력448로 실행했다. Windows용 호환환경과 수학식 유지 cosine분할연산을 적용하고 추적된 공식소스는 수정하지 않았다. 공식GroundingDINO+SAM-HQ분할196장, CAL45+TEST150추론완료. 정상CALq95를테스트전에고정한 결과 정확도79.33%, AUROC96.14%, FP2/FN29/TP63/TN56, swap2/12. 현재결합+확대94%보다 낮으며 정상참조예산1vs179가 다르다. 초기분할의내부3부품이 C³에서같은라벨로묶이는 예시를 관찰했으나원인확정아님. `univad_cable_20261001_160629/comparison.html`, 상세문서`docs/UNIVAD_CABLE_RESULTS_20261001.md`. 118테스트/195수치맵/150카드/231HTTP이미지링크/원본및산출물해시검증완료. 기존배포모델채택변경없음.
