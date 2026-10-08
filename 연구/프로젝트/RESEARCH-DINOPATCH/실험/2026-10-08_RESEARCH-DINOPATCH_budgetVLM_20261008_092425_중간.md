# 저비용 VLM4종 실험 진행 기록

사용자 요청: GPT-6 Luna, Claude Haiku5.5, Qwen3 VL32B Instruct, Qwen3.8 Flash를 기존 screw 입력 패키지로 비교.

- 데이터: 원본 test160(OK41/NG119), 학습 정상에서 선택한 참고3장. 원본 전체+검출기 확대최대2장+윤곽 사본최대2장, 기존 일반 프롬프트. max_tokens8192, 온도/추론은 기본값. 새 학습 없음.
- 최초 공급자: Luna OpenAI, Haiku Vertex global, Qwen2종 Alibaba. deny/ZDR, fallback 금지.
- 실패: Luna·Qwen2종 첫 요청은 HTTP404 “No endpoints found matching your data policy (Zero data retention)”. 모델 판정 실패가 아니라 라우팅 제한이다. 이후 해당 모델의 대량 호출을 중단하고 최초 응답 보존.
- 진행: Haiku는 정상 실행. Luna는 별도 `luna_azure_recovery` 실행에서 Azure로만 변경하고 deny/ZDR을 유지해 호환성 성공. 두 프로세스 각각 동시4이므로 중첩 구간 전체 동시요청은 최대8이다. 최종 시간 비교에 이 조건을 명시한다.
- Qwen: 현 모델 목록에는 각 모델의 Alibaba 경로만 있어, 이번 공개 데이터에 한정하여 요청의 ZDR 제한을 해제할지 사용자에게 질문했다. 답변 전 제한 완화나 계정 변경은 하지 않는다.
- 최종 성능·비용: 아직 집계 전. 중간 결과로 결론을 내리지 않는다.
- 출처: E:/DH/Sandbox/Dinopatch/output/comparisons/screw_budget_vlms_20261008_092425, tools/probe_screw_budget_vlms.py, tools/probe_screw_vlm_models.py.
- 다음: 실행 가능한 모델을 완료하고 Qwen 설정 답변을 반영한 뒤, 전체160장 기준 오탐·미탐·보류·오류·위치·시간·비용을 시각화/기록한다. Kimi 제외 유지.
