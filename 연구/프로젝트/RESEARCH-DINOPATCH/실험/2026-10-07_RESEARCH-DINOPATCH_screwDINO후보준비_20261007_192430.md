# screw DINO 후보 확대 — 준비 완료

사용자가 합의한 DINOv2 고점 후보 확대 실험이다. 성능 결과는 아직 없고 VLM 추론을 시작했다.

- 공식 screw test160(정상41/NG119), train/good320, 원본 보존 및 학습/검사 해시 분리.
- DINOv2 with registers base, 700입력, frozen, 정상 패치 greedy coreset30000, seed20261007. 뱅크 구축105.60초. 정합·배경 제거·조도 처리·증강 없음.
- 원시 패치 코사인 거리를3×3평균한 고점에서 서로 IoU≤0.2인 후보3곳. 원본40%(410×410) 영역을1024로 확대. GT/라벨은 선택에 사용하지 않는다.
-160이상맵,480확대 입력 완료. 모든crop 픽셀과 좌표 재계산, 원본 해시 확인. 후보 선택·포함률 테스트4개 통과.
- Qwen3-VL 235B에 동일 정상 기준3장＋전체 검사＋후보3장(총7장). 기존 프롬프트 그대로 사용하며 후보를 확정 불량으로 알려주지 않는다. 신규160API요청, 첫10순차·이후동시4. 기존 고정4장 결과는 재사용한다.
- 기존고정4장은614×614 영역, 후보3장은410×410이므로 위치 외에도 이미지 수·배율·API시점 차이가 있다. 단일 개발 실험이며 일반화·순수 위치 선택의 인과효과를 주장하지 않는다.
- 다음: 정확도·오탐·미탐·형식 오류, GT 포함률, 후보누락과 후보포함 후 미탐 구분, 이상맵/위치/기준 전체 시각화.

실행: `E:/DH/Sandbox/Dinopatch/output/comparisons/qwen_screw_dino_crops_20261007_192430`

코드: `tools/probe_dino_candidate_crops.py`, `tools/test_dino_candidate_crops.py`. 설정·가중치해시: `run.json`, 정상뱅크: `model/detector.pt`, 검증: `logs/crop_pixel_validation.json`.

원본 데이터·인증정보·모델은 노트 저장소에 복사하지 않았다. 수동commit/push 없음.

## 후보 확정 후 GT 포함률 확인

후보 선택을 고정한 뒤 GT와 대조했다. NG119장 중118장은 일부 겹침,117장은 GT 픽셀90% 이상 포함, Q069 한 장은 완전히 누락했다. 이 값은 VLM 판독 성능이 아니다. 후보 설정은 이 결과를 보고 변경하지 않았다. 검증값: `logs/candidate_coverage_before_vlm.json`.
