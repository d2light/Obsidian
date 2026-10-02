---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [UNIVAD_CABLE_RESULTS_20261001.md](file:///E:/DH/Sandbox/Dinopatch/docs/UNIVAD_CABLE_RESULTS_20261001.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# UniVAD Cable 1-shot 평가 결과

비교 시각화: http://127.0.0.1:8765/output/comparisons/univad_cable_20261001_160629/comparison.html

전체150장·점수 분포: http://127.0.0.1:8765/output/comparisons/univad_cable_20261001_160629/index.html

## 결과

공식 저장소 commit64d32873을 Windows/RTX5080에서 호환 실행했다. 정상 참조는 기존 FIT의000.png 1장, 입력448, 별도 정상 CAL45장 q95(higher) 임계값0.715697169303894. 테스트 점수 평가 전에 기준을 기록했다. 평가 이미지는 이전 실험과 동일한 Cable 원본150장(정상58·불량92)이다.

| 구성 | 참조/FIT 정상 | 정확도 | 정상 오탐 | 불량 미탐 | 불량 검출 | 보류 | swap 검출 |
|---|---:|---:|---:|---:|---:|---:|---:|
| 공식 PatchCore |179|96.00%|1|5|87/92|0|8/12|
| 기존 DINO+SAM 색상 |179|93.33%|5|2|90/92|3|12/12|
| 현재 결합+부품 확대 |179|94.00%|5|1|91/92|3|12/12|
| UniVAD 1-shot |1|79.33%|2|29|63/92|0|2/12|

정확도는(정상OK+불량NG)/150이며 보류도 분모에 포함하고 정답에 포함하지 않는다. UniVAD 이미지 AUROC는96.1394%, 불량 검출률68.4783%, 정상 오탐률3.4483%다. AUROC와 고정 임계값의 정확도는 다른 수치다. 정상 참조 예산·입력 해상도·백본 등이 다르므로 순수 알고리즘 우열의 통제 실험이나 논문 성능 재현이라고 주장하지 않는다. 같은 개발 평가셋을 반복 관찰했다는 한계도 유지한다.

## 어떤 유형을 놓쳤나

| 불량 유형 | UniVAD 검출 |
|---|---:|
| bent_wire |13/13|
| cable_swap |2/12|
| combined |11/11|
| cut_inner_insulation |8/14|
| cut_outer_insulation |8/10|
| missing_cable |11/12|
| missing_wire |3/10|
| poke_insulation |7/10|

정상 오탐은good/021.png·045.png다. 현재 모델의 정상 오탐5장과 보류3장은 UniVAD에서 모두OK였지만, 현재 모델이 놓친missing_wire/007.png도UniVAD가 놓쳤다. 두 모델의 결과를 결합하면 개선된다는 실험은 수행하지 않았으며, 단순히 UniVAD의 음성을 기존NG 반박 근거로 사용하면 미검출이 늘 수 있다.

## 중간 부품 관측

참조000과swap000에서 GroundingDINO+SAM-HQ의 초기 마스크는 내부 세 부품을 나눴으나 C³ 정제 라벨은[0,1,2]이며 세 내부 부품은 같은 라벨로 묶였다. 이미지 중간 단계는`logs/component_diagnostic.png`에 보존했다. 개별 부품의 색상·구성 정보를 충분히 유지하지 못할 가능성을 조사할 단서다. 원인이라고 확정하려면 원래 설정과 부품 인스턴스를 유지한 설정을 별도로 비교해야 한다.

이번 설정을 기존 검사기 대체안으로 채택하지 않는다. 정상 참조1장의 제한, 분할·클러스터링 결과, 구성 특징을 다음 분석 항목으로 남긴다. 테스트 결과를 보고 이번 실행의 임계값이나 정상 참조를 변경하지 않았다.

## 실행과 검증

196장(참조1·CAL45·TEST150)의 공식 GroundingDINO/SAM-HQ 분할 완료. 원래모델에서CFA/GECM까지 사용하는MULTI 경로로195장의점수·448×448수치맵을 저장했다. 테스트150장의 원본·이상맵·초기 분할 카드와 C³ 중간 마스크를 보존했다. 새 학습·유료API호출·원본데이터변경 없음.

전체118테스트 통과, 분리 환경의 실행 경계 테스트2개 통과. 산출물1353파일해시, 원본해시불변,195개유한수치맵과150개카드, CAL임계값·AUROC재계산, 보고서이미지231링크HTTP200 검증. 감사결과는`output/comparisons/univad_audit_20261001/validation.json`.

추론 중앙값3.7396초는 사전 GroundingDINO/SAM분할을 제외한 값이며 end-to-end시간이 아니다. 속도 개선은 이번 범위에서 제외했다. 모델 가중치5개 해시와 환경은`logs/environment.json`, 실제추론소스는`logs/infer_source.py`, 비교보고서소스는`logs/report_univad_comparison.py`에 있다.

호환 차이와 재현 방법: [UNIVAD_CABLE_PROTOCOL_20261001.md](file:///E:/DH/Sandbox/Dinopatch/docs/UNIVAD_CABLE_PROTOCOL_20261001.md). 공식 출처: https://github.com/FantasticGNU/UniVAD .
