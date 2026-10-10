# 워터씰·볼트 네 검출기 비교 완료

## 질문과 설정

현장 데이터에서 정상 학습 기반 검출기의 순위 성능과 고정 임계값 오탐·미탐은 어떤가? 기존 역할 분할, 원본 TEST, 정상 CAL q95(higher)보다 큰 점수를 NG로 판단했다. TEST 정답으로 임계값을 조정하지 않았다. 워터씰 FIT224/CAL85는 밝은 정상만, TEST268=OK185/NG83. 볼트 FIT275/CAL152, 주 TEST2277=OK2272/NG5; 다른 촬영 조건 NG12는 별도이다. 원본 변경·입력 복사 없음.

|데이터|모델|AUROC %|정확도 %|오탐|미탐|
|---|---|---:|---:|---:|---:|
|waterseal|dinomaly|91.9179|78.7313|56|1|
|waterseal|dino|89.3650|76.8657|62|0|
|waterseal|patchcore|85.7962|80.2239|53|0|
|waterseal|efficientad|93.6568|79.4776|55|0|
|bolt|dinomaly|97.6673|93.9394|137|1|
|bolt|dino|93.6092|80.2811|449|0|
|bolt|patchcore|94.9736|93.1489|155|1|
|bolt|efficientad|90.6162|94.4664|124|2|

## 해석·한계

워터씰 네 모델 모두 어두운 정상51장을 NG로 판단했다. 밝은 정상 CAL 임계값의 조도 이동 취약성이 재확인되었다. 밝은 조건만 보면 PatchCore FP2/FN0이다. 볼트는 Dinomaly 순위 AUROC가 가장 높지만 DINO Patch는 미탐0 대신 오탐449로 더 많다. 볼트 주 NG5는 매우 작아 단일 오류가 재현율20%p를 바꾼다. 외부 NG만으로 AUROC/특이도를 계산하지 않는다. 반복 관찰한 개발 데이터이며 물체별 독립성은 완전히 보장하지 못한다. 픽셀 정답이 없어 이상 위치 정확도는 정량 비교하지 않았다.

Dinomaly final100epoch, DINO plain700/coreset3000, 공식 PatchCore WRN50(layer2/3, coreset10%), EfficientAD small10000step. 해상도와 검사 시야가 동일하지 않으며 Dinomaly/PatchCore는 중심 crop으로 가장자리 일부를 검사하지 않는다. 논문 재현 성능 표가 아니다.

## 실패·복구

볼트 DINO 외부 BMP3장의 가로세로 비율이 FIT과 반대로 라이브러리 고정 패치 격자 검사가 실패했다. plain 전역 메모리뱅크에 한해 같은 특징·거리 계산을 가변 격자로 평가했다. 기존2438개 맵 및 가중치 SHA256 유지, 3개만 추가 평가. 일반 라이브러리 동작은 변경하지 않았다. logs/grid_recovery.json 참조.

## 결정·다음 단계

Qwen3-VL-235B Instruct/DeepInfra 및 Sonnet5.5/Bedrock를 동일 표본에서 비교 중이다. ZDR=true, data_collection=deny, fallback=false. 워터씰268, 볼트 주205=정상200+NG5, 외부12. 정상 FIT 참고3장+원본 대 동일입력+검출기 후보 crop2장 이내. 자체 이상 점수0~100은 확률이 아니다. Qwen 공유 공급자 과부하429는 성능 오류와 분리하고 제한된 기술 재시도만 한다. 유효한 분류/점수와 잘못된 위치 좌표를 분리한다. 아직 VLM 최종 결론 없음.

![[현장4모델_waterseal_180149.jpg]]

![[현장4모델_bolt_180149.jpg]]

## 출처

- 비교: `E:\DH\Sandbox\Dinopatch\output\comparisons\field_models_20261009_180149`
- 코드: `tools/field_model_comparison.py`, `tools/finish_field_comparison.py`
- full_metrics.json SHA256: `76b63e008edbc8c1d2c359f39a4e70e8fc7faec3599040460cb8d8adb1bcec1a`
- [대시보드](http://127.0.0.1:8765/output/comparisons/field_models_20261009_180149/comparison.html)
