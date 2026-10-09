# 공식 INP-Former screw 학습 시작

- 사용자 승인: 공식 코드로 screw 기준 성능 확인.
- 모델: INP-Former 기본형, ++ 아님. 공식 commit17d265381d9b323a2ef6e05aab0665a85edebe84; vendor 무수정 main() 호출.
- 데이터: 기존 FIT256 정상/CAL64 정상/원본 TEST160(OK41 NG119), 480개 해시 중복 없음. 원본 변경 없음.
- 설정: DINOv2-B reg4, Resize448/Crop392, INP6, batch16, seed1, FP32, 200epoch 최종 가중치. StableAdamW/loss/LR 등 공식 main 유지. Windows persistent workers 사용, 진단용 CUDA_LAUNCH_BLOCKING 미설정.
- 전처리: 공식 중앙크롭, 외곽 6.25%씩 미검사. 결과 시각화에 coverage 표시 예정. 정상 CAL q95 higher strict > 임계값, test 기반 선택 없음.
- 사전 검증: 1epoch smoke optimizer/저장재로딩 일치 통과. GPU 최대할당7.459GiB, smoke 모델 동작20.02초(본학습 시간 아님). crop투영 및 top1% 집계 test2개 통과.
- 현재: 200epoch 본학습 PID19588 실행. 최종 성능 미측정. standalone 모델/맵/보고서 검증 및 오류유형 분석 예정.
- 한계: 논문 FIT320과 다름, 현재 의존성 버전, 단일 screw/seed 및 반복 관찰된 개발평가. 공식 test F1max와 CAL판정 혼용 금지.
- 출력: E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261008_233945_INPFormer_screw_official_B392_fit256_cal64
- 코드: tools/train_inp_official.py, tools/report_inp_official.py; references/INP-Former
- split SHA256: cf1174375a89bc34fd6e3eaf5a6c9290460ca123f623521a1836be5d87ed4af1
- 출처: https://github.com/luow23/INP-Former
