# DINO 패치 vs AnomalyDINO 방식: screw 비교 완료

질문: 현재 DINO 패치와 AnomalyDINO를 비교하면 어느 쪽이 더 좋은가?
변경: dinopatch 본체는 유지하고 독립 비교 실행. 공식 구성요소를 공통 백본에 적용했다.

## 조건과 재현 범위

- MVTec screw 정상FIT256/CAL64, 원본test160(OK41/NG119). seed20261007, 이전 실행과 같은 명단. CAL/test를 메모리 학습에 사용하지 않음.
- 공통 HF facebook/dinov2-with-registers-base, 전체700 입력, 50×50패치, PIL bilinear, FP16 특징 추출. DINO 가중치 미세조정 없음.
- 공식 AnomalyDINO commit b9d1c2648e3a5247437d4d953d907a8f3d994457의 augment_image, compute_background_mask, mean_top1p 함수를 변경 없이 사용. 공식 소스 Git 작업트리 변경 없음.
- 논문 기본 Small448/bicubic 구성을 그대로 실행한 결과가 아니다. 데이터 명단을 사용하는 실행기와 디스크 메모리뱅크, GPU FP32 전수 코사인 검색으로 연결했다. TF32 해제.
- 공식 기본 mask_ref_images=False를 유지. 8방향 회전은 정상 참조에만 적용하고, 최종 조건은 검사 시 PCA 전경마스크를 적용.
- 각 조건 CAL 점수95분위(higher) 초과시NG. 테스트 정답에 맞춘 임계값·설정 선택 없음. 픽셀AUROC는 공통256 좌표에서 평가했고 원본1024 해상도 지표와 구별한다.

## 검증 결과

|조건|정확도 %|Image AUROC %|FP|FN|NG 재현율 %|
|---|---:|---:|---:|---:|---:|
|기존 DINO coreset30k·평활최대|73.750|94.405|3|39|67.227|
|기존30k·상위1% 평균|87.500|93.974|4|16|86.555|
|전체640k·상위1% 평균|86.875|94.220|3|18|84.874|
|8방향5120k·상위1% 평균|85.000|93.605|5|19|84.034|
|8방향5120k·PCA·상위1% 평균|89.375|97.848|1|16|86.555|

AnomalyDINO 방식의 정확도 +15.625%p, 오탐3→1, 미탐39→16. 기존 오판26건 개선, 기존 정답1건 악화(Q154 정상 신규오탐), 둘 다 오판16건, 둘 다 정답117건.
잔여 미탐은 manipulated_front9, thread_side7. 기존 scratch_head3/scratch_neck1/thread_top7 미탐은 이번 최종 조건에서 없음.

핵심 해석: 기존 메모리를 그대로 사용하고 이미지점수만 상위1% 평균으로 바꿔도 미탐39→16. 이 조건의 AUROC는 오히려94.405→93.974이므로 점수 순위가 전반적으로 개선되었다고 해석하지 않는다. 정상CAL 기반 임계값에서 운영점이 달라진 효과를 구분한다. 메모리 확대·회전만으로는 개선되지 않았고, 회전 조건에 PCA를 적용했을 때 FP5→1/FN19→16, AUROC93.605→97.848.

## 한계와 실패 위험

- 최종 메모리512만 패치는 기존3만의 약170.7배. 같은 메모리 예산 비교가 아니며 이번 결과로 운영 속도·메모리 효율 우위를 주장하지 않는다. 다음은 기존3만뱅크+상위1%+PCA를 별도로 확인하는 것이 합리적이다(아직 미실행).
- PCA 전경은 검사 이미지의16.84~21.04%, 중앙값19.36%. NG23장에서 GT 결함 영역 일부를 제외했고 제외12385/418611픽셀(약2.96%). 이것은23장 미탐이라는 뜻이 아니다. 전경 제외영역을 정상으로 확인했다고 해석하지 않는다.
- 단일seed, screw 한 범주, 이미 반복 관찰한 개발 테스트. cable/waterseal 등 일반화 결론 불가. 나사경계 결함을 항상 보존한다는 보장 없음.
- 정상CAL64의95분위 정책은 테스트 정상 오탐률5%를 보장하지 않는다.
- 모델 내 optimizer/loss 없음. 배포 전체 지연시간·API 비용·VLM 평가 없음.

## 검증과 산출물

- 2개 단위검증: 스트리밍거리 vs FAISS, CAL 임계값의 테스트점수 독립성 통과.
- GPU 실제 특징에서 FAISS와 최대오차1.602e-7. 기존Q001 맵 재계산 최대오차3.576e-7. 메모리 확대시 거리가 증가하지 않음 확인(수치허용범위3e-6).
- 원본480개 해시·FIT/CAL/test분리·기존DINO 점수지표 재현·조건별임계값 재계산 검증.
- 예측800행, 원본좌표수치맵800개, 160장 비교/상세페이지, 정상예시16장, 분포·혼동행렬·ROC·유형별 결과·PCA 제외영역 제공.
- HTML161개 로컬링크 검증, 브라우저 필터30조합/이미지162개/JS오류0 확인.

![[20261008_135801_anomalydino_summary.png]]

[전체160장 시각화](http://127.0.0.1:8765/output/comparisons/dinopatch_vs_anomalydino_20261008_135801/index.html)

실행 경로: E:/DH/Sandbox/Dinopatch/output/comparisons/dinopatch_vs_anomalydino_20261008_135801
코드: tools/compare_anomalydino.py, tools/report_anomalydino_comparison.py, tools/validate_anomalydino_comparison.py
공식 코드: https://github.com/dammsi/AnomalyDINO
이전 DINO 기준선: output/comparisons/pixel_fusion_no_vlm_20261007_231904
학습분할·기존 특징: output/comparisons/qwen_screw_model_fusion_20261007_221248

결정: 이번 screw에서는 AnomalyDINO 방식이 우세하다. 현재 dinopatch 기본값을 즉시 교체하지 않고, 점수집계·PCA의 가벼운 조합부터 후속검증한다. 원본과 이전실험 유지. 기록만 저장, 즉시 Git push 하지 않음.

- `run.json` SHA256 `1608c1b3ad57c0faeb0fe125a625c2c45aae4125591517c5a79549825fcc1c25`
- `predictions/metrics.json` SHA256 `ded867ac2436e673716a2ae97244b3c372ba1ec051b65c3ad01d98816a02b724`
- `logs/validation.json` SHA256 `1cf8c18b324d32451ce9a968a1a7ad5c9179d929542308fcef7d7bc791f2bb7b`