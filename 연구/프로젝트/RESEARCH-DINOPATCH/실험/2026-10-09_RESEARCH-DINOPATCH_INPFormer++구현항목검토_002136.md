# INP-Former++ 구현 항목 검토

질문: 현재 공식 기본형에서 ++를 어떻게 구현하는가? 신규 구현·학습은 아직 하지 않았다.

원문 v2 III-B/D/E 및 IV-A3 확인. 이전 설명의 soft coherence와 residual head 외에도 cosine+MSE soft mining 및 학습률 차이가 있으므로 head만 붙인 모델을 전체 ++ 재현으로 명명하면 안 된다.

구현 대응:
- models/uad.py gather_loss: 최근접 프로토타입 거리 대신 cosine softmax 가중조합 재구성 + flattened global cosine 손실(식3).
- utils.py global_cosine_hm_adaptive: cosine 및 MSE 두 branch의 soft mining gradient(식5). 두 가중치가 다른데 동일 tensor에 hook 두 개를 누적시키지 않도록 분리 필요.
- residual: 그룹별 (1-cos)*abs(encoder-decoder)를 평균(식7), detach 후 segmentation head. 합성NG 경로의 gradient가 정상 재구성 모델에 유입되지 않는지 검증.
- head: 전치합성곱2개+합성곱1개, Dice loss. 미공개 채널/커널/stride는 재현 가정으로 기록.
- Perlin+DTD 정상훈련 이미지 합성NG/mask 사용. 실제 testNG 사용 안 함. 실제NG를 쓰는 semi-supervised는 별도 분할·실험.
- 추론: cosine 거리와 L2 거리의 평균 기반 재구성맵을 head맵과 1:1 평균(식9), 최종 top1% 영상점수. 임의 minmax 정규화를 추가하지 않고 논문식과 재현 가정을 구분.
- 기본 설정: DINOv2-R B14, 6 INP, decoder8, 448→392, gamma3/lambda0.2, StableAdamW lr5e-4/wd1e-4/200epoch. 기본 공식 코드 lr1e-3와 차이.

권장 검증: 기존 기본형 보존 → 정상모델 손실변경 → 합성NG 잔차head 추가 순으로 분리. 두 단계 학습은 저자가 가능한 대안으로 허용한 구현 선택이며, 논문의 stop-gradient end-to-end와 구분한다. 저자 issue53의 head100epoch 언급과 논문200epoch를 단일 확정 스케줄로 합치지 않는다.

출처: https://arxiv.org/html/2506.03660v2 ; https://github.com/luow23/INP-Former/issues/53
로컬 기본형: E:/DH/Sandbox/Dinopatch/references/INP-Former ; tools/train_inp_official.py
기존 결과: output/experiments/DinoPatch_20261008_233945_INPFormer_screw_official_B392_fit256_cal64
신규 측정/이미지 없음. 다음: 구현 지시 시 재현 가정과 ablation 조건을 고정하고 실제 학습·검증.
