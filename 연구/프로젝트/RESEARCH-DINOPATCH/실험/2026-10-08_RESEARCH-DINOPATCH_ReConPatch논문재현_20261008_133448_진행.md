# ReConPatch WRN50 논문 기반 재현 진행

- 사용자 요청: DINO 변형 대신 논문 또는 공식 GitHub 기반으로 다시 작업.
- 공식 코드 확인: 저자 LG AI Research, CVF, arXiv에서 저자 공식 구현 링크를 찾지 못함. 검색된 travishsu/ReConPatch-TF는 비공식/WIP 명시. 이를 공식 코드로 사용하지 않음.
- 결정: 논문 기반 PyTorch 재현, 특징 집계는 논문이 따르는 공식 amazon-science/patchcore-inspection 코드(commit fcaa92f124fb1ad74a7acf56726decd4b27cbcad) 재사용. ReConPatch 공식 구현이라는 주장은 하지 않음.
- 기존 DINO variant 코드/가중치/결과 보존. WRN50 ImageNetV1 layer2+3, patch3, f512, AdamP lr1e-5/wd1e-2, cosine120epoch, coreset1%. 정상 FIT256/CAL64/test160 기존 분할 유지.
- 논문 설정과 차이/미명시: 논문 train320 대비 FIT256로 비교용 고정; g128/EMA.999/sigma.5/batch1024/b9/초기화/epoch 정의는 명시되지 않아 가정으로 고정. 정확도 재현을 주장하지 않음. Test 튜닝 없음.
- 수식 검증: 동률 포함 kNN 문맥 유사도 세트 정의, Eq7 sum/N, Eq10 reweight, 중앙 크롭 좌표/NaN 미관측 영역 단위테스트4개 통과. AdamP0.3.0 설치.
- 원본256 resize/224 center crop. 원본1024의 [64:960] 관측, 바깥은 정상으로 칠하지 않고 미관측 표시 예정. 이상맵은 bilinear+Gaussian sigma4.
- 현재 데이터 해시 확인 및 특징 추출/학습 작업 시작. 아직 성능 결과 없음. 이후120epoch 최종 모델 고정, CAL q95 판정, screw160 전체 시각화.
- 코드 tools/reconpatch_wrn.py, tools/train_reconpatch_wrn.py, tests/test_reconpatch_wrn.py.
- 실행 output/comparisons/reconpatch_wrn_paper_20261008_133448. 상태 run.json 및 model/training.csv.
- 논문 https://arxiv.org/html/2305.16713v2
- 저자 페이지 https://www.lgresearch.ai/publication/view?seq=85
- 비공식 표기 확인 https://github.com/travishsu/ReConPatch-TF
- AdamP 공식 https://github.com/clovaai/AdamP
- 시각화는 학습 완료 후 기록. 실패/결과는 별도 완료 노트로 추가.
