# VLM 속도 개선 검토 — 20261007_114300

질문: Qwen3-VL235B의 cable 판정 품질을 유지하며 응답시간을 줄일 방법은 무엇인가?

## 확인된 측정
원본 실행 `E:/DH/Sandbox/Dinopatch/output/comparisons/qwen_cable_full_20261007_112918`의 predictions.json 기준이다. 순차10장 평균5.10초, 전체150장 평균5.89초. 평균 입력4241토큰, 출력93.1733토큰, 공급자 보고 평균 캐시3010.56토큰. 이 캐시가 정확히 어떤 이미지 토큰인지 별도 확인하지 않았다. 입력준비/응답완료 시간만 있어 비전인코딩·prefill·decode·서버대기 기여도를 분리할 수 없다.

## 제안 — 미실행
1. 동일235B·동일기준·동일이미지에서 설명/좌표 없이 OK/NG/REVIEW만 출력하도록 변경하고 정확도와 순차 응답시간을 비교한다. 출력제한만 낮추어 JSON을 잘라내는 방식은 사용하지 않는다. TTFT와 응답완료시간을 분리 측정한다.
2. 그다음 Qwen3-VL8B 등 작은 로컬 모델을 같은 조건에서 검증한다. 속도·메모리·미탐/오탐을 함께 측정하며 235B의 성능이 유지된다고 가정하지 않는다. 공식 모델카드는 로컬 실행 및 FlashAttention2 예시를 제공하지만 이 PC의 성능은 아직 측정하지 않았다.
3. 100ms 목표에서는 대형VLM이 보조검사/학습자료 검토를 담당하고 작은 검출기가 실시간 판정하는 구성이 후보이다. VLM 의사라벨은 정답이 아니며 검수와 독립평가가 필요하다. 재검사 경로는 여전히 느리므로 모든 최종판정100ms가 요구된다면 비동기 재검사만으로 충족했다고 주장하지 않는다. 빠른 검출기가 자신 있게 놓치는 NG도 별도 감사해야 한다.

기준 이미지 수/해상도 축소는 작은 구멍 미탐에 악영향을 줄 수 있어 첫 변경으로 선택하지 않는다. 이미 캐시가 보고돼 추가 캐시만으로 큰 개선을 기대하지 않는다. 병렬화는 처리량과 단일응답지연을 구분한다. API provider latency routing은 비교 후보지만 보장된 SLA가 아니다. 속도 개선 실험은 아직 실행하지 않았고 모델 변경도 하지 않았다.

## 출처
- [Qwen3-VL8B 공식 카드](https://huggingface.co/Qwen/Qwen3-VL-8B-Instruct)
- [OpenRouter provider routing](https://openrouter.ai/docs/guides/routing/provider-selection)
- [OpenRouter prompt caching](https://openrouter.ai/docs/guides/best-practices/prompt-caching)
- 기존 코드 `tools/evaluate_qwen_cable.py`, 실행 내 metrics.json/predictions.json.

정기18:00 동기화 대상. 별도commit/push하지 않았다.
