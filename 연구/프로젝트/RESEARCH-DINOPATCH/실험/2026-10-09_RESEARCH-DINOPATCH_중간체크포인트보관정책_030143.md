# 중간 체크포인트 보관 정책 변경

- 질문: 실험 산출물 2.15GiB의 원인과 다른 progress 파일 규모는?
- 사용자 결정: 최종 모델 재로드·평가·보고서 검증 완료 후 중복 progress를 정리한다. 학습 중에는 최신 1개 유지.
- 조사 범위: 프로젝트 output 및 D:/research_artifacts/Dinopatch. Junction 중복 제외. 스캔 시점의 스냅샷이며 실행 중 신규 파일은 이후 증가 가능.
- 확인: pt/pth/ckpt 119개 42.1342GiB. progress 이름 포함 6개 4.8811GiB. Dinomaly 3개 3.7126GiB, INP 계열 3개 약1.1685GiB.
- 변경: AGENTS.md, docs/OUTPUT_STORAGE_POLICY.md, tools/experiment_artifacts.py의 완료 처리에 Dinomaly progress 정리 추가. 최종 파일 해시·재로드·평가·브라우저 검증을 요구하고 삭제 파일 해시/용량/시각을 기록하며 manifest 갱신.
- 검증: 임시 파일 기반으로 진행 중 보존, 최종 해시 불일치 거부, 완료 상태 삭제 및 manifest 갱신, 재실행 무해성 확인. Python syntax check 통과.
- 데이터/설정: 학습 데이터·FIT/CAL/TEST 분할·점수·임계값 변경 없음. 원본과 수치 이상맵 보존. 최종 가중치 보존.
- 한계: INP progress는 이 작업에서 자동 삭제하지 않음. 특징은행은 추론 필수일 수 있어 이름만으로 삭제하지 않음. 신규 정책은 일단 Dinomaly 완료 처리에 구현됨.
- 진행: cable 완료 경계에서 runner를 정상 종료하고 capsule부터 새 정책으로 재시작. 이전 완료 3종은 독립 검증 후 정리 작업 중; 실제 삭제 결과는 output/checkpoint_cleanup_20261009.json 및 run별 logs/checkpoint_cleanup.json 확인.
- 출처: E:/DH/Sandbox/Dinopatch/output/checkpoint_audit_20261009.json, tools/experiment_artifacts.py, tools/train_dinomaly_isolated.py.
- 다음: 삭제 완료 용량 확인. 나머지 MVTec 학습 유지. 전체 가중치/특징은행은 용도별로 검토 후 정리.

## 가중치 경량화 검토
- bottle 최종 detector.pt를 torch.load(weights_only=True, mmap=True)로 확인: 파일591,995,074바이트. tensor전부FP32.
- encoder346,334,208바이트(330.29MiB), bottleneck18,874,368바이트, decoder226,689,024바이트, blur100바이트. 백본 제외 합계234.19MiB.
- 백본이 동일함을 텐서/해시로 검증 후 공통 파일 하나로 분리하는 것이 우선. 수치 변경 없는 저장 중복 제거이나 로더·배포 묶음 수정과 동일 출력 검증 필요. 아직 구현하지 않음.
- 15개 동일 구조 모델 예상 텐서 저장량: 전체 저장8.27GiB → 공통 백본+개별 학습부3.75GiB. 동일 백본 전제이며 파일 헤더 제외 계산치.
- FP16/INT8은 더 줄일 수 있으나 score와 임계값 영향 검증 및 정상 CAL 재보정 필요. 특징은행의 단순 제거는 모델 변경이므로 구분.
- 추가 전체 validator 재실행은 I/O 지연으로 중단. 기존 완료 검증 기록에 더해 이번 삭제 직전에 최종 모델 SHA256을 재확인하는 절차로 진행. screw 삭제 완료 확인; 나머지는 별도 삭제 로그 확인 필요.

## 정리 완료 확인
- screw/bottle/cable progress3개 삭제 완료: 3,986,349,856바이트(3.7126GiB), D: 공간 확보. 최종 모델 존재·progress 부재·manifest 삭제 항목과 정리 로그 해시 확인.
- 출처: output/checkpoint_cleanup_20261009.json. 나머지 카테고리 학습은 새 정책으로 계속.
