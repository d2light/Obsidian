# ai_solution

연구 위치: `E:\DH\Gitlab\Jinyang2026\ai_jyos_2026\ai_solution`

2026-10-02 코드와 저장된 결과를 확인했다. 금속링DinoMatch의 순서 보존 패치 연결과 패치 평균을 결합한 방식이다.
OK16·NG16 마스터를 사용해 정상 전용Dinopatch와 학습 정보가 다르다.

전체48571장 중 사용자 확인2325장, 미확인46246장이다. 전체 패치 평균85%+위치순서15%는
현재 라벨 대비오탐 후보3·미탐0, 확인 라벨에서는오탐0·미탐0이었다.
같은 데이터에서 비중을 탐색했으므로 독립 검증100%로 해석하지 않는다.
확인 라벨에서는 평균 단독도오탐0·미탐0이므로 연결의 추가 효과를 별도 검증해야 한다.

실험 코드: `tools/experiment_fullpatch_hybrid_20261002.py`
결과: `output/reports/DinoMatch_fullpatch_weight_sweep_20261002_091241/summary.json`

이 노트는 이번 대화에서 확인한 범위만 정리했다. ai_solution 전체 연구 이력은 아직 가져오지 않았다.
