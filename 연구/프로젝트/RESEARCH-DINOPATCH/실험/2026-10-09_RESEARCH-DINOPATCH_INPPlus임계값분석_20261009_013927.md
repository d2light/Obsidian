# INP++ 정상 모델 screw 임계값 분석

- 질문: 영상 AUROC 99.24% 모델의 임계값을 조절하면 오탐·미탐은 어떻게 달라지는가?
- 변경: 저장된 test 점수의 고유값 및 최솟값 직전으로 임계값 전수 탐색. 신규 학습·추론·운영 임계값 변경 없음. score > threshold이면 NG.
- 데이터/설정: 기존 FIT256 정상/CAL64 정상/TEST160(OK41, NG119), ++ normal_only, 원본 보존.
- AUROC는 임계값 자체가 아니라 점수 순위의 지표이며 임계값 조절만으로 바뀌지 않는다.

| 조건 | 임계값 | 정확도 | FP | FN |
|---|---:|---:|---:|---:|
| 기존 CAL q95 | 2.079414368 | 95.000% | 2 | 6 |
| TEST 최고 정확도 | 2.046679735 | 96.875% | 2 | 3 |
| TEST 미탐 0 | 1.888895035 | 92.500% | 12 | 0 |
| TEST 오탐 0 | 2.161667347 | 93.750% | 0 | 10 |

- 한계: 최고 정확도 및 미탐/오탐 0 지점은 TEST 정답을 본 사후 탐색이며 독립 검증 성능이 아니다. 새 데이터에서도 같은 결과를 보장하지 않는다. 점수 중첩으로 이 TEST에서도 단일 임계값 완전 분리는 불가능.
- 결정: 기존 CAL 임계값 유지. 실제 변경하려면 별도 검증셋에서 허용 오탐·목표 재현율을 정하고 고정한 뒤 독립 test 평가.
- 다음: 남은 오류의 점수·영상 특징 확인. 신규 실험 실패 없음.
- 입력: output\experiments\DinoPatch_20261009_010357_INPFormerPP_normal_only_screw_B392_fit256_cal64/predictions/per_image.json
- 입력 SHA256: fb71b328a5756f8cf10c4b10d547dec4110da4f18eebd2eae5aebcd9cd1a3dd1
- 분석 산출물: E:\DH\Sandbox\Dinopatch\output\comparisons\inp_plus_threshold_20261009_013927 (threshold_sweep.json 전체 후보/선택 결과)

![[../첨부/20261009_013927_inp_threshold.png]]
