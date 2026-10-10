# 워터씰 네 모델 1차 평가 완료

동일 FIT224/CAL85, 밝은 정상만 학습·보정. 원본 TEST268(OK185/NG83), 정상CAL q95 higher. 기존 분할/라벨 유지, TEST로 임계값 수정 없음.

|모델|범위|I-AUROC%|정확도%|FP|FN|
|---|---|---:|---:|---:|---:|
|dinomaly|primary|91.918|78.731|56|1|
|dinomaly|bright|99.819|97.059|5|1|
|dinomaly|dark|100.000|20.312|51|0|
|dino|primary|89.365|76.866|62|0|
|dino|bright|99.989|94.608|11|0|
|dino|dark|72.700|20.312|51|0|
|patchcore|primary|85.796|80.224|53|0|
|patchcore|bright|99.979|99.020|2|0|
|patchcore|dark|0.151|20.312|51|0|
|efficientad|primary|93.657|79.478|55|0|
|efficientad|bright|99.883|98.039|4|0|
|efficientad|dark|77.828|20.312|51|0|

![[워터씰4모델점수_180149.jpg]]

밝은 영상에서는 PatchCore 오류2건(FP2/FN0)이 가장 적었다. 전 모델이 어두운 정상51장을 NG로 판정했다. Dinomaly의 어두운 그룹AUROC100%는 이64장 내부의 순위 분리를 뜻하며, 밝은 정상CAL 임계값으로 정상 판정이 된다는 의미가 아니다. 다른 모델은 어두운 그룹에서 정상/불량 점수 순위도 악화. 서로 단위가 다른 모델 점수를 CAL중앙값0/q95값1로 표시했으며 확률이나 평균융합 판정이 아니다.

## 한계·다음
이미 반복 관찰한 개발데이터. 어두운 그룹NG13장, 새로운 조건 일반화 증거 아님. Dinomaly/PatchCore 일부테두리 미검사; 해상도/시야 다름. EfficientAD10k 탐색일정. 픽셀GT 없음. 모델 최종재로드, 원본해시, 지표재집계, 수치맵·JPG 및 브라우저 확인.

워터씰 VLM 원본/의심crop 추가를 Qwen235B Instruct(DeepInfra fp8), Sonnet5.5(Amazon Bedrock)로 실행 중. ZDR/학습수집금지 유지. Anthropic직접경로 ZDR404로 Bedrock에 고정(텍스트와 첫실제이미지응답 확인). VLM 이상점수0..100은 자체서술값이며 CAL보정확률 아님. API비용 알려진usage 기준 워터씰15달러/볼트10달러로 제한; 인플라이트 소량 초과와 미확인usage 가능.

일부좌표가 범위를 벗어나므로 위치 임의복구 없이 오류로 남김. 유효 OK/NG 및 점수는 원문JSON에서 별도로 읽어 분류/점수 지표와 strict형식포함 지표를 분리한다. 보류는 정답 취급하지 않는다. 아직 VLM최종성능 없음. 볼트모델 학습 병행.

출처: E:\DH\Sandbox\Dinopatch\output\comparisons\field_models_20261009_180149 / full_metrics.json, score_distribution_summary.json, suite.json, provider_probe.json.
