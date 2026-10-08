# Sonnet 오탐 근거 분석

- 질문: 정상 사례 선택, 관심 영역 밖 검사, 허용 차이 해석 중 무엇이 오탐에 기여하는가?
- 변경: 기존 결과 분석만 수행. 신규 학습/API 호출/원본 수정 없음.
- 조건: screw 원본160(OK41/NG119), 정상 train 참조3+전체 검사+확대/윤곽선. Sonnet FP8/FN0.
- 확인: 오탐8건 설명 모두 정상 사례에 없는 차이를 근거로 제시. 설명은 내부 사고과정의 증거가 아님.
- Q002 목 거친 패치; Q044 나사산 사이 격자 자국; Q083 머리 림 거칠기; Q087/Q123/Q140 가는 선·이물·버; Q158 머리 홈; Q154 몸통 선형 자국.
- Q140 낮은 확신을 명시하면서 NG. Q123은 확대 크롭이 배경이라 설명하면서 전체 이미지의 가는 선을 지적. Q002/Q123/Q140 시각화 직접 확인.
- 코드상 프롬프트는 윤곽선 밖도 검사하라고 명시. 오탐8건 중 Q044/Q087/Q123의 반환 박스 최소1개 중심은 모든 clean 확대 크롭 밖. 이는 박스 중심 기준이며 윤곽선 밖 여부와 다름.
- 참조 검색은 DINOv2 registers-base 392입력 CLS768D L2 정규화 코사인 top3. 부위 정합/마스크/회전 없음. Q002 참조 유사도0.9921/0.9912/0.9907. 전체 유사도가 높아도 세부 부위 허용 변이 대표 여부는 미검증.
- 정상은 전체만, 검사는 전체+확대인 비교 배율 비대칭이 존재. 정상 다양성 부족 및 배율 차이의 오탐 기여는 가설이며 아직 인과 실험 없음.
- 결론: 차이를 찾아도 불량 기준을 넘는지는 별도 문제. 라벨 기준 FP를 유지하며 설명의 타당성만으로 라벨 오류로 바꾸지 않음.
- 다음 제안: 정상 학습 풀에서 대응 부위 검색 및 동일 배율 정상 크롭을 제공하는 단일 변경 비교. 전체 검사는 유지. 정상 다양성/허용 기준 변경은 이후 분리 실험. FP/FN/보류 모두 집계하고 독립 데이터로 검증. 현재는 반복 관찰한 개발 세트 분석.

![[../첨부/20261008_113858_Q123.jpg]]

## 출처
- `E:\DH\Sandbox\Dinopatch\output\comparisons\screw_vlm_full_comparison_20261008_083209\combined_predictions.json` SHA256 `78517bc841001f012cde682d730e1f8d5896188851ed6a5e743bff5f722cf3a8`
- `E:\DH\Sandbox\Dinopatch\output\comparisons\vlm_anomaly_contours_20261008_004614\data\selection.json` SHA256 `f7ed21365c39c6c034f9896177b4fd3c54c437267e143c09a85dda716c747c1a`
- `E:\DH\Sandbox\Dinopatch\tools\prepare_dino_references.py` SHA256 `35bc8b2e9d8db8621b9f6680306d73d493c91a8a5364ec9b3b59617459e6df82`
- `E:\DH\Sandbox\Dinopatch\tools\probe_vlm_anomaly_contours.py` SHA256 `c745540e8f3427198fdad097f338c11177b58186cf59b7304447d8b8d06c7d29`
