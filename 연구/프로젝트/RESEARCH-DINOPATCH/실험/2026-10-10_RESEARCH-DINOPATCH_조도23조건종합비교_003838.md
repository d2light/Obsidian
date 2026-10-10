# 조도23조건 종합 비교 결과

## 질문·변경·설정
Bright normal FIT224/CAL85 only, exact immutable baseline split; original TEST268. CAL q95 higher before TEST, strict >. Parameters fixed before scoring; previously inspected development data; no claim of independent generalization. Pixel corrections before frozen raw-trained Dinomaly are inference-only adaptation probes, not matched retraining. bank_* fits a new normal bank with identical correction for FIT/CAL/TEST. Official restoration checkpoints are externally pretrained, not trained only on field bright images. GNL-inspired AdaIN/EFDM uses FIT-only target statistics on collected DINO features, NOT official GNL reproduction. Shape/alignment extraction failure is REVIEW, never an automatic OK; numeric score-only metrics retain every case and review counts are separate.

## 측정
|방법|AUROC %|FP|FN|dark FP/FN|REVIEW OK/NG|
|---|---:|---:|---:|---|---|
|baseline|91.9179|56|1|51/0|0/0|
|prior_augmentation|91.9961|56|1|51/0|0/0|
|prior_consistency|91.8528|56|1|51/0|0/0|
|gain_ref|92.7711|56|1|51/0|0/0|
|gamma_ref|84.7672|56|1|51/0|0/0|
|hist_ref|85.2621|73|0|51/0|0/0|
|clahe|85.7050|59|0|51/0|0/0|
|msr|55.4087|60|35|51/0|0/0|
|local_div|77.2257|15|39|0/13|0/0|
|homomorphic|79.7134|13|32|0/13|0/0|
|zero_dce|95.3891|12|18|0/10|0/0|
|retinexformer|66.5386|12|54|0/13|0/0|
|adain|90.7848|56|1|51/0|0/0|
|efdm|91.4165|56|1|51/0|0/0|
|score_center|95.7017|56|2|51/0|0/0|
|score_robust|57.0889|6|48|0/13|0/0|
|score_roi|93.1097|63|0|51/0|0/0|
|template_local|77.2582|15|30|0/13|0/0|
|template_aligned|81.0160|17|30|0/13|83/73|
|contour|92.3054|7|38|0/13|0/34|
|bank_raw|97.4601|58|1|51/0|0/0|
|bank_gain_ref|98.0593|58|1|51/0|0/0|
|bank_clahe|97.3494|64|1|51/0|0/0|
|bank_msr|95.5454|53|1|51/0|0/0|
|bank_zero_dce|96.9912|61|1|51/0|0/0|
|bank_retinexformer|89.8339|58|0|51/0|0/0|

## 조합은 사후 개발 탐색
[
  {
    "name": "zero_dce + score_center / mean",
    "a": "zero_dce",
    "b": "score_center",
    "operation": "mean",
    "threshold": 0.7155912899601471,
    "n": 268,
    "TP": 83,
    "TN": 163,
    "FP": 22,
    "FN": 0,
    "accuracy": 91.7910447761194,
    "image_auroc": 99.42038423966136,
    "recall": 100.0,
    "fpr": 11.891891891891891,
    "bright_FP": 11,
    "bright_FN": 0,
    "dark_FP": 11,
    "dark_FN": 0
  },
  {
    "name": "zero_dce + bank_gain_ref / mean",
    "a": "zero_dce",
    "b": "bank_gain_ref",
    "operation": "mean",
    "threshold": 0.7960886325358754,
    "n": 268,
    "TP": 83,
    "TN": 137,
    "FP": 48,
    "FN": 0,
    "accuracy": 82.08955223880596,
    "image_auroc": 99.90882448713774,
    "recall": 100.0,
    "fpr": 25.945945945945947,
    "bright_FP": 11,
    "bright_FN": 0,
    "dark_FP": 37,
    "dark_FN": 0
  },
  {
    "name": "zero_dce + bank_raw / mean",
    "a": "zero_dce",
    "b": "bank_raw",
    "operation": "mean",
    "threshold": 0.7960886325358754,
    "n": 268,
    "TP": 83,
    "TN": 133,
    "FP": 52,
    "FN": 0,
    "accuracy": 80.59701492537313,
    "image_auroc": 99.85672419407359,
    "recall": 100.0,
    "fpr": 28.10810810810811,
    "bright_FP": 11,
    "bright_FN": 0,
    "dark_FP": 41,
    "dark_FN": 0
  },
  {
    "name": "zero_dce + bank_msr / mean",
    "a": "zero_dce",
    "b": "bank_msr",
    "operation": "mean",
    "threshold": 0.6531445759526707,
    "n": 268,
    "TP": 83,
    "TN": 130,
    "FP": 55,
    "FN": 0,
    "accuracy": 79.4776119402985,
    "image_auroc": 99.59622272875285,
    "recall": 100.0,
    "fpr": 29.72972972972973,
    "bright_FP": 20,
    "bright_FN": 0,
    "dark_FP": 35,
    "dark_FN": 0
  },
  {
    "name": "clahe + score_robust / max",
    "a": "clahe",
    "b": "score_robust",
    "operation": "max",
    "threshold": 1.216482423166417,
    "n": 268,
    "TP": 83,
    "TN": 129,
    "FP": 56,
    "FN": 0,
    "accuracy": 79.1044776119403,
    "image_auroc": 86.21947248453272,
    "recall": 100.0,
    "fpr": 30.27027027027027,
    "bright_FP": 5,
    "bright_FN": 0,
    "dark_FP": 51,
    "dark_FN": 0
  }
]

TEST 결과로 순위를 고른 조합이다. 독립 benchmark/배포 성능으로 사용하지 않는다. 새로운 촬영 그룹 검증 필요.

## 실패·한계·결정·다음
오탐 감소와 NG 손실을 함께 평가. 복원 화질 개선이 결함 검출 개선을 보장하지 않는다. RGB 보정 뒤 고정 raw-trained Dinomaly 성능과 동일 보정으로 재구성한 DINO bank를 구분. GNL-inspired는 공식 GNL 재현이 아님. REVIEW는 자동 OK 아님. 현재 waterseal 개발 데이터 1개에서의 탐색이며 모든 카테고리/조도에 대한 일반화 결론이 아니다. 후속 채택 후보는 원본 불량 민감도와 새 촬영 조건에서 확인한다.

후속 검증 후보: `zero_dce + score_center / mean`, AUROC 99.4204%, FP 22, FN 0. 각 점수를 (score−밝은 CAL 중앙값)/(밝은 CAL q95−중앙값)으로 표준화한 후 결합했다. 복원 단독보다 상보적인 단서 결합을 먼저 검증할 근거이나, 552개 조합 중 TEST 결과로 선택했으므로 채택/일반화 증거는 아니다. 구성과 임계값을 고정하고 새 촬영 그룹에서 밝음·어둠 OK/NG를 모두 평가한다. 현재 최상위 조합도 오탐이 남아 있어 모든 상황 해결이라는 주장은 하지 않는다.

실행 실패 보존: `E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261010_004426_illum_score_center_waterseal` — FileNotFoundError(2, 'No such file or directory'). Use saved CAL map for replay; FIT maps were never produced. No algorithm/threshold change; failed run preserved.

## 출처·검증·저장
- `E:\DH\Sandbox\Dinopatch\output\comparisons\illumination_screen_20261010_003838`
- `tools/screen_illumination_methods.py`
- `tools/report_illumination_screen.py`
- 원본 split SHA `f81058ecab9561447dbf48a97057e37314065ec9f3d700ae9466020c7d9f0010`
- 공식 source/weights: `references/illumination_20261010/sources.json`
- 모든 개별 run 및 이미지 표시/링크 검증. 새 모델 가중치 중복0, 입력 복사0, 신규 run 합계 5.128GiB.

![[2026-10-10_RESEARCH-DINOPATCH_조도23조건종합비교_003838.jpg]]
