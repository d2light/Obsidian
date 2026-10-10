# 밝은 정상만으로 조도 변화 일반화: 실험 시작

## 질문·변경
밝은 정상 원본과 합성 조도 변형의 특징 일관성을 학습하면 실제 어두운 정상 오탐을 낮추면서 결함 검출을 유지할 수 있는가?

## 고정 설정
- 기준: 기존 Dinomaly run 20261009_180251 결과 재사용.
- 신규 A: 원본·gain/gamma 변형 각각의 native 재구성 손실 평균.
- 신규 B: A + 0.1 × 병목/마지막 decoder 패치 토큰의 cosine 일관성 평균. 원본 branch는 일관성 손실에서만 stop-gradient.
- FIT224/CAL85 모두 실제 밝은 OK. TEST268: bright OK134/NG70, dark OK51/NG13. 원본/분할 동일, 참조 경로·해시 사용.
- gain log-uniform[0.35,1.3], gamma uniform[0.7,1.5]. 공간 변형 없음. RGB clip은 밝은 영역 일부를 포화시킬 수 있음.
- seed1, 100epoch 최종 고정, 원본 batch8+변형8. DINO encoder 동결, bottleneck/decoder 학습. 두 신규 모델 동일 난수 흐름. 실제 dark는 학습·보정·설정 선택에 사용하지 않음.
- CAL 밝은 정상 q95 higher, score > threshold. TEST 원본은 기존 resize448/crop392 그대로. 중심87.5% 범위만 검사.
- 평가: 전체/밝음/어두움 AUROC, FP/FN, 원점수 분포, 전체 TEST 이상맵.
- 기전 확인: CAL ID순 첫16장에 고정 gain0.5/gamma1.3 변형을 적용하여 eval 모드 내부 특징 cosine 거리와 점수 차이 비교. threshold/설정 선택에 쓰지 않음.

## 검증·진행
분할과 밝은 정상 FIT/CAL 제한, 증강 좌표 보존, stop-gradient 방향 단위 검사 통과. 첫 epoch 유한 손실 확인. 최종 결과는 아직 없음.

## 한계·결정·다음
GNL에서 착안한 Dinomaly 실험이며 공식 재현 아님. Frozen encoder의 조도 민감성은 남음. 새 모델은 기준 대비 학습 view 수가 2배이므로 증강만 모델을 따로 둔다. 기존에 관찰한 개발 TEST, 1 seed, 실제 dark NG13장, 픽셀 GT 없음. 물체를 인간처럼 이해함을 입증하는 실험은 아님. 모든 모델 학습 완료 후 함께 비교하고 실패도 기록.

## 저장·출처
대용량 산출물 D:/research_artifacts/Dinopatch, 원본 복사0, JPG 시각화/NPY 맵, 최종 weights 유지. 예상 peak6GiB/final2GiB, 실제 용량은 완료 후 집계. 중간 checkpoint는 검증 이후 정리.
- E:/DH/Sandbox/Dinopatch/output/comparisons/photometric_consistency_20261009_224940
- tools/probe_photometric_consistency.py
- tools/train_dinomaly_isolated.py
- tools/field_model_comparison.py
