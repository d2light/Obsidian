# 상대 경계와 자기유사도 후속 실험 결과

## 질문과 조건
밝은 정상 기준5장+별도CAL5장만 고정하고 신규 조도 이미지를 추가하지 않아도 판정할 수 있는가? 이전 profile 기준과 A1 상대폭 다중크기 잔차, A2 안정 경계, A1+A2, B1의 2D MIND-inspired 표현을 비교했다. MIND 원저자의 3D 공식 구현 재현이 아니라 원리 기반 2D 실험이다. 신경망 학습/optimizer 없음. 각 조건의 설정은 실행 전에 기록했다.

FIT/CAL/TEST는 직전 소수기준 split과 동일하며 해시와 그룹 분리 검증. 원본TEST268(밝음OK134/NG70, 어둠OK51/NG13), 밝은CAL5 q95 higher=max, 엄격한 score>threshold. 중앙87.5% crop 및 정해진 띠/경계만 검사. 넓은 변형·전체 물체·회전 일반화 주장은 하지 않는다. 반복 개발TEST다.

## 변경과 실패 진단
A1은 경계 잔차를 국소폭으로 나누고 sigma4/12/32 중 가장 큰 차이를 사용. A2는 열별 p10/p95 밝기 범위의35/50/65% 경계 교차를 측정하고 중간 경계를 서브픽셀로 계산했다. 다중 임계값의 경계 흔들림2.5px 초과는 불확실로 표시했다.

첫4조건 후 CAL0377/0193의 불확실한 열2개에 큰 고정거리(8 또는1)를 넣는 규칙이 CAL 임계값을 지배함을 재현했다. stable의 실제 기록 점수5.390803/5.405332가 고정벌점 전 진단거리에서는0.161413/0.194890이었다. 진단파일은 앞 suite의 cal_penalty_diagnosis.json이다. 이는 정상 형태의 차이만으로 설명했던 해석을 보완하는 새 근거다.

후속 measured 2조건은 중간 임계값 경계가 실제로 측정되었는지와 여러 임계값에서 안정적인지를 분리했다. 측정된 불확실한 경계는 그 실제 거리로 계산하고, confidence90% 미만 또는 실제 경계 누락은 REVIEW로 처리했다. 원래4조건을 덮어쓰지 않았다. CAL을 제외하거나 TEST에 맞춰 임계값을 지정하지 않았다. 첫 결과와 CAL 진단을 본 뒤 만든 수정이므로 독립 검증이 아니다.

## 검증된 결과
|조건|AUROC%|자동 오탐|자동 미탐|불량 재확인|불량 자동검출|
|---|---:|---:|---:|---:|---:|
|profile_k5|97.6490|0|30|34|19|
|profile_relative_k5|94.1973|0|30|34|19|
|profile_stable_k5|99.5767|0|29|34|20|
|profile_combined_k5|99.9935|0|34|34|15|
|mind_k5|73.9043|2|66|16|1|
|profile_stable_measured_k5|97.9551|71|0|34|49|
|profile_combined_measured_k5|99.6288|67|0|34|49|

모든 조건의 정상 재확인은0. 수정 결합 measured는 AUROC99.6288%, 오탐67(밝음16/어둠51), 자동 미탐0, 불량 자동검출49/재확인34. 재확인34는 검출 성공이 아니다. 모든 실제 어두운 정상51장은 여전히 오탐이다. MIND-inspired 조건은 AUROC73.9043%, 점수상 미탐82, 운영상 미탐66/재확인16으로 개선되지 않았다.

수정 결합의 임계값0.0149221에 대해 밝은 정상 중앙값0.0105948, 어두운 정상 중앙값0.0206372, 어두운 불량 중앙값0.0311047이다. 구조 표현도 실제 조명 변화에서 점수 이동을 완전히 제거하지 못했다. 어두운 내부 AUROC100%가 밝은CAL 임계값의 적합성을 뜻하지 않는다.

## 이전 neural 모델 결과 재확인
동일 원본TEST268이지만 밝은FIT224/CAL85였던 별도 실험이다. Dinomaly 전체AUROC91.9179%, FP56/FN1, bright5/1, dark51/0, darkAUROC100%. DINOv2 패치뱅크 전체AUROC89.3650%, FP62/FN0, bright11/0, dark51/0, darkAUROC72.6998%. 이번 기준5/CAL5와 데이터 예산이 달라 단순 우열 주장은 하지 않는다. Dinomaly는 패치뱅크 최근접 검색이 아니라 정상 특징 재구성 오차 기반이다.

## 결정과 다음
배포 구성 채택 보류. A1/A2/B1 실행 완료, 고정벌점과 품질 실패를 분리하는 수정까지 검증. B3 조명 변화 방향의 DINO 특징 투영, FastRecon 등은 이번에 실행하지 않았다. 다음 우선순위는 B3의 동일 예산 DINO 대조군과 합성 조도 변화 특징 제거이며 실제dark를 학습/CAL로 쓰지 않는 제약을 유지한다. 품질검사로 재확인된34건의 원인을 추가 확인할 필요가 있다.

## 검증과 저장
unittest8개 통과. 모델descriptor 저장/재로드 score/map 동일 검증. 7조건 산출물 검증, 지표 재계산, 브라우저 카드7/사례268/선택3개/링크15/JS오류0 확인. 원본 입력 복사0, JPG 보고서와 float32 NPY 맵 보존. 신규 가중치 다운로드·VLM API 호출 없음. Git 직접 커밋/push 없음.

## 출처
- E:/DH/Sandbox/Dinopatch/output/comparisons/few_reference_structure_20261010_174912
- E:/DH/Sandbox/Dinopatch/output/comparisons/few_reference_structure_20261010_175153
- E:/DH/Sandbox/Dinopatch/output/experiments/DinoPatch_20261009_180251_field_waterseal_dinomaly/predictions/metrics.json
- E:/DH/Sandbox/Dinopatch/output/experiments/DinoPatch_20261009_181627_field_waterseal_dino/predictions/metrics.json
- tools/probe_few_reference_structure.py, tools/report_few_reference_structure.py, tests/test_few_reference_structure.py
- MIND 논문 https://pubmed.ncbi.nlm.nih.gov/22722056/
- 시각화 http://127.0.0.1:8765/output/comparisons/few_reference_structure_20261010_175153/comparison.html

![[2026-10-10_few_structure_175153.jpg]]

## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\few_reference_structure_20261010_175153`
- `tools/probe_few_reference_structure.py`
- https://peterkovesi.com/projects/phasecongruency/index.html
- https://github.com/alimuldal/phasepack (Python 이식본, 원저자 공식 Python 구현은 아님)
- https://www.cs.cornell.edu/~rdz/Papers/ZW-ECCV94.pdf
