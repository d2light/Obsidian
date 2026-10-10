# 조도 대안 종합 비교: 실행 계획

## 질문·사용자 목표
밝은 정상만으로 실제 어두운 검사 영상까지 다루기 위해 참고 가능한 복원 모델과 전통 기법을 넓게 비교한다. 모든 환경100% 보장은 검증 목표로 주장하지 않는다. 기존 Dinomaly는 RGB 밝은 사진 복원이 아니라 특징 재구성이며, 이전 일관성 실험도 특징 수준의 실험이었다.

## 범위·고정 조건
실제 bright FIT224/CAL85, 원본 TEST268(bright OK134/NG70, dark OK51/NG13). 기존 split 및 원본 SHA 유지, 실제 dark 학습·CAL 제외. 중심87.5% 시야, 입력448→crop392. 각 방법 CAL q95 higher, strict >. TEST를 보고 임계값/방법별 파라미터를 조정하지 않는다. 이미 관찰한 개발 TEST라 최종 선택은 새로운 촬영 그룹에서 확인해야 한다.

## 23개 신규 조건
- 픽셀 보정9종: FIT 기준 gain, gamma, histogram, CLAHE, 다중스케일 Retinex, 기존 국소 나눗셈, homomorphic, 공식 Zero-DCE, 공식 Retinexformer LOL-v1.
- 특징 보정2종: FIT 평균/표준편차 AdaIN, FIT 평균 순위분포 EFDM. 특수 토큰 유지, DINO 추출 특징을 정상 기준 분포로 옮긴 후 원래 bottleneck/decoder로 점수화. GNL-inspired 변형이며 공식 GNL 재현이 아님.
- 점수 보정3종: top1%−median, MAD 표준화, FIT에서 찾은 물체 띠 영역 top1%−median. 국소 이상과 넓은 변화 분리 가설이며 넓은 결함을 지울 위험도 검사.
- 전통 검사3종: 국소 대비 정규화 정상 템플릿, 위 방식+제한된 평행이동 정합, 적응형 Canny/Scharr 윤곽 두께·위치 잔차. 추출/정합 실패는 REVIEW이며 정상 판정 아님. 전체 score-only 지표에 포함하고 REVIEW 수 별도 보고.
- 정상 특징은행6종: raw, gain, CLAHE, MSR, Zero-DCE, Retinexformer를 FIT/CAL/TEST에 동일 적용해 새 DINO 특징은행 구성. FIT마다16패치, seed1, cosine nearest-neighbor. 기존 Dinomaly 재학습과 구분.

## 공정성·제약
픽셀 보정+기존 Dinomaly는 raw로 학습한 고정 모델에 대한 추론 시 적응 시험이다. 이를 보정 후 재학습 성능으로 부르지 않는다. 특징은행 조건에서는 보정 후 FIT 기준을 새로 구성하여 해당 불일치를 별도 비교한다. 공식 복원 모델은 외부 데이터로 사전학습했으며 현장 bright-only 학습 모델이라고 부르지 않는다. 공식 pretrained weights/commit/hash 기록, 산업 영상 외부 전송 없음. 정답 위치 GT가 없어 map은 진단용이며 픽셀 성능을 계산하지 않는다.

## 검증·저장
흑색/상수 입력의 유한성, 원본 불변, 감광의 정상 gain 복원, 특징 보정의 특수 토큰/공간 순위 보존, 윤곽 실패 REVIEW 검사 통과. 공식 두 복원기 가중치 로딩/forward 확인. 기존 detector native map/score 재현 검사 후 전체 실행. 원본 복사0, 대용량 결과D:/research_artifacts/Dinopatch, 가중치 중복 대신 참조+해시, native NPY/JPG 유지. 예상 peak10GiB/final7GiB, 여유10GiB+125%headroom 확인. 현재 결과 미완료.

## 성공 기준·다음
원본 TEST 전체/밝음/어두움 AUROC, FP/FN, REVIEW, 보정 영상/이상맵/분포를 함께 비교한다. 오탐이 줄어도 NG 점수가 지워지면 채택하지 않는다. 실패 결과도 기록하고, 효과가 확인된 단계만 이후 결합 후보로 남긴다. 이번 실행은 워터씰 개발 비교이며 타 카테고리 일반화를 뜻하지 않는다.

## 출처
- E:/DH/Sandbox/Dinopatch/output/comparisons/illumination_screen_20261010_003838
- tools/screen_illumination_methods.py
- tools/field_model_comparison.py
- references/illumination_20261010/sources.json
- https://github.com/Li-Chongyi/Zero-DCE
- https://github.com/caiyuanhao1998/Retinexformer
- https://github.com/mala-lab/ADShift
