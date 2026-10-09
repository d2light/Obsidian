# INP-Former++ 구현 가능성 검토

- 질문: INP-Former++를 현재 환경에서 구현 가능한가?
- 확인: 기본 INP-Former 공식 코드 및 다중/소량학습 가중치 링크 공개. 확인한 main README/Single_Class는 기본 버전 중심이며 ++ 완성 구현 및 전용 가중치는 확인하지 못함.
- ++ 추가 요소: Soft INP Coherence Loss, 합성 이상, 잔차 기반 segmentation head. 기본 구현에 논문 기반 보완 가능. 공식 ++ 완전 재현이라고 부르기 전 미공개 세부 설정을 명시해야 함.
- 공식 기본 단일학습 설정: crop392, batch16, 200epoch. 현재 nvidia-smi RTX5080 총16303MiB/가용11993MiB 확인. 실행 메모리/시간/성능 측정 없음. 배치 축소 및 혼합정밀도 적용 여부는 smoke test 후 판단.
- 저자 issue53: segmentation head 100epoch, stop-gradient로 end-to-end 학습 설명. 200+100의 고정 2단계라고 단정하지 않는다. head 채널/커널 등 일부 상세 미공개.
- 제안: 기존 정상 FIT/CAL/test를 보존한 screw 기본 모델 기준선 → ++ 손실 개선 → 잔차 head 순으로 분리 평가. 실제 NG 학습 없는 합성 조건과 Semi10 조건을 혼용하지 않음. 아직 구현/학습 시작 안 함.
- 한계: 영상99.8/픽셀98.7은 논문 통합학습 보고값이며 로컬 예상치가 아니다. swap 및 조도 강건성 보장 없음.
- 출처: https://arxiv.org/abs/2506.03660 ; https://github.com/luow23/INP-Former ; https://github.com/luow23/INP-Former/issues/53 ; https://raw.githubusercontent.com/luow23/INP-Former/main/INP_Former_Single_Class.py
- 원본 데이터/모델 변경 없음. 문헌 검토로 신규 시각화 없음.
