# Dinomaly 15종 분리 학습 시작

- 질문: 검증/test 공유 없이 정상 FIT/CAL을 분리하면 15종 성능은 어떠한가?
- 승인: 전체 카테고리 학습·예측 사용자 요청.
- 변경: anomalib2.5.0 Dinomaly를 새로 초기화. 고정 pretrained encoder, 학습 가능한 bottleneck/decoder. 원래 모델 loss/optimizer 사용, 명시적 per-step warmup/cosine. no validation loader/postprocessor/test checkpoint selection.
- 데이터: datasets/mvtec 15종. 정상 hash-group별80/20 FIT/CAL(seed1); screw 기존FIT256/CAL64 및 TEST160 재사용. TEST는 원본 전체, 원본 수정 없음. 해시 역할 간 중복 검사.
- 설정: final100epoch, batch8, FP32, seed1, Resize448/CenterCrop392/ImageNet. lr2e-3→2e-4, warmup100step, StableAdamW, clip0.1. CAL q95 higher 초과NG. 마지막 가중치만 평가.
- 점수: native392재구성맵 표시; image score는 native256resize/Gaussian5 sigma4/top1%. 픽셀AUROC는392크롭내부. 원해상도맵+coverage 저장, 미검사 영역 회색.
- 사전 검증: 2개 프로토콜 테스트 통과(해시중복 분리/고정CAL임계값), GPU1step smoke loss1.019909, peak4.122GiB. encoder변화/gradient없음, 저장재로딩 score/map 완전 일치. 이 loss는 성능수치가 아님.
- 저장: E: 여유약12GB로 부족 우려. 신규 run은 D:/research_artifacts/Dinopatch에 보관, output/experiments의 junction으로 기존 URL 유지. 기존 데이터·실험 삭제 없음.
- 상태: 전체 학습 실행 시작, 결과 아직 미측정. PID71504, suite E:\DH\Sandbox\Dinopatch\output\comparisons\dinomaly_isolated_20261009_021035.
- 로그: output/dinomaly_isolated_20261009_021033_stdout.log 및 stderr.log.
- 소스: tools/train_dinomaly_isolated.py, tools/report_dinomaly_isolated.py, tests/test_dinomaly_isolated.py; 각 run에 설치모델 소스/환경/hash 복사.
- 한계: 과거fulltrain과 학습량/스케줄 차이가 있어서 결과 차이를 leakage 효과로 단정하지 않음. 반복 관찰된 개발test. 본 학습 실패시 실패조건 기록하고 기존 가중치는 보존.
- 다음: 카테고리별 마지막 모델 평가→브라우저/산출물 검증→연구노트→15종 비교. 자동 배포/즉시 git push 없음.
