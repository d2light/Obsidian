# screw 전체160장 VLM 비교

## 질문·변경
Claude 정상오탐8건을 확인한 후 다른 세 모델도 전체 데이터 기준으로 비교 요청. Qwen Thinking/Kimi/Gemini의 기존 NG119 결과는 변경 없이 재사용하고 각 정상41장을 새로 예측했다. Claude160은 직전 완료 결과 그대로 재사용.

## 데이터·설정
원본 MVTec screw test160(OK41/NG119). 참고 정상3장+원본Q+깨끗한확대최대2장+의심윤곽확대최대2장, 같은 입력 PNG와 일반프롬프트. 기존 FIT256/CAL64 검출기 산출물을 재사용, 추가학습 없음. 라벨/GT/불량유형 미전달. 모델별 이전 공급자 고정, deny/ZDR 유지, max_tokens8192, temperature 및 추론 기본설정 유지. 신규 정상123요청 동시6. 과거 NG/Claude는 다른 시간블록·동시성 조건이므로 시간값은 관측값이며 통제 순차 벤치마크 아님.

## 검증 결과
|모델|정확도%|오탐|미탐|보류|응답오류|정상오탐률%|평균 API초|이번 추가비용 USD|
|---|---:|---:|---:|---:|---:|---:|---:|---:|
|Qwen VL235B Thinking|86.250|22|0|0|0|53.66|29.75|0.4460|
|Claude Sonnet 5.5|95.000|8|0|0|0|19.51|7.38|0.0000|
|Kimi K3|95.000|4|3|0|1|9.76|64.06|3.4535|
|Gemini 3.8 Flash|92.500|11|1|0|0|26.83|11.77|0.3819|


기존 Qwen Instruct 윤곽 조건(과거 참고): 정확도95.625%, FP1/FN6. 이 조건은 max_tokens3000/temperature0으로 설정이 다르다.

## 실패·한계·판단
응답ERROR/REVIEW도 전체160 분모에 유지. NG/OK 분류가 유효하고 위치 스키마가 잘못된 경우 분류와 형식 오류를 분리. 이전 Kimi Q136 토큰한도 잘림도 그대로 포함. 정상오탐과 불량미탐의 균형으로 판단하며 NG만의100%를 전체성능으로 해석하지 않음. 이미 살펴본 개발셋이며 정상과 NG 호출시점이 분리됨. 연속 이상점수 없어서 AUROC N/A. 모델 변경만으로 모든오류가 해결되는지는 전체결과로 판단해야 한다. 다음은 오탐·미탐의 공통/고유 사례를 확인하고 미관찰 데이터에서 재검증. 테스트 정답에 맞춘 프롬프트 수정/재추론은 하지 않음.

## 소스
- 실행: E:\DH\Sandbox\Dinopatch\output\comparisons\screw_vlm_full_comparison_20261008_083209
- 기존 NG: E:\DH\Sandbox\Dinopatch\output\comparisons\screw_vlm_models_20261008_014231 및 screw_vlm_models_20261008_014326
- Claude전체: E:\DH\Sandbox\Dinopatch\output\comparisons\claude_screw_full_20261008_082615
- 코드: tools/probe_other_screw_full.py, tools/probe_screw_vlm_models.py, tools/report_screw_vlm_full.py

전송오류 복구: ['Q053']는 IncompleteRead(응답 전송 중단)로 동일조건1회 별도복구. 최초응답/예측 보존, 복구파일 분리. costs는 API usage에 반환된 값의 합이며 전송오류로 usage가 누락된 요청의 청구 여부는 이 합계만으로 알 수 없다.

![[../첨부/20261008_083209_screw_vlm_full.png]]

[시각화](http://127.0.0.1:8765/output/comparisons/screw_vlm_full_comparison_20261008_083209/index.html)

metrics SHA256: ac6145d481c32fdbf034a20967fc8bda0d6828052bdcd26be889db631ac1e173
