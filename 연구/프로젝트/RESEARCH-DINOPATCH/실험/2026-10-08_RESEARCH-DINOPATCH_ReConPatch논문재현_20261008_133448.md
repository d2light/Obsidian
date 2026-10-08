# ReConPatch WRN50 논문 기반 재현 완료

- 질문: 기존 DINO 변형을 논문 기반 모델로 다시 작업. 추가 질문: AUROC97.5인데 왜 FP1/FN22인가, 임계값을 별도로 쓰는가?
- 구현: 저자 공식 코드 미확인. 공식 PatchCore 특징집계(commit fcaa92f124fb1ad74a7acf56726decd4b27cbcad) 재사용, ReConPatch Eq1~10 별도 재현. 공식 ReConPatch 코드라는 주장은 하지 않음.
- 모델: frozen torchvision WRN50 ImageNetV1 layer2+3 patch3, f512/g128, EMA 의사라벨, RC loss sum/N, AdamP0.3.0 lr1e-5/wd.01, cosine120epoch. 정상패치200704개 매epoch1회, batch1024×196step, 총23520step. 정상1% 메모리2007개. 정확한512D greedy, GPU Euclidean 재가중 b9.
- 비교: 기존 FIT256/CAL64/test160 동일. 원본과 기존 결과 보존, VLM/배경 제거 없음. 논문은 정상320개 사용하므로 발표 수치와 동일 조건 아님.
- 가정: batch1024/g128/sigma.5/EMA.999/b9/초기화/정확한epoch샘플링은 논문 미명시. 공식 PatchCore aggregation1024 사용. 상세 run.json. 논문 원본 완전재현이 아닌 가정이 명시된 논문 기반 재현.

|모델|정확도%|Image AUROC%|FP|FN|
|---|---:|---:|---:|---:|
|기존 DINO 변형|78.750|94.835|3|31|
|WRN50 재현|85.625|97.499|1|22|

- TP97/TN40. 픽셀 AUROC98.334%는 중앙224크롭에서만 평가. 원본1024의 [64:960] 밖은 미관측 NaN/회색 표시. 불량12장은 정답 결함 일부가 크롭 밖에 있음. 전체 픽셀 성능으로 오해하지 않음.
- 판정 임계값0.5431724191: 정상 CAL64 이미지 점수의95분위 higher. 점수>임계값이면NG, 이하면OK. 테스트 라벨로 임계값 선택 안 함. 이미지 점수는 평활화 전 재가중 패치점수 최대; 표시 맵은 Gaussian sigma4 적용.
- AUROC는 정상41×불량119=4879쌍 중4757쌍의 순위가 올바른 비율. 특정 임계값 정확도와 다름.
- 테스트 사후 설명: 약0.519023→FP5/FN5, 0.512932 바로 아래→FP7/FN3, 0.494690 바로 아래→FP26/FN0. 독립 검증이나 운영 임계값으로 채택하지 않음. threshold_tradeoff.json에 정확한 값. 현재 임계값 유지.
- 학습 루프120epoch 약93.46초, 특징추출20.51초. 저장특징 기반 점수계산 약1.04ms는 백본/전처리 제외이므로 전체 추론속도 아님.
- 검증: 수식/동률kNN/ROI 단위테스트4개 통과. checkpoint120epoch, coreset2007고유인덱스, train/cal/test 해시 분리, CAL 임계값, 재로딩 점수 확인. 동일batch8 원본부터 재로딩3사례 맵오차0. batch1에서는 최대0.002318 차이로 초기 엄격 수치 검사 실패했으나 동일batch검증 통과;3사례판정 동일, 전체batch1 보장아님. CSV BOM 읽기 오류 수정 후 보고서 완료.
- 시각화: 전체160원본/GT/기존/신규 비교, 학습손실/점수분포/ROC/혼동행렬, FP/FN 필터. 브라우저15필터/160카드/162이미지/JS오류0, 로컬링크 검사 통과.
- 한계: 단일 seed, 이미 관찰한 개발세트. 백본·해상도·옵티마이저·점수 등이 함께 변해 단일요인 기여실험 아님. EMA목표 변동으로 손실이 상승했으며 단순 감소로 학습성공을 주장하지 않음. 저자 미공개 세부 설정에 따른 차이 남음.
- 결정: 별도 WRN 논문재현 결과로 보존. 기존 DINO변형 성능을 ReConPatch 논문 성능으로 부르지 않음. 세 모델 평균은 아직 이 신규 모델로 재계산하지 않음.
- 다음: 독립 보정/검증 범위에서 목표 FN/FPR 기준 설정 및 누락된 논문 세부설정 확인. 테스트 정답에 맞춘 임계값 채택 금지.
- 보고서 http://127.0.0.1:8765/output/comparisons/reconpatch_wrn_paper_20261008_133448/index.html
- 코드 tools/reconpatch_wrn.py, tools/train_reconpatch_wrn.py, tools/report_reconpatch_wrn.py
- 출처 https://arxiv.org/html/2305.16713v2 및 https://www.lgresearch.ai/publication/view?seq=85
- 산출물 해시 `E:\DH\Sandbox\Dinopatch\output\comparisons\reconpatch_wrn_paper_20261008_133448\artifact_manifest.json`

![[../첨부/20261008_133448_recon_wrn_summary.png]]
