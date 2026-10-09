# INP++ 정상 모델만 screw 결과

- 질문: 공식 기본 INP-Former가 screw의 미탐과 오탐을 개선하는가?
- 변경: INP++ normal modeling ablation. 기반 commit 17d265381d9b323a2ef6e05aab0665a85edebe84. 변경/재현 가정: Paper-based ++, not official ++ release. FIT256/CAL64 vs full320. Separate normal200/head100 training (author permitted), not joint training. Official group means retained (paper uses sum notation). Current dependencies; head details and synthesis settings below are assumptions.
- 데이터: 정상 FIT256/CAL64, 원본 test160(OK41/NG119), 원본 보존 및 480파일 해시/분할 검증.
- 설정: DINOv2-B reg4, Resize448/Crop392, INP6, seed1, 정상200epoch/분할0epoch 마지막 가중치, batch16, FP32. 추가설정 {'head': '768->256->64->1, ConvTranspose4/s2/p1 x2 + ReLU; Conv3/s1/p1; sigmoid', 'normal_optimizer': 'StableAdamW lr5e-4/wd1e-4; official warmup100 steps and cosine final1e-4 retained', 'head_optimizer': 'StableAdamW lr5e-4/wd1e-4, constant LR100 epochs, no test selection', 'synthesis': 'Perlin448 grid powers1..32 -> rotate[-90,90] threshold.5 -> center392, nonempty; DTD resize448 crop392 flip/color jitter; normal mixing beta U[0,.8]; no foreground restriction; no real NG', 'mse': 'Eq5 channel-summed squared error, mean batch/spatial/group; separate gradient weights cos/MSE; gamma3, coherence weight.2', 'segmentation': 'Dice on sigmoid logits bilinear392; eps1e-6. All samples synthetic with nonempty mask; no empty-mask gradient ambiguity', 'image_scoring': 'Paper top1% at392 unlike official basic evaluator resize256+Gaussian; ablation/full both same392 scoring'}.
- 전처리: 학습/보정/검사 동일 중앙크롭. 외곽 미검사영역을 회색으로 표시. 배경 제거 없음.
- 측정: 정확도 95.000%, 영상 AUROC 99.242%, FP2/FN6, 재현율 94.958%. 크롭392 픽셀 AUROC 99.664%.
- 임계값: 정상 CAL q95 higher 2.079414368, strict > NG, test로 선택 안 함.
- GPU시간: 단일영상 forward+맵/점수 중앙값 26.57ms, p95 27.16ms. CPU입출력 제외.
- 한계: FIT320 논문조건과 다름. 반복 관찰한 개발test/단일 seed/단일 screw, 중앙크롭 및 버전차이 존재. 크롭 후 GT없는 NG []. 공식 F1_max는 test oracle 설명값이며 운영 임계값이 아님.
- 검증: 모델 저장/재로딩 smoke, 점수/크롭 투영 test, 수치/파일/HTML 링크 검증. headless브라우저 필터15조합/전체이미지로딩 확인(logs/browser_validation.json).
- 결정/다음: 원본 모델 보존, 자동 배포 없음. 오류 사례와 단계별 차이를 검토해 후속 실험 결정.
- 출처: https://github.com/luow23/INP-Former ; E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261009_010357_INPFormerPP_normal_only_screw_B392_fit256_cal64
- 코드: E:/DH/Sandbox/Dinopatch/tools/train_inp_official.py, tools/report_inp_official.py. ++일 때 tools/train_inp_plus.py 및 logs/plus_source.py 참조.
- 분할 SHA256: cf1174375a89bc34fd6e3eaf5a6c9290460ca123f623521a1836be5d87ed4af1
- 결과 SHA256: ec4d67238bb7501ccebd0f9ea2eac95f4248b387b08f5cd482908ff4b51a12f1

![[../첨부/20261009_010555_inp_summary.png]]
