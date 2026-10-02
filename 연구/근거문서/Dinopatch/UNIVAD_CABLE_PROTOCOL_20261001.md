---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [UNIVAD_CABLE_PROTOCOL_20261001.md](file:///E:/DH/Sandbox/Dinopatch/docs/UNIVAD_CABLE_PROTOCOL_20261001.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# UniVAD Cable 공식 코드 기반 실행

사용자가 https://github.com/FantasticGNU/UniVAD 테스트를 요청했다. 정확도를 우선하며 속도 최적화는 후순위다.

- 공식 저장소 commit `64d32873dda44fad69786834ea5ee1394ef81975`, DINOv2 submodule `e1277af2ba9496fbadf7aec6eba56e8d882d1e35`.
- 정상 참조는 기존 FIT 분할의 `mvtec/cable/train/good/000.png` 1장. 공식 round0/k-shot1에 대응한다.
- 공식 입력448, 기존 CAL 정상45장으로 q95(higher) 기준 고정. 기존 테스트150장(정상58/불량92) 전체 평가.
- 정상 참조 및 CAL은 평가와 RGB 해시 중복0. 원본 사본을 별도 run에 만들고 원본을 수정하지 않는다.
- 같은 평가셋을 여러 개발 실험에서 관찰했으므로 독립 최종 검증으로 표현하지 않는다. 기존179FIT 모델과의 차이는 학습/참조 예산 차이도 포함한다.

실행: `output/comparisons/univad_cable_20261001_160629`.

## 공식 구성과 호환 처리

GroundingDINO와 SAM-HQ로 공식 cable prompt에 따라 사전 분할한다. 기존 SAM2 마스크를 대체 입력으로 쓰지 않는다. DINO ViT-S/8, CLIP ViT-L/14-336, DINOv2 ViT-g/14 특징과 원래 CAPM/GECM 판정 코드를 실행한다. 첫 정상 참조에서 공식 gate는 MULTI였다.

Windows/RTX5080에서 다음 호환 처리를 분리한 환경 `.venv_univad`와 실행 래퍼에 적용했다. 공식 저장소의 추적된 소스는 수정하지 않았다. 논문의 소프트웨어 환경을 완전히 동일하게 재현한 것은 아니다.

1. 원 환경을 유지하고 별도 venv에서 Transformers4.38.2 및 NumPy1.26.4를 사용한다. PyTorch는 RTX5080 지원을 위해 기존2.7.1+cu128을 공유한다.
2. GroundingDINO의 컴파일 CUDA 확장 대신 저장소에 포함된 PyTorch deformable-attention 함수를 사용한다. 가중치와 모델 구조는 유지한다.
3. DenseCRF는 Windows에서 빌드 가능한 `pydensecrf2==1.1`을 사용한다. 공식 requirements의 pydensecrf 배포본과 차이로 기록한다.
4. glob 결과의 경로 구분자를 `/`로 정규화한다.
5. 대형 패치 거리 broadcast의 GPU 메모리 사용을 줄이기 위해 공식 cosine_similarity를 query32개 단위로 나눠 계산한다. 작은 입력에서 원 함수와 bit-exact 비교 테스트를 통과했다. 백본 축소·양자화·점수 공식 변경은 하지 않는다.

가중치5개 파일 해시, 실행 라이브러리 버전, 공식 git diff 및 submodule 상태는 `logs/environment.json`에 보존한다. 파일을 인터넷에 업로드하거나 유료 API를 호출하지 않는다.

## 기록할 결과

이미지 AUROC와 정상 CAL 임계값에서 정확도·정상 오탐·불량 미탐·swap 검출을 함께 기록한다. 원본·이상맵·부품 분할, 점수 분포와 ROC를 시각화한다. 실패하면 평가에서 삭제하거나 OK로 치환하지 않고 실행 실패 또는 보류로 기록한다.

전체 추론 시간은 사전 GroundingDINO/SAM 분할을 제외하므로 현장 end-to-end 지연으로 보고하지 않는다. 첫 정상 보정 smoke는 약4초였으나 전체 속도 성능 결론은 아니다.

현재 MULTI 경로의 이미지 점수는 최종 이상맵의 최댓값에 전역 CLIP 정상 참조 거리(global_score)를 더한 값이다. 따라서 이상맵 색상만으로 전체 이미지 판정의 모든 근거를 설명하거나 맵 최댓값과 이미지 점수를 같다고 해석하지 않는다. 원본 SAM-HQ 마스크와 C³ 정제 마스크도 다른 중간 결과로 구분한다.

재현 래퍼: `tools/probe_univad.py`의 prepare → segment → infer 단계. `--limit`은 실행 연결 확인 전용이며 전체 성능 표본을 선별하는 용도가 아니다. `--root`로 동일 실행을 재개할 수 있다. `models`, `pretrained_ckpts`는 공식 저장소를 가리키는 디렉터리 junction이고 원본 데이터에는 junction을 만들지 않았다.
