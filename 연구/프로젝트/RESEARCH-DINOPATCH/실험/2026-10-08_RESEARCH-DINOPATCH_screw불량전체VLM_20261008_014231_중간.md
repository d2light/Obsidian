# screw 불량119장 VLM 비교 — 빠른 두 모델 완료, 나머지 진행 중

## 질문·변경
사용자는 기존 미탐만 골라 평가하지 말고 screw 불량 전체를 여러 VLM으로 시도하도록 요청했다. 기존 Qwen Instruct 윤곽 입력과 동일한 정상참고3장·원본Q·깨끗한확대최대2장·윤곽확대최대2장/일반프롬프트를 다른4모델에 전달. GT·불량유형은 입력하지 않음.

## 데이터·설정
원본 MVTec AD screw test NG119 전부. 정상 테스트0장. 검출기 FIT256/CAL64 기존 결과 재사용, 학습/원본 변경 없음. 출력한도8192, temperature 생략, 추론은 각 모델 기본설정. 공급자 데이터수집 deny/ZDR 유지. Qwen Thinking Novita BF16, Kimi Fireworks. Claude Sonnet5.5와 Gemini3.8 Flash는 최초 지정 공급자에서 ZDR404 후 Google Vertex로 변경. 네 모델 동등 계산량 비교는 아니며 기존 Instruct3000토큰/temperature0 결과는 과거대조.

## 완료된 측정
|모델|NG 검출|OK로 미탐|검출률|NG 및 유효박스 GT 교차|평균 API초|usage 비용 USD|
|---|---:|---:|---:|---:|---:|---:|
|Claude Sonnet5.5|119/119|0|100.00%|116/119|7.33|2.5843|
|Gemini3.8 Flash|118/119|1|99.16%|110/119|10.52|0.9655|

Qwen Thinking과 Kimi는 아직 진행 중. 위100%는 정상까지 포함한 정확도가 아니라 불량 검출률이다. API시간은 전체응답 수신까지이며 동시요청 부하를 포함. 위치교차는 단1픽셀 교차도 인정하므로 정확한 결함 국소화를 보장하지 않음. 상세 오류/미탐은 소스 JSON 참조.

## 실패·한계·다음
Q028은 실제 GT가 나사산인데 Claude와 Gemini가 머리 가장자리를 근거로 NG라고 응답. 판정 일치와 근거 위치 일치를 분리할 필요가 확인됨. Gemini의 일부 응답은 NG 판정은 유효하나 위치 스키마에 설명필드 등이 누락되어 위치평가에서 제외. 임의 좌표 보정/응답 재추론 없음. 정상 오탐률·단일클래스 AUROC는 평가 불가. 모델 우열 확정 전 정상평가가 필요하다. 현재 남은2모델 불량전체 추론은 계속 진행한다.

## 소스
- 코드: E:/DH/Sandbox/Dinopatch/tools/probe_screw_vlm_models.py, tools/report_screw_vlm_models.py
- 주실행: E:/DH/Sandbox/Dinopatch/output/comparisons/screw_vlm_models_20261008_014231
- 공급자변경 실행: E:/DH/Sandbox/Dinopatch/output/comparisons/screw_vlm_models_20261008_014326
- 중간측정 고정본: 주실행/logs/completed_fast_models.json
- [중간 시각화](http://127.0.0.1:8765/output/comparisons/screw_vlm_models_20261008_014231/index.html)
- 이전 Qwen Instruct: output/comparisons/vlm_anomaly_contours_20261008_004614
- 브라우저 검증: 119카드/120이미지/14필터 조합 정상. 수동Git commit/push 없음.


![[../첨부/20261008_014231_interim_Q028.jpg]]

SHA256 completed_fast_models.json: c2f0e6e2ff4a615165b0c5d6518beadfa0c2220b3fa4e102561065d7c5866c38
