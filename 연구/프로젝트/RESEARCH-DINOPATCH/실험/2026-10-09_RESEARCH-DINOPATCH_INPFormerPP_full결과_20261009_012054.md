# INP-Former++ (논문 기반 재현) screw 결과

- 질문: INP-Former++ 논문 기반 재현과 분할 모듈 추가가 공식 기본형보다 screw 판정과 결함 위치 추정을 개선하는가?
- 변경: INP-Former++ paper reproduction. 기반 commit 17d265381d9b323a2ef6e05aab0665a85edebe84. 변경/재현 가정: Paper-based ++, not official ++ release. FIT256/CAL64 vs full320. Separate normal200/head100 training (author permitted), not joint training. Official group means retained (paper uses sum notation). Current dependencies; head details and synthesis settings below are assumptions.
- 데이터: 정상 FIT256/CAL64, 원본 test160(OK41/NG119), 원본 보존 및 480파일 해시/분할 검증.
- 설정: DINOv2-B reg4, Resize448/Crop392, INP6, seed1, 정상200epoch/분할100epoch 마지막 가중치, batch16, FP32. 추가설정 {'head': '768->256->64->1, ConvTranspose4/s2/p1 x2 + ReLU; Conv3/s1/p1; sigmoid', 'normal_optimizer': 'StableAdamW lr5e-4/wd1e-4; official warmup100 steps and cosine final1e-4 retained', 'head_optimizer': 'StableAdamW lr5e-4/wd1e-4, constant LR100 epochs, no test selection', 'synthesis': 'Perlin448 grid powers1..32 -> rotate[-90,90] threshold.5 -> center392, nonempty; DTD resize448 crop392 flip/color jitter; normal mixing beta U[0,.8]; no foreground restriction; no real NG', 'mse': 'Eq5 channel-summed squared error, mean batch/spatial/group; separate gradient weights cos/MSE; gamma3, coherence weight.2', 'segmentation': 'Dice on sigmoid logits bilinear392; eps1e-6. All samples synthetic with nonempty mask; no empty-mask gradient ambiguity', 'image_scoring': 'Paper top1% at392 unlike official basic evaluator resize256+Gaussian; ablation/full both same392 scoring'}.
- 전처리: 학습/보정/검사 동일 중앙크롭. 외곽 미검사영역을 회색으로 표시. 배경 제거 없음.
- 측정: 정확도 95.000%, 영상 AUROC 99.119%, FP2/FN6, 재현율 94.958%. 크롭392 픽셀 AUROC 99.684%.
- 임계값: 정상 CAL q95 higher 1.065939307, strict > NG, test로 선택 안 함.
- GPU시간: 단일영상 forward+맵/점수 중앙값 27.23ms, p95 27.95ms. CPU입출력 제외.
- 한계: FIT320 논문조건과 다름. 반복 관찰한 개발test/단일 seed/단일 screw, 중앙크롭 및 버전차이 존재. 크롭 후 GT없는 NG []. 공식 F1_max는 test oracle 설명값이며 운영 임계값이 아님.
- 검증: 모델 저장/재로딩 smoke, 점수/크롭 투영 test, 수치/파일/HTML 링크 검증. headless브라우저 필터15조합/전체이미지로딩 확인(logs/browser_validation.json).
- 결정/다음: 원본 모델 보존, 자동 배포 없음. 오류 사례와 단계별 차이를 검토해 후속 실험 결정.
- 출처: https://github.com/luow23/INP-Former ; E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261009_003240_INPFormerPP_full_screw_B392_fit256_cal64
- 코드: E:/DH/Sandbox/Dinopatch/tools/train_inp_official.py, tools/report_inp_official.py. ++일 때 tools/train_inp_plus.py 및 logs/plus_source.py 참조.
- 분할 SHA256: cf1174375a89bc34fd6e3eaf5a6c9290460ca123f623521a1836be5d87ed4af1
- 결과 SHA256: 34a3a76b3c9e8f1fe75612e622c9f4a8da3e812f31d4a9acd2d12ebecbd063f8

![[../첨부/20261009_012054_inp_summary.png]]

## 단계별 비교 및 최종 판단

| 구성 | 정확도(%) | 영상 AUROC(%) | 오탐 | 미탐 |
|---|---:|---:|---:|---:|
| 공식 기본 INP-Former | 91.875 | 98.381 | 3 | 10 |
| ++ 정상 모델·재구성 점수 | 95.000 | 99.242 | 2 | 6 |
| ++ 분할 모듈 포함 | 95.000 | 99.119 | 2 | 6 |

- 정상 모델 단계에서는 손실뿐 아니라 학습률, 점수 공식, 점수 맵 해상도와 평활화도 바뀌었다. 개선을 한 요소의 효과로 단정하지 않는다.
- 정상 모델과 전체 ++의 판정은 같은 160장 모두 동일하다. 분할 모듈로 추가 검출 이득은 없었으며 영상 AUROC는 0.123%p 낮아졌다.
- 같은 392 해상도에서 픽셀 AP는 61.977% → 67.349%, 픽셀 AUROC는 99.664% → 99.684%. 분할 모듈은 이번 실험에서 위치 추정 지표를 개선했다.
- 오탐: Q002, Q125. 미탐: Q016/Q062/Q065/Q160(manipulated_front), Q028(thread_side), Q109(scratch_neck).
- 기본형 대비 기존 미탐 5장을 수정했으나 Q062가 새 미탐이 되어 순감소 4장이다. 정상 모델 단계부터 동일하다.
- 정상 모델 동결 전후 state SHA256 일치, gradient 없음, 분할 모듈 재로딩 및 전체 묶음 재로딩 후 맵 완전 일치 확인.
- RTX5080 FP32, 단일 영상 GPU forward+맵+점수 중앙값 27.23ms/p95 27.95ms. CPU 디코딩·전처리·전송은 제외하여 전체 처리시간과 구분한다.
- 결정: 기본형 및 두 ++ 가중치 모두 보존. 영상 판정 기준으로는 분할 모듈 추가 효과가 확인되지 않았으므로 정상 모델 단계가 간결한 후보. 자동 배포나 기존 모델 대체는 하지 않았다.
- 다음: 남은 8장 오판정의 원본·이상맵을 비교하고, 다른 카테고리/독립 평가 또는 단일 요소 통제 실험에서 개선 재확인. 현재 결과는 반복 관찰한 screw 개발 평가로 일반화 증거가 아니다.
- 공식 ++ 코드가 아니라 기본 공식 코드 위의 논문 기반 재현이며 head 구조·합성 설정·분리 학습 일정에 가정이 있다.
- 논문: https://arxiv.org/html/2506.03660v2
- 시각화: http://127.0.0.1:8765/output/experiments/DinoPatch_20261009_003240_INPFormerPP_full_screw_B392_fit256_cal64/index.html
