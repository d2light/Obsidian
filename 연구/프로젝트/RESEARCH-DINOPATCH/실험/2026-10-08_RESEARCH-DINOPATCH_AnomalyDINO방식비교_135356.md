# dinopatch와 AnomalyDINO 구현 비교

질문: 현재 DINO 패치 방식과 AnomalyDINO가 다른가?
결론: 고정 DINOv2 패치 특징→정상 메모리→최근접 코사인 거리라는 핵심 구조는 같다. 독립적인 새 모델 계열로 분류하는 것은 부정확하므로 공식 기준선·구현 차이 비교 대상으로 정정한다.

비교 범위는 최근 screw 실험 tools/prepare_model_candidate_fusion.py의 train_patch 및 proposals. 라이브러리 전체 기능과 활성 실험을 구분했다.
- 현재: HF dinov2-with-registers-base, 마지막 패치 특징 L2 정규화, 전체700(50×50), 정상FIT256/CAL64, greedy coreset30000. 해당 실행은 마스킹·회전 증강 없음. 3×3 평균 평활 후 최대값을 이미지 점수로 사용하고 CAL로 보정한다.
- 라이브러리 score.py에는 상위1% 평균(min5/max20)도 있으나 최근 screw 비교 경로와 다르다. 별도 회전·배경 실험 결과를 이번 실행에 적용했다고 주장하지 않는다.
- AnomalyDINO 공식: 고정 DINOv2+정상 패치 메모리+최근접 거리. 공식 detection.py는 L2정규화 후 FAISS 제곱거리/2로 코사인 거리를 계산한다. 상위1% 평균 집계, 선택적 PCA 전경 처리 및 정상 참조 회전 증강. README agnostic 설정은 적용 가능한 마스킹과 회전 증강을 설명한다. 소수 정상 1/2/4/8/16장 평가가 중심이며 full-shot도 논문에서 다룬다. 대표 논문 설정 S448/S672는 현재 B700과 동일 조건이 아니다.
- 두 방식 모두 최근접 검색 단계에서 부품의 순서·일대일 대응을 명시적으로 강제하지 않는다. DINO 특징 자체에는 문맥이 담기지만 cable swap 해결을 보장하지 않는다는 추론.

변경: 코드·가중치 변경 없음. 성능 재측정 없음. 다음 단계는 같은 데이터·백본 조건으로 마스킹/회전/점수집계/메모리 선택을 분리 비교. 서로 다른 학습 이미지 수의 논문 수치를 바로 비교하지 않는다.
출처: https://github.com/dammsi/AnomalyDINO , https://github.com/dammsi/AnomalyDINO/blob/main/src/detection.py , https://arxiv.org/html/2405.14529v2
원격 main은 조회 시점 내용이며 커밋 고정은 하지 않았다. 신규 시각화 없이 코드 비교만 수행.

- 로컬 `dinopatch/features.py` SHA256 `0311882c2a3700665dcfc53f35ce8958adfac73784fd2a9d855c07ddc43b9b9f`
- 로컬 `dinopatch/bank.py` SHA256 `b4af7c49e705b9bffca64c19cf49cdbec82ec338a99034a5d91ef0be500df95f`
- 로컬 `dinopatch/score.py` SHA256 `41499421039699a0c89d25be11b598946f24b6006feeed73897ea2539d0814d3`
- 로컬 `tools/prepare_model_candidate_fusion.py` SHA256 `89530a81d273f7dea413dfa9d41730f2fc4dc2bb59a6447a53549bf2f8ce9f2f`