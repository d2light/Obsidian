# Qwen cable 전체 결과 한국어 번역 — 20261007_113758

기존150장 판정 이유와 위치 근거를 한국어로 번역했다. 이미지 추론·재학습·재예측 없음. 영어 텍스트만 25건씩6회 Qwen3-VL235B에 전달했다. 이미지·정답·파일경로는 번역 요청에 보내지 않았다. temperature0/max_tokens12000, data_collection=deny/zdr=true. 번역 API 보고 비용 $0.0281634.

원본 실행 전체의 해시 보존 및 한국어CSV의150개 ID·판정·원문·좌표·API시간·전체시간 일치를 검증했다. 번역을 새 모델 판정으로 취급하지 않는다. 정확도99.33%, 미탐1/오탐0, 시간 측정은 원본 그대로다. 원문의 오인·불확실성을 임의로 정정하지 않도록 지시했고, 영어 원문을 펼쳐 비교할 수 있게 했다. 자동 번역이므로 모든 문장에 대한 사람 검수 완료를 주장하지 않는다.

- 원본: `E:/DH/Sandbox/Dinopatch/output/comparisons/qwen_cable_full_20261007_112918`
- 번역: `E:/DH/Sandbox/Dinopatch/output/comparisons/qwen_cable_ko_20261007_113758`
- 코드: `tools/translate_qwen_report.py`, 실행 logs/source.py.
- 번역문 translations.json / 병기CSV predictions_ko.csv / 검증 validation.json.
- [한국어 화면](http://127.0.0.1:8765/output/comparisons/qwen_cable_ko_20261007_113758/index.html)

다음 단계는 한국어 화면에서 미탐과 근거를 검토하는 것이다. 원본 데이터·모델·자격증명·전체대화는 연구저장소에서 제외. 별도commit/push 없이 정기18:00 동기화 대상으로 저장했다.
