# Claude Sonnet screw 전체 평가

Claude Sonnet5.5 screw 전체160장: 정확도 95.000%, TP119/TN33/FP8/FN0, 보류0/오류0. NG검출률 100.00%, 정상오탐률 19.51%.

## 질문·방법·조건
사용자가 Claude로 screw 전체 예측과 OpenRouter 잔액 확인을 요청했다. 원본 test160(OK41/NG119). 직전 NG119 응답을 해시검증 후 그대로 재사용하고 정상41장만 추가 호출. 이미지별 정상참고3장·원본Q·깨끗한확대최대2장·윤곽확대최대2장. 기존 DINO/ReCon변형/EfficientAD FIT256/CAL64 결과로 만든 입력. 동일 프롬프트, anthropic/claude-sonnet-5.5, Google Vertex/global only, fallback false, data deny/ZDR, max_tokens8192, temperature/추론 provider 기본값. GT·불량유형/라벨 입력 없음. 원본/모델/생산코드 변경 없음.

## 측정
- 새 정상 요청 41회, usage 비용 $0.850012.
- 재사용 NG 비용 $2.584344는 과거 지출이며 이번 추가 청구가 아님.
- 전체 평균API 7.382초, 새 정상 평균 7.545초. 동시4요청; 업로드~최종응답. 단일요청 통제 벤치마크 아님.
- 오탐 ['Q002', 'Q044', 'Q083', 'Q087', 'Q123', 'Q140', 'Q158', 'Q154'], 미탐 []. 엄격형식오류 0.
- NG 판정 및 GT와 박스 교차 116/119. 1픽셀 교차도 인정하므로 정확한 국소화는 아님.

## 실패·한계·판단·다음
이미 살펴본 개발셋이며 정상/불량 호출 시점이 분리되어 있다. 새160회 동시실험으로 표현하지 않음. 연속 이상점수 없으므로 AUROC N/A. 불량검출률100%만으로 전체정확도100%를 주장하지 않음. 정상오탐 이미지와 GT 불일치 사례를 검토하고 다른 카테고리/미관찰 데이터에서 확인 필요. 테스트 라벨로 임계값/프롬프트 조정 없음. 실제 계정 잔액은 연구노트에 복사하지 않고 사용자에게 별도 보고.

## 소스
- 실행: E:\DH\Sandbox\Dinopatch\output\comparisons\claude_screw_full_20261008_082615
- 재사용 NG: E:\DH\Sandbox\Dinopatch\output\comparisons\screw_vlm_models_20261008_014326
- 입력: E:\DH\Sandbox\Dinopatch\output\comparisons\vlm_anomaly_contours_20261008_004614
- 코드: tools/probe_claude_screw_full.py, tools/probe_screw_vlm_models.py, tools/report_claude_screw_full.py

## 이전 판단 보완
불량119장만으로 Claude를 유망 후보로 보았으나 정상41장 추가 후 오탐8건을 확인했다. 이전 Qwen Instruct 윤곽 조건은 정확도95.625%, 오탐1/미탐6. Claude는 미탐을 줄이는 대신 정상오탐이 늘어 종합 우수모델로 확정하지 않는다. 과거대조이며 토큰한도/기본추론 및 호출시점 차이 존재.

![[../첨부/20261008_082615_claude_screw.png]]

[시각화](http://127.0.0.1:8765/output/comparisons/claude_screw_full_20261008_082615/index.html)

metrics SHA256: 1cfeab825222790fc286a58ef8a2f550eed034fc3805dbac5f5e293b57d3c08f
