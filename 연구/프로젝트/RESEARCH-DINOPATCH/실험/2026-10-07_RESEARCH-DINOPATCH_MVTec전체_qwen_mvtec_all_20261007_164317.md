# MVTec AD 전체: DINO 정상 검색 + Qwen VLM

전체 실행·검증 완료. 아래 표는 단계별 저장에 사용한 형식 검증 기준 집계다. 최종 분류 지표와 해석은 [2026-10-07_RESEARCH-DINOPATCH_MVTec전체완료_20261007_164317.md](2026-10-07_RESEARCH-DINOPATCH_MVTec전체완료_20261007_164317.md)에서 확인한다.

질문: 검사 이미지와 유사한 정상 3장 검색 방식이 전체 15개 카테고리에서도 유효한가?
설정: 동결 DINOv2-registers-base CLS cosine top3, 학습 정상만 검색. Qwen3-VL-235B-A22B, 기준/검사 1024, 동일 프롬프트, temperature 0. 테스트 원본 전체, 증강 없음. API 시간은 오프라인 DINO 검색을 제외한다.
변경: 기존 3개 카테고리 결과 재사용, 12개 신규. 원본·기존 실행 결과 보존. GT는 API 입력에서 제외.
한계: 이전에 탐색한 데이터이며 독립 모델 선택 검증이 아니다. 좌표는 이상맵이 아니며 분류와 형식 오류를 분리해야 한다.

|카테고리|재사용|TP|TN|FP|FN|오류|보류|
|---|---|---:|---:|---:|---:|---:|---:|
|bottle|False|63|17|3|0|0|0|
|cable|False|88|58|0|1|3|0|
|capsule|False|96|22|1|13|0|0|
|carpet|False|84|28|0|5|0|0|
|grid|False|56|16|5|1|0|0|
|hazelnut|True|68|36|4|0|2|0|
|leather|False|92|31|1|0|0|0|
|metal_nut|True|93|21|1|0|0|0|
|pill|True|130|24|2|9|2|0|
|screw|False|89|41|0|30|0|0|
|tile|False|84|33|0|0|0|0|
|toothbrush|False|30|11|1|0|0|0|
|transistor|False|35|57|3|2|3|0|
|wood|False|60|16|3|0|0|0|
|zipper|False|101|30|2|18|0|0|

다음: 나머지 카테고리 완료 후 분류 정확도·형식 포함 정확도·실패 종류·시간 및 시각화를 종합한다.
원본 실행 목록: `output\comparisons\qwen_mvtec_all_20261007_164317/suite.json`
검색 실행: `output\comparisons\dino_reference_search_20261007_164037`
코드: `E:\DH\Sandbox\Dinopatch\tools\run_qwen_mvtec_all.py`
