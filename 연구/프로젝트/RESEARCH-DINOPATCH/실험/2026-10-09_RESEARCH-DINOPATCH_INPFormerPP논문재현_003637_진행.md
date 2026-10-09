# INP-Former++ 논문 기반 재현 진행

- 질문: 기본 INP의 screw 미탐10/오탐3을 개선하는가? 사용자 구현·실험 승인.
- 기준: 기본형 accuracy91.875/I-AUROC98.381, FP3/FN10, output/experiments/DinoPatch_20261008_233945_INPFormer_screw_official_B392_fit256_cal64.
- 변경: 공식 기본 core에 soft coherence(Eq3), cosine+MSE 독립 gradient soft mining(Eq5), stop-gradient residual(Eq7), Dice head(Eq8), fusion(Eq9) 구현. 공식 ++ 코드라고 부르지 않음.
- 데이터: 기존 정상 FIT256/CAL64/원본 TEST160(OK41/NG119). 실제NG는 학습에 넣지 않음. DTD5640 텍스처+Perlin 마스크 합성. 원본 보존.
- 설정: DINOv2-R B14/INP6/decoder8/448→392, seed1/FP32/batch16, 정상200epoch lr5e-4; 모델 고정 후 head100epoch seed2/lr5e-4. 저자가 허용한 2단계 대안이며 논문 end-to-end와 구분.
- 미공개 가정: head768→256→64→1(transposeConv4/s2/p1×2+ReLU,Conv3), beta U[0,.8], Perlin448 powers1..32/rotate±90/threshold.5, DTD 색변형, 전경 제한 없음. 공식 feature group mean 유지(논문 sum 표기와 구분), 기존 warmup100step/cosine final1e-4. MSE는 채널 제곱합의 공간/배치 평균. 상세 run.json.
- 점수: cosine+L2 재구성맵과 sigmoid head 평균, 392맵 top1%; 임의minmax/Gaussian 추가 없음. 정상모델 단독도 동일392 재구성맵으로 ablation. 기본형의256/Gaussian과 조건 차이도 포함된 구성 비교.
- 임계값: 각 모델 정상CAL64 q95 higher strict>, TEST로 선택/튜닝 안 함. normal-only 결과와 무관하게 미리 정한 head100 진행.
- 검증: 수식·gradient tests3, 기존crop/score tests2 통과. 실제 GPU smoke normal1epoch/head1step 통과. head전후 정상모델hash동일/정상gradient없음/저장재로드일치. 최대할당7.348GiB. smoke손실은 성능으로 해석하지 않음.
- 현재: 본학습 PID74576 시작, 최종 수치 대기. 결과·이상맵160장·FP/FN 및 독립파일/브라우저검증 예정.
- 경로: E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261009_003240_INPFormerPP_full_screw_B392_fit256_cal64
- 코드: tools/train_inp_plus.py, tools/train_inp_official.py, tools/report_inp_official.py, tests/test_inp_plus.py.
- split SHA256: cf1174375a89bc34fd6e3eaf5a6c9290460ca123f623521a1836be5d87ed4af1
- source SHA256: 03ff27c63e550059ce4e58aaf499c0b648629bb189e3a80faecbab4a2c598cf0
- 출처: https://arxiv.org/html/2506.03660v2 ; https://github.com/luow23/INP-Former/issues/53
- 한계/다음: 단일 범주/seed, 여러번 본 개발평가, 원논문과 일부세부 가정 차이. 성공/실패 모두 남기고 기여 확인 후 다음 결정. 자동 배포 없음.
