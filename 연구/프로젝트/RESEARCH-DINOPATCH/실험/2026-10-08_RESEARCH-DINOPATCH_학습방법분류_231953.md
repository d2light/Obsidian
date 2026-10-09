# 이상탐지 학습 방법론 재분류

- 질문: 학습 방법별 모델 비교표 요청.
- 변경: 후보들을 학습 목적/추론 기준으로 재정리. 신규 실험·측정·기본 모델 변경 없음. GLASS 보류 유지.
- 데이터/분할/설정: 문헌 정리로 해당 없음. 기존 실험 점수 재비교 없음.

|방법|학습/준비|판정|예시|
|---|---|---|---|
|정상 특징 메모리|사전학습 특징 저장/선별|가장 가까운 정상 특징과 거리|PatchCore, 우리 DINO, AnomalyDINO|
|정상 통계|위치별 평균/공분산 추정|정상 분포 이탈 거리|PaDiM|
|밀도 학습|특징을 단순분포로 변환하는 신경망 학습|낮은 우도|FastFlow|
|대조 표현 학습|정상 패치 관계에 맞게 특징 공간 학습|학습한 특징의 정상 메모리 거리|ReConPatch|
|지식 증류|정상에서 학생이 교사 특징 모방|교사/학생 불일치|EfficientAD, RD4AD|
|영상 복원|정상 영상을 재구성|원본/복원 차이|AE, VAE|
|특징 복원|정상 특징을 디코더로 재구성|입력/복원 특징 차이|UniAD, Dinomaly, INP-Former|
|합성 결함 판별|영상/특징에 가짜 결함 생성하여 정상과 구별 학습|판별기 출력|DRAEM, SimpleNet, GLASS|
|사전학습 시각언어 활용|정상 사례/텍스트 제공 또는 어댑터 조정|정상/불량 텍스트 유사도나VLM판단|WinCLIP, AnomalyCLIP, 참고영상VLM|

- 분류는 배타적이지 않음. EfficientAD는 증류+AE, DRAEM은 합성+복원, RD4AD는 역증류+특징복원. Graph는 연결표현 구조로 다른 학습목적과 결합 가능, SAM은 분할 도구. DINO는 백본이며 메모리/복원 모두에 사용 가능.
- 한계: 방식별 강약은 설계상 경향이며 이 연구환경에서 검증된 카테고리별 우열이 아님. NG로 fit하지 않음과 모델선택/임계값용라벨 사용은 별도 문제.
- 결정/다음: 모델 이름보다 학습원리 구분용 표로 보존. 새 실험 시작 없음.
- 일차 출처:
  - https://github.com/amazon-science/patchcore-inspection
  - https://arxiv.org/abs/2011.08785 (PaDiM)
  - https://arxiv.org/abs/2111.07677 (FastFlow)
  - https://arxiv.org/abs/2305.16713 (ReConPatch)
  - https://arxiv.org/abs/2303.14535 (EfficientAD)
  - https://arxiv.org/abs/2405.14325 (Dinomaly)
  - https://arxiv.org/abs/2503.02424 (INP-Former)
  - https://arxiv.org/abs/2407.09359 (GLASS)
- 신규 실행 산출물/해시: 없음, 문헌분류 기록.
