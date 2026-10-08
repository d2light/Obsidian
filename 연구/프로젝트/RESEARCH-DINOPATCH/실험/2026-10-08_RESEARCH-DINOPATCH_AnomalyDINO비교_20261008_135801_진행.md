# DINO 패치 / AnomalyDINO 방식 비교 진행

질문: 같은 screw 데이터에서 어느 방식이 더 좋은가?
승인: 사용자가 두 방식의 실제 비교 요청. 코드 본체 변경 없이 별도 탐색 실험.

계획: 정상FIT256/CAL64, screw 원본test160(OK41/NG119), seed20261007. 현재 HF DINOv2 Base-registers/700/bilinear/FP16 추출을 두 방식에 공통 적용.
1. 기존 coreset30000 + CAL 픽셀정규화·clip0·3x3최댓값(기존맵 재사용)
2. 같은 coreset30000 + 공식 top1% 집계
3. 전체 정상640000패치 + top1%
4. 정상8방향 회전5120000패치 + top1%
5. 4 + 공식 PCA 검사영역 마스크(참조마스크 False 기본값)

공식 소스 commit b9d1c2648e3a5247437d4d953d907a8f3d994457. augment_image, compute_background_mask, mean_top1p 함수를 재사용. stock Small448/bicubic 논문 기본 재현은 아니다. 메모리 제한 때문에 bank를 디스크에 저장하고 GPU FP32 전수탐색, TF32 해제. FAISS 정규화 L2제곱/2와 동등한 코사인 거리인지 단위 테스트 검증.

각 조건 정상CAL 점수q95(higher) 초과시NG. 테스트 라벨로 튜닝하지 않는다. 원본/이전 실험 보존. 현 단계 최종 성능 수치 없음. 단일 범주·단일 seed 및 기존 개발 테스트 한계.

코드: tools/compare_anomalydino.py, tools/report_anomalydino_comparison.py, tests/test_compare_anomalydino.py.
실행: E:/DH/Sandbox/Dinopatch/output/comparisons/dinopatch_vs_anomalydino_20261008_135801

검증: 스트리밍 최근접 거리와 FAISS 비교, CAL 임계값의 테스트분포 독립성 2개 테스트 통과. 다음은 검색·평가·160장 이상맵 및 점수 시각화.
