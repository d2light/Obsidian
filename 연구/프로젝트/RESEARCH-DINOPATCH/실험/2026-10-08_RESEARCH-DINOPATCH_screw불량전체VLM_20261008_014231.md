# screw 불량 전체 VLM 비교

|모델|NG 검출/119|검출률%|OK로 미탐|보류|분류 오류|형식 오류|NG+위치겹침|평균 API초|사용비용 USD|
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
|Qwen VL235B Thinking|119|100.00|0|0|0|1|110|27.89|1.1209|
|Claude Sonnet 5.5|119|100.00|0|0|0|0|116|7.33|2.5843|
|Kimi K3|115|96.64|3|0|1|1|110|61.68|7.6788|
|Gemini 3.8 Flash|118|99.16|1|0|0|2|110|10.52|0.9655|

이전 Qwen Instruct는 NG113/119(94.96%), 미탐6. 전체 정상 포함 정확도95.625%와 여기 검출률은 다른 지표.

입력: 기존 정상3장+원본Q+깨끗한확대 최대2장+빨간윤곽확대 최대2장, 동일 PNG/프롬프트. 불량유형·GT는 전달하지 않음. 원본 데이터 변경/학습 없음. 단일클래스 정확도·AUROC·오탐률은 N/A.

한계: 이미 살펴본 screw 개발셋. 현재4모델은 출력한도8192/temperature 생략/기본추론, 기존 Instruct는3000/temperature0로 동일계산량 대조가 아님. 모델별 공급자·토큰화·기본추론도 다름. API시간은 업로드~전체응답, 동시실행 부하 포함. 최초요청및복구 모두 보존. NG 판정만 유효하고 위치 형식이 잘못된 경우 분류와 엄격형식오류를 별도 집계. 위치겹침은 박스와 GT의 단1픽셀 교차도 포함하므로 정확한 국소화가 보장되지 않음.

공급자연결: 최초 Anthropic/Google AI Studio는 ZDR 조건에서404, Google Vertex로 변경하고 같은 첫이미지 포함 전체실행. 데이터 보관조건 완화 없음.

소스: {'qwen_thinking': 'output\\comparisons\\screw_vlm_models_20261008_014231', 'claude_sonnet': 'output\\comparisons\\screw_vlm_models_20261008_014326', 'kimi': 'output\\comparisons\\screw_vlm_models_20261008_014231', 'gemini_flash': 'output\\comparisons\\screw_vlm_models_20261008_014326'}
코드: tools/probe_screw_vlm_models.py, tools/report_screw_vlm_models.py

실행 부하: 두 실행기가 각각 최대4요청을 사용해 겹치는 구간에는 최대8요청, 빠른 두 모델 완료 후 최대4요청. 모델별 평균 API시간은 순차 단일요청 지연의 통제 비교가 아니다.

응답 오류 상세: Kimi Q136은 finish_reason=length, 8192토큰 중 reasoning7386토큰을 사용하고 JSON이 잘려 분류ERROR. Qwen Q081은 픽셀좌표 반환으로 위치 스키마 오류, Gemini Q093/Q138은 위치 스키마 오류. 완전한 JSON의 유효 NG 판정만 별도 분류 집계. 재추론/임의 좌표 보정 없음.

## 판단·다음
불량 검출률만 비교하며 정상 오탐 평가 전 종합 우수모델 선정 금지. 다음은 우수후보 정상41장 평가 및 설명위치 검토.

![[../첨부/20261008_014231_vlm_models.png]]

[시각화](http://127.0.0.1:8765/output/comparisons/screw_vlm_models_20261008_014231/index.html)

원본 실행: E:\DH\Sandbox\Dinopatch\output\comparisons\screw_vlm_models_20261008_014231
metrics SHA256: c90ab098ba4b941fb46c68c8af355d108dd278e0d0bee78ac2ebf97432ba100a
