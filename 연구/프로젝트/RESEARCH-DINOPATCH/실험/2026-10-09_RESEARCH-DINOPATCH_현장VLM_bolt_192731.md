# 현장 VLM 비교: bolt

상태: **부분 완료 / API 키 월간 한도 초과로 중단**. 볼트 Sonnet은 원본·확대 조건 전체217장을 완료했다.

## 질문·변경·설정

네 검출기의 의심 영역을 VLM에 추가하면 원본만 제공할 때보다 오탐·미탐이 개선되는가? Qwen `qwen/qwen3-vl-235b-a22b-instruct`는 `deepinfra/fp8`, Sonnet `anthropic/claude-sonnet-5.5`는 `amazon-bedrock`로 고정했다. 실제 응답 모델/공급자가 일치함을 검증했다. ZDR=true, data_collection=deny, allow_fallbacks=false를 유지했고 현장 이미지에 공개 데이터 예외를 적용하지 않았다.

정상 FIT에서 DINOv2reg CLS 코사인 top3만 참고로 검색했다. CAL/TEST를 참고에 넣지 않았다. original=정상3장+검사원본, guided=동일한 입력+네 모델 수치맵에서 합친 후보 crop 최대2장. 점수·판정·정답·파일명은 API에 전달하지 않았다. crop 위치 설명은 원본 픽셀 좌표이다. 원본 긴 변 최대1024, crop 긴 변1024, 종횡비 보존 JPEG95 메모리 인코딩. 분류/사유/자체 이상 점수0~100/정규화 위치 박스를 요청했다. 점수는 보정 확률이 아니다. max_tokens1500, 공급자 기본 샘플링, 카테고리당 동시4요청.

워터씰은 기존 밝은 FIT224/CAL85, TEST268=정상185/불량83(밝음204/어두움64) 전부가 VLM 예정 표본이다. 볼트는 기존 FIT275/CAL152, 주TEST2277 중 seed20261009로 정상200장+불량5장을 점수 산출 전에 고정했고 다른 촬영 NG12장은 별도이다. 모든 원본은 경로/해시만 참조하며 입력 복사·원본 변경 없음.

## 측정값

아래 AUROC는 **유효 점수를 받은 표본만** 계산한 참고값이다. 예정 표본과 점수 확보 수가 다르면 전체 성능 비교에 쓰지 않는다. 보류는 정답으로 세지 않고, 위치 오류는 분류/점수와 분리한다.

|모델|입력|범위|예정|수신|점수 OK/NG|참고 AUROC %|FP/FN|보류|오류|위치 오류|
|---|---|---|---:|---:|---|---:|---|---:|---:|---:|
|qwen|original|primary|205|75|12/3|72.22|0/2|0|60|0|
|qwen|original|external|12|0|0/0|N/A|0/0|0|0|0|
|qwen|guided|primary|205|74|11/5|70.91|2/2|0|58|0|
|qwen|guided|external|12|0|0/0|N/A|0/0|0|0|0|
|sonnet|original|primary|205|205|200/5|95.55|31/1|1|0|0|
|sonnet|original|external|12|12|0/12|N/A|0/3|0|0|0|
|sonnet|guided|primary|205|205|200/5|95.05|32/1|5|0|0|
|sonnet|guided|external|12|12|0/12|N/A|0/3|0|0|0|

## 실패·한계

Qwen 공유 공급자 풀이 과부하429를 반복했다. 이어 두 모델 모두 HTTP403 `Key limit exceeded (monthly limit)`로 중단됐다. 조회된 키 월한도$50, 월사용$50.032242629, 남은 키 한도$0이다. 계정 전체 충전 잔액을 의미하지 않는다. 키 한도/공급자/보안 설정을 변경하지 않았고 모든 추론 작업은 종료했다. 추가 재시도 예산을 준비했으나403 차단으로 실행하지 못했다. 일부 연결 종료도 통신 실패로 보존했다.

Qwen guided의 잘못된 정규화 좌표와 Sonnet 위치 오류는 원본 응답을 보존하면서 유효한 분류·점수만 따로 복구했다. 좌표를 임의로 clamp/재척도하지 않았고 위치 표시는 생략했다. classifier 결과를 좋게 만들기 위한 재질문은 하지 않았다. 첫 볼트 Qwen 요청은429로1회 기술 재시도됐다. 전체1386번 시도/1385개 고유 판정 슬롯, 유효 분류·점수1163개, 미실행555개와 기술실패222개를 별도 보존했다.

같은 주평가205장에서 Dinomaly AUROC97.50/FP13/FN1, DINO95.20/FP34/FN0, PatchCore94.70/FP15/FN1, EfficientAD92.20/FP7/FN2. Sonnet original95.55/FP31/FN1/보류1, guided95.05/FP32/FN1/보류5. 이번 표본에서 확대 추가로 개선되지 않았다. 외부NG12장은 Sonnet 두 조건 모두9검출/3미탐이며 정상 표본이 없어 AUROC/FPR는N/A. Qwen 유효점수는 original15/205, guided16/205에 불과하여 모델 간 성능 결론을 낼 수 없다.

반복 관찰한 개발 데이터이다. 볼트 주 NG5장이 매우 적고 독립 물체/날짜/카메라 일반화가 검증된 것은 아니다. 픽셀 GT가 없어 VLM 위치 정밀도를 정량 평가하지 않았다. 모델별 입력 해상도/검사 시야가 같지 않다. VLM 점수에 TEST 정답 기반 임계값을 지정하지 않았다.

## 시간·비용

|모델|입력|응답 수|중앙값 초|p95 초|
|---|---|---:|---:|---:|
|qwen|original|15|13.15|26.99|
|qwen|guided|16|15.56|30.00|
|sonnet|original|217|5.96|10.32|
|sonnet|guided|217|6.93|11.64|

API 왕복시간이며 검색/이미지 인코딩/큐 대기는 제외한다. 형식 오류를 포함한 공급자 응답 기준, HTTP 실패 제외, 병렬 실행 조건이다. bolt 응답에 기록된 비용 $6.212994. 두 카테고리 합계 $12.03394392; 실패 요청223개에는 usage가 없으며 비용을 임의로 보충하지 않았다. 키 일사용 조회$12.03402048은 소액 공급자 probe도 포함한다.

![[현장VLM_bolt_180149.jpg]]

## 검증·결정·다음 단계

원본/참고774개 경로 해시, 조건 간 동일 입력, 실제 공급자, 쌍별 정의에 의한 AUROC 재계산, 비용 합계, JPG1871개 디코딩을 검증했다. VLM갤러리1385카드/189필터 조합과 비교 보고서9링크/5차트를 브라우저에서 확인했다. 일부 오류를 제외한 공통 유효 표본의 AUROC는 별도 보조표로만 제공하고 전체 평가를 대체하지 않는다.

현재 키 한도에서는 추가 API 호출을 하지 않는다. 한도가 실제로 사용 가능해진 뒤 미실행/통신 실패만 이어서 평가하고 기존 정상 응답(보류·좌표 오류 포함)을 재호출하지 않는다. 전체 결과가 나오기 전 워터씰 또는 Qwen 최종 비교 결론을 보류한다. 다음 실험의 프롬프트/검사 기준 변경은 별도 run으로 분리한다.

## 출처

- 실행: `E:\DH\Sandbox\Dinopatch\output\comparisons\field_models_20261009_180149\bolt_stage2\vlm`
- 최종 통합(부분결과): `E:\DH\Sandbox\Dinopatch\output\comparisons\field_models_20261009_180149\vlm`
- 코드: `tools/field_vlm_comparison.py`, `tools/run_field_vlm_category.py`, `tools/finish_field_comparison.py`, `tools/validate_field_vlm.py`
- 재개 목록: `E:\DH\Sandbox\Dinopatch\output\comparisons\field_models_20261009_180149\resume_plan.json`
- 통합 metrics.json SHA256: `56774705f67837b3ebafef19e8a0042e0cacb580e2a5249a863544877959c3b0`
- [비교 대시보드](http://127.0.0.1:8765/output/comparisons/field_models_20261009_180149/comparison.html)
- [VLM 판정·사유·위치](http://127.0.0.1:8765/output/comparisons/field_models_20261009_180149/vlm/index.html)

## 저장량

이번 네 모델×두 데이터의 최종 가중치·수치맵·보고서 합계5.291GiB, VLM/비교 보고서 추가약0.153GiB(최종manifest 메타데이터 전 시점). 원본 입력 복사0. D: 실험 경로에 보존하고 E: 보고서 경로를 유지했다. 검증 후 중복 학습 progress 및 재현 가능한 중복 EfficientAD 맵 캐시만 삭제 이력을 남기고 정리했다. 최종 모델과 수치맵은 보존했다.
