# Dinomaly와 VLM: AUROC와 정확도 구분

## 질문·확인
저장된 15종 MVTec 결과의 AUROC 비교 요청. 재학습·API 재호출 없음. 기존 산출물 지표를 재확인했다.

## 데이터·설정
Dinomaly: 정상 FIT80/CAL20, final100, CAL q95 임계값. Qwen3-VL-235B-A22B-Instruct: DINO 정상 top3 검색 + 기준/검사1024 이미지. 두 실험은 MVTec 공식 TEST 전체1725장을 대상으로 기록되어 있고 이번에는 카테고리별 장수 일치를 확인했다. 이번 작업에서 원본 이미지 전체 해시를 재검증하지 않았다. 학습/기준 후보 수·전처리는 서로 다르다.

## 검증 수치
Dinomaly 카테고리 평균 I-AUROC 99.715649%. VLM은 연속 이상 점수를 저장하지 않아 비교 가능한 연속 점수 AUROC 없음. 이진 판정으로 계산한 AUC를 동일한 점수 지표로 대체하지 않는다.

|카테고리|Dinomaly I-AUROC%|Dinomaly 정확도%|VLM 정확도%|
|---|---:|---:|---:|
|bottle|100.00|97.59|96.39|
|cable|100.00|100.00|99.33|
|capsule|98.40|96.21|89.39|
|carpet|99.96|97.44|95.73|
|grid|100.00|97.44|92.31|
|hazelnut|100.00|99.09|96.36|
|leather|100.00|100.00|99.19|
|metal_nut|100.00|100.00|99.13|
|pill|99.29|97.01|93.41|
|screw|98.89|93.75|81.25|
|tile|100.00|100.00|100.00|
|toothbrush|100.00|100.00|97.62|
|transistor|99.62|94.00|95.00|
|wood|99.56|97.47|96.20|
|zipper|100.00|91.39|86.75|

전체 이미지 정확도 Dinomaly97.1594% (FP34/FN15), VLM93.9130% (FP26/FN79). VLM 좌표 형식 오류10건은 OK/NG가 유효하면 분류 정확도에는 반영; 위치 검증 성공으로 간주하지 않음.

## 한계·결정·다음
이미 여러 번 탐색한 개발 평가다. AUROC와 고정 판정 정확도를 혼동하지 않는다. 현재 저장 결과에서는 Dinomaly가 미탐과 전체 분류 정확도에서 우세하나 오탐은 VLM보다8장 많다. 향후 연속 VLM 점수가 필요하면 별도 프로토콜로 실험해야 하며 현재 응답에서 임의 생성하지 않는다. 제조 데이터 실험 요청은 별도 후속 작업으로 유지; 아직 결과 없음.

## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\dinomaly_isolated_20261009_021035\metrics.json` SHA256 `b0e0935729bec9a7ebe146773e43ca622d90c7a8212dd85b9b58a5572aac309c`
- `E:\DH\Sandbox\Dinopatch\output\comparisons\qwen_mvtec_all_20261007_164317\predictions.csv` SHA256 `2a3bb20b274832c2b0e6f9cb1c33b46772daf1b5b868fcdbd4fcbbcdf21fd5cd`
