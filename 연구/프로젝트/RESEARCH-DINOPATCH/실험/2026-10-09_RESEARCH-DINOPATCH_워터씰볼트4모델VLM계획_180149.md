# 워터씰·볼트: 네 검출기와 두 VLM 비교 (진행 중)

## 질문·결정
사용자 승인: Dinomaly·DINO Patch·EfficientAD·PatchCore 네 모델, Qwen235B Instruct·Sonnet 비교. 원본 참조·정상만 FIT/CAL, 데이터 무보관(ZDR) 및 학습 수집 금지 유지. 공개 MVTec 한정 예외를 제조 데이터에 확대하지 않는다.

## 분할·설정
워터씰 재라벨링 기존 분할: 밝은 정상 FIT224/CAL85, TEST 밝은OK134/어두운OK51/밝은NG70/어두운NG13. 볼트 ipsAuto 기존 camera1 시간분할: FIT275/CAL152/TEST OK2272 NG5. 다른 카메라·해상도 NG12는 외부 조건 참고 평가(AUROC 없음), 정상 해상도불일치2장은 기존 제외 유지. 총확보NG17과 주평가NG5를 혼동하지 않는다.
1차 전 모델 CAL q95 higher, 원점수 및 CAL중앙값/q95 스케일 비교. Dinomaly final100, DINO long-side700 coreset3000, 공식 PatchCore WRN50 coreset10%, EfficientAD10k 탐색 일정. 각 모델 native 전처리를 기록하며 시야·해상도가 동일하지 않다. 픽셀 GT 없으므로 픽셀AUROC 산출 금지.
2차 사전선정: 워터씰 TEST268 전체, 볼트 TEST 정상200 무작위고정seed20261009+NG5, 외부NG12 별도. 정확도는 이 표본에서 네검출기도 재집계하여 VLM과 비교. 모델 결과로 선택하지 않음. 정상FIT top3 검색 + 전체 검사 vs 동일입력+모델의심영역(최대2) 비교. 정답/파일명은 API에 보내지 않음.

## 진행·실패
원본 SHA 검증 및 역할 중복 검사를 통과했고 워터씰 Dinomaly 학습 시작. 아직 성능 결과 없음. 초기 HTML 링크 생성은 D물리경로와 E보고서 상대경로 차이로 중단됨. E junction 논리경로 보존으로 수정하고 학습 시작; 원본 영향 없음.

## 저장·한계·다음
D:/research_artifacts/Dinopatch에 최종모델/수치맵, E output junction. 입력 복사0, JPG시각화. 예상 peak24GiB/final12GiB(추정). 과거에 살펴본 개발데이터이며 독립적인 새현장 검증은 아님. 볼트NG5는 특히 표본이 작음. 촬영분/버스트 분리라도 같은제품 상관은 완전히 검증되지 않음. 모델 평가·시각화 검증 후 다음 기록에 실측 결과를 추가.

## 출처
- output/comparisons/field_models_20261009_180149/data.json 및 suite.json
- tools/field_model_comparison.py
- tools/train_dinomaly_isolated.py (평가·보고 콜백만 추가; 기존 기본동작 유지)
- tools/prepare_model_candidate_fusion.py (공유 EfficientAD 정상학습, metadata 개수 동적 기록)
