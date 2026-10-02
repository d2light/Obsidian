---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [WATERSEAL_VLM_DECISION_FORMAT.md](file:///E:/DH/Sandbox/Dinopatch/docs/WATERSEAL_VLM_DECISION_FORMAT.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# Waterseal reference-based VLM inspection

Scope: a waterseal mounted on a jig. Detect visible tears and uneven cutting
profiles, using a human-confirmed acceptable reference. Do not interpret jig
features or brightness alone as defects. No dimensional tolerance has been supplied.

Input order for this prompt: reference image, then query image. Both images must
show the inspection region clearly enough; do not guess a missing reference.
The current user message had no visible attached reference. Reference selection
is pending before any new inference calls.

Prompt: `references/waterseal_vlm_prompt.txt`.
Schema: `references/waterseal_vlm_schema.json`.

Illustrative output only, not a prediction on a supplied image:

```json
{"decision":"NG","reason":"절삭면 왼쪽에 국소적인 홈이 보입니다.","defects":[{"type":"uneven_cut","bbox":[210,450,270,510]}]}
```

OK and REVIEW have empty defect arrays. Coordinates are [left, top, right,
bottom], normalized 0..1000 on the entire query image, origin top-left. To draw
on a W by H image, multiply x by W/1000 and y by H/1000; clamp raster drawing
coordinates to image bounds. Check coordinate ordering as well as schema types.
If crops are introduced later, their coordinate system and conversion must be
explicit. Do not reuse the previous four-image probe prompt with this two-image
contract. Boxes are approximate model proposals; no pixel ground truth has been
provided, so localization accuracy cannot be claimed.

## Supplied model references (checked 2026-09-29)

- Jev Latest accepts text and returns structured decisions, rather than reading
  product images: https://openrouter.ai/~typesafe/jev-latest
- Span-01 classifies behaviors in text traces and does not generate explanations:
  https://www.respan.ai/docs/documentation/span-01/concept
  The supplied OpenRouter page was not accessible through the web reader, and
  respan/span-01 was not found in the public v1 model list during this check.
- Julia-1 is a text decision model built from mmBERT-small, not an image encoder
  or generative VLM: https://huggingface.co/SupersonicLabs/Julia-1

Their finite-choice output approach is relevant to the requested compact result,
but they cannot directly inspect pixels or independently recover defect locations
from a VLM's possibly incorrect explanation. Use an image-capable model for visual
evidence first. The existing Claude Sonnet 4.6 integration is an available pilot
candidate; earlier results were exploratory and included many REVIEW outcomes.

A pilot should retain the identical-reference control, use separately selected
query images with labels withheld from the model, draw predicted boxes for human
inspection, and count REVIEW separately from OK. Preserve response text, input
hashes, model/provider identifiers, cost and latency without saving API secrets.
