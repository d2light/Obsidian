# 패치 노드·공간 이웃 엣지 그래프 설계 검토

질문: 물체 패치를 노드, 가까운 패치 연결을 엣지로 사용해 이상을 판단할 수 있는가?
범위: 설계 상담. 새 모델 구현·학습·성능 측정 없음. 기존 모델 기본값 유지.

확인한 기존 코드: tools/probe_cable_relations.py의 relation_features는 상하좌우 Lab 차이12차원을 보조 특징으로 저장하고 정상 패치와 결합 거리 비교한다. 이것은 학습형 GNN이 아니다. 이전 문서의 성능 숫자는 이번에 재검증하지 않아 새 근거로 인용하지 않는다. tools/probe_component_graph.py와 docs/CABLE_COMPONENT_GRAPH.md는 부품 단위 그래프 실험이므로 패치 그래프와 구분한다.

제안: DINO 패치 특징을 노드에 두고 공간4/8이웃 엣지에 특징 차이·유사도·상대 변위를 기록한다. 중심과 이웃을 하나의 정상 국소 그래프로 묶어 비교한다. 노드마다 서로 다른 정상 사례를 자유롭게 선택하면 연결을 추가해도 일관성 검증이 약하다. 최초 비교는 별도 GNN 없이 정상 이웃 묶음 메모리로 관계 점수의 효과를 확인한다. 후속 학습형 후보는 중심을 가린 이웃 기반 특징 예측이며 복사 우회·과도한 평활을 점검한다.

핵심 제한:
- 고정 격자의 연결선만 추가하면 정상/불량의 topology가 같으므로 엣지 특징 또는 관계를 학습하는 점수·목적함수가 필요하다.
- DINO 특징에도 문맥이 이미 들어 있으므로 그래프 추가 자체가 새로운 정보·성능 향상을 보장하지 않는다.
- 근거리 관계는 끊김·연속성 검사 후보지만 멀리 떨어진 부품 교환, 개수·대체 이상은 해결되지 않을 수 있다. 거리별/부품별 연결은 후속 단계.
- 상대좌표는 평행이동에 도움이 되지만 회전 불변성을 자동으로 주지 않는다. 회전 증강 또는 방향 정렬을 별도로 검증해야 한다.
- 나사산 경계 패치의 결함을 마스킹으로 제외하지 않도록 피복 확인이 필요하다.

평가 제안: 동일 데이터/분할/백본/입력/점수집계 고정, 기존 패치 점수 vs 관계 추가. 정상CAL로 점수척도·임계값 결정, 테스트로 튜닝하지 않음. 기존 이상맵과 관계 이상맵을 분리해 FP/FN·결함유형별 효과 확인. 아직 실행 계획 확정이나 테스트 성능 주장 아님.

연관 1차 출처:
- PNI: 위치·이웃에 조건화한 정상 특징 분포. 모든 이웃 정보 방법이 GNN인 것은 아니다. https://openaccess.thecvf.com/content/ICCV2023/papers/Bae_PNI__Industrial_Anomaly_Detection_using_Position_and_Neighborhood_Information_ICCV_2023_paper.pdf
- UniVAD: 부품 단위 graph-enhanced modeling으로 여기 제안한 패치 이웃 그래프와 노드 단위가 다르다. https://openaccess.thecvf.com/content/CVPR2025/papers/Gu_UniVAD_A_Training-free_Unified_Model_for_Few-shot_Visual_Anomaly_Detection_CVPR_2025_paper.pdf

새 시각화/원시 측정 없음. 다음 결정: 사용자가 실험을 요청하면 제한된 국소 관계 비교부터 구체화.

- `tools/probe_cable_relations.py` SHA256 `eb3ea7fd3d604cec0b8b2241e69d852b284ae179ee83fbd2629fa12d788b19e2`
- `docs/CABLE_COMPONENT_GRAPH.md` SHA256 `d28b00ba4d8a5e930831e1a1fbce2b8a8f3a73b9f898d21c5d18c4132b901cdd`