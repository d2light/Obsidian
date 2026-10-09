# 공식 INP-Former screw 결과

- 질문: 공식 기본 INP-Former가 screw의 미탐과 오탐을 개선하는가?
- 변경: 공식 main() 및 모델/손실/optimizer 사용, ++ 아님. commit 17d265381d9b323a2ef6e05aab0665a85edebe84.
- 데이터: 정상 FIT256/CAL64, 원본 test160(OK41/NG119), 원본 보존 및 480파일 해시/분할 검증.
- 설정: DINOv2-B reg4, Resize448/Crop392, INP6, seed1, 200epoch 마지막 가중치, batch16, FP32.
- 전처리: 학습/보정/검사 동일 중앙크롭. 외곽 미검사영역을 회색으로 표시. 배경 제거 없음.
- 측정: 정확도 91.875%, 영상 AUROC 98.381%, FP3/FN10, 재현율 91.597%. 크롭256 픽셀 AUROC 99.623%.
- 임계값: 정상 CAL q95 higher 0.156613603, strict > NG, test로 선택 안 함.
- GPU시간: 단일영상 forward+맵/점수 중앙값 26.56ms, p95 27.07ms. CPU입출력 제외.
- 한계: FIT320 논문조건과 다름. 반복 관찰한 개발test/단일 seed/단일 screw, 중앙크롭 및 버전차이 존재. 크롭 후 GT없는 NG []. 공식 F1_max는 test oracle 설명값이며 운영 임계값이 아님.
- 검증: 모델 저장/재로딩 smoke, 점수/크롭 투영 test, 수치/파일/HTML 링크 검증. headless브라우저 필터15조합/전체이미지로딩 확인(logs/browser_validation.json).
- 결정/다음: 원본 모델 보존, 자동 배포 없음. 오류 사례 검토 후 ++ 추가 여부 결정.
- 출처: https://github.com/luow23/INP-Former ; E:\DH\Sandbox\Dinopatch\output\experiments\DinoPatch_20261008_233945_INPFormer_screw_official_B392_fit256_cal64
- 코드: E:/DH/Sandbox/Dinopatch/tools/train_inp_official.py, tools/report_inp_official.py
- 분할 SHA256: cf1174375a89bc34fd6e3eaf5a6c9290460ca123f623521a1836be5d87ed4af1
- 결과 SHA256: b6c73fe69f4cb178e83190a8cb142a077ac81e373cf5e764af3e55981a9024b9

![[../첨부/20261009_001342_inp_summary.png]]
