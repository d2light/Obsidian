# screw 검출기 점수 판정과 VLM 판정 비교

사용자 질문: 검출기 점수만으로 판단하는 경우와 검출기 정보를 VLM에 전달하는 경우의 성능 차이. 신규 학습·추론·API 호출 없이 기존 metrics.json을 다시 읽어 비교했다. Kimi는 사용자의 결정에 따라 후속 후보 비교에서 제외한다.

데이터: screw 원본 test 160장(정상 41·불량 119), 검출기 FIT 정상 256장·CAL 정상 64장. 점수 방식은 정상 CAL 이미지 점수의 95분위를 임계값으로 사용한다. ReCon은 DINO 기반 ReConPatch-inspired 변형이며 원논문 구현과 구분한다.

|방식|정확도 %|오탐|미탐|3모델 평균 대비 %p|
|---|---:|---:|---:|---:|
|DINO 점수|73.750|3|39|-15.000|
|ReCon-inspired 점수|78.750|3|31|-10.000|
|EfficientAD 점수|86.250|0|22|-2.500|
|3모델 정규화 맵 평균|88.750|2|16|0|
|3모델 평균 + SAM 검사영역 제한|94.375|0|9|5.625|
|검출기 기반 확대 + Qwen Instruct, 윤곽 없음|92.500|1|11|3.750|
|검출기 기반 확대·윤곽 + Qwen Instruct|95.625|1|6|6.875|
|동일 확대·윤곽 + Claude Sonnet|95.000|8|0|6.250|
|동일 확대·윤곽 + Gemini Flash|92.500|11|1|3.750|
|동일 확대·윤곽 + Qwen Thinking|86.250|22|0|-2.500|

해석: 전체 맵 평균 점수 대비 Qwen Instruct VLM 판정은 6.875%p 높고 정답이 11장 더 많다. 그러나 SAM으로 검사영역을 제한한 비VLM 판정 대비 차이는 1.250%p, 정답 2장이다. 같은 Qwen에서 윤곽 추가 전후는 3.125%p, 정답 5장 차이지만 추가 이미지 수가 달라 윤곽만의 순수 효과로 단정하지 않는다. Claude는 미탐이 없지만 오탐이 8건이므로 전체 성능 개선과 미탐 감소를 구별한다.

VLM 입력은 원시 숫자 점수 자체가 아니라 정상 참고 3장, 검사 전체 이미지, 검출기 맵 기반 확대 최대 2장, 의심 영역을 붉은 윤곽으로 표시한 확대 사본 최대 2장이다. 각 단일 검출기마다 VLM을 붙인 대응 실험은 아니며 결합 정보를 전달한 파이프라인 비교다. NG 이미지 분류 정답이 결함 위치의 정확성을 보장하지 않는다.

한계: 이미 검토한 개발셋, 실행 시점·공급자·기본 추론 설정 차이, 단일 카테고리. 점수 방식 AUROC(DINO 94.40, ReCon 94.84, EfficientAD 97.21, 평균 97.81, SAM 검사영역 99.51)는 정확도와 다른 지표이며 연속 점수가 없는 VLM과 직접 비교하지 않는다. 보존된 기존 결론을 대체하지 않고 비교 기준에 따라 VLM의 이득이 달라짐을 명시한다.

결정·다음: VLM의 증분 가치는 단순 평균뿐 아니라 SAM 검사영역 제한 점수 방식과도 비교해야 한다. 새 실험은 실행하지 않았다.

출처(모두 E:/DH/Sandbox/Dinopatch/output/comparisons 아래):
- pixel_fusion_no_vlm_20261007_231904/metrics.json 및 SUMMARY.md
- otsu_candidate_mobile_sam_20261008_000558/metrics.json
- vlm_anomaly_contours_20261008_004614/metrics.json 및 run.json
- screw_vlm_full_comparison_20261008_083209/metrics.json

관련 코드: tools/probe_pixel_fusion_no_vlm.py, tools/probe_vlm_anomaly_contours.py, tools/probe_screw_vlm_models.py, tools/report_screw_vlm_full.py.

![[../첨부/20261008_083209_screw_vlm_full.png]]

pixel_fusion_no_vlm_20261007_231904 metrics SHA256: 688eba2ab625930d8f5ea00c1d53e4f52a4a76770c1a0c14d33facfad7a3b1aa
otsu_candidate_mobile_sam_20261008_000558 metrics SHA256: 9df12c1817b94b2a55db1288d2006063e32a63e4cde9cbad4101b7dee4306677
vlm_anomaly_contours_20261008_004614 metrics SHA256: cd0381ca3e81ac6be227c811b56f28d9fa8982fd2b6ad1b021dbc68adcea3b49
screw_vlm_full_comparison_20261008_083209 metrics SHA256: ac6145d481c32fdbf034a20967fc8bda0d6828052bdcd26be889db631ac1e173