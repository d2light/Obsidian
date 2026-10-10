# 밝은 정상만으로 조도 변화에 대응하기 위한 레퍼런스 검토

질문: 실제 밝은 정상만 FIT/CAL에 사용하고 실제 어두운 이미지는 평가에만 사용하는 목표에 참고할 논문은 무엇인가?

상태: 문헌 검토만 수행. 모델·전처리·분할 변경, 신규 학습/추론, 유료 API 호출 없음. 논문 성능을 우리 워터씰 성능으로 환산하지 않았다.

## 우선 참고

1. **Anomaly Detection Under Distribution Shift — GNL, ICCV2023**, Tri Cao, Jiawen Zhu, Guansong Pang.
   - 정상 source만 학습하고 distribution-shifted target은 추론에서 관찰하는 문제 설정이다.
   - RD4AD 기반 DINL은 원본 정상과 증강 정상의 bottleneck 및 decoder 마지막 블록 표현에 유사도 손실을 적용한다.
   - 별도 ATTA는 추론 시 학습 정상 예시의 특징 분포를 검사 특징에 섞는 기능이다. DINL 단독과 전체 GNL을 혼동하지 않는다. 이는 target 정상 별도학습을 요구하는 RoDA와도 다르다.
   - 우리에게는 DINL의 표현 일관성 아이디어를 Dinomaly의 학습 가능한 부분에 응용하는 것이 우선 후보라는 판단이다. Dinomaly 적용은 새 실험이며 공식 GNL의 직접 재현이라고 부를 수 없다.
   - [논문](https://openaccess.thecvf.com/content/ICCV2023/html/Cao_Anomaly_Detection_Under_Distribution_Shift_ICCV_2023_paper.html), [arXiv](https://arxiv.org/abs/2303.13845), [공식 코드](https://github.com/mala-lab/ADShift).
   - 검증: 공식 CVF 초록·공식 코드 README, arXiv PDF 실제 다운로드 후4.1/4.2 방법 절 확인. 단일 정상 도메인/증강/추론 처리 구분을 확인했다.

2. **The MVTec AD 2 Dataset: Advanced Scenarios for Unsupervised Anomaly Detection — preprint2025 / IJCV2026**.
   - 모델이 아니라 평가 설계의 직접 근거. TRAIN은 regular lighting만 사용하고 TEST에는 학습에서 없던 밝음/어두움 및 물체별 조명 변화가 들어간다.
   - 밝기 변화에는 실제 노출 시간 조절이 사용되고 일부 카테고리는 추가 광원/반사/불균일 조명 등이 있다. 우리 기존 MVTec AD 평가와 다른 데이터셋이다.
   - 워터씰의 연구 질문을 산업 벤치마크로 확장하기에 적합하다는 판단. 데이터를 다운로드하거나 실험한 것은 아니다.
   - [논문](https://link.springer.com/article/10.1007/s11263-026-02743-0), [원 preprint](https://arxiv.org/abs/2503.21622), [공식 데이터](https://www.mvtec.com/company/research/datasets/mvtec-ad-2).
   - 검증: 저널 본문의3.2/3.3 train/test 설계 및 공식 preprint 설명 확인.

3. **PIAD: Pose and Illumination agnostic Anomaly Detection — CVPR2025**.
   - 조명과 pose가 바뀐 검사 영상을 비교하기 위해 사전학습 URetinexNet 기반 reflectance 분해, RGB/reflectance 3D Gaussian Splatting 표현, pose 정합, photometric/deep-feature 비교를 사용한다.
   - 조명 성분과 물체 성분을 구분하는 아이디어의 참고이다. 전체방법은 정상 다중시점/카메라 pose를 사용하며 현재 고정 카메라 단일시점 워터씰에 그대로 적용되는 전처리가 아니다. 사전학습 분해 모델 의존성도 명시해야 한다.
   - [저자 프로젝트](https://kaichen-yang.github.io/piad/), [공식 PDF](https://openaccess.thecvf.com/content/CVPR2025/papers/Yang_PIAD_Pose_and_Illumination_agnostic_Anomaly_Detection_CVPR_2025_paper.pdf).
   - 검증: 저자 프로젝트·CVF PDF 실제 다운로드 후3.1 및 train/query 설정 확인. 웹 도구 PDF403은 별도 로컬 HTTP 읽기로 보완했다.

4. **Enhancing Illumination Robustness in Unified Anomaly Detection via Multi-Brightness Training — ICEIC2026**, Geonwoo Kim, Sukju Kang.
   - 여러 밝기의 증강 입력으로 unified AD의 조명 변화 일반화를 학습하자는 직접적으로 가까운 전략이다.
   - [저자 연구실 발표 목록](https://vds.sogang.ac.kr/?p=2234), [공개 PDF 주소](https://www.iceic.org/FileDownload?filecode=papers&filename=1571231274.pdf&filename2=1571231274.pdf).
   - 검증 한계: 공개 PDF 검색에 색인된 본문과 저자 연구실의2026년1월 학회 정보를 확인했다. 직접 PDF 요청은500으로 실패했고 구체적인 수치 실험표를 확인하지 못했다. 개선폭/검증 강도를 추정하지 않는다. 아이디어 보조 참고로 취급하고 핵심 성능 증거로 사용하지 않는다.

## 현재 제약과 구분할 연구

- [Unsupervised industrial anomaly detection using paired well-lit and low-light images, JCDE2025](https://academic.oup.com/jcde/article/12/5/41/8119431): 밝은/어두운 쌍 데이터를 사용하는 주 설정이다. 제목이 가까워도 실제 어두운 학습 데이터0이라는 현재 조건의 직접 증거로 삼지 않는다.
- [Robust Distribution Alignment for Industrial Anomaly Detection under Distribution Shift — RoDA, arXiv2025](https://arxiv.org/html/2503.14910v1): 소량 target adaptation 데이터로 memory bank와 분포를 정렬한다. target은 unlabeled여도 사용한 것이므로 밝은 source만 학습하고 target 적응도 하지 않는 설정과 구분한다. 본문3.1에서 target train/test 분리와 적응 단계 확인.

## 결정과 다음 단계

방법론 중심은 GNL의 DINL, 평가 프로토콜 중심은 MVTec AD2, 물리적 정규화 아이디어는 PIAD를 우선 참고한다. 단순 조도 증강과 표현 일관성 손실을 분리해 비교하는 Dinomaly 실험을 제안한다. 구현/성능은 아직 없다. RGB 자체 증강만으로 모든 실제 조도·반사·노이즈 변화가 포괄된다고 주장하지 않는다. TEST 정답으로 증강 강도/임계값을 맞추지 않고 밝은 CAL의 원본/파생본 역할을 분리한다. 이미 관찰한 워터씰은 개발 평가이며 독립 일반화 근거는 추가 평가에서 확보해야 한다.

기존 결과와 연결: `E:/DH/Sandbox/Dinopatch/output/comparisons/waterseal_dinomaly_scores_20261009_214051/summary.json`, `tools/field_model_comparison.py`.

![[워터씰_Dinomaly_원점수_20261009_214051.jpg]]
