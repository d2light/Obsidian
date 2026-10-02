---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [PATCHCORE_ROTATION_PROBE.md](file:///E:/DH/Sandbox/Dinopatch/docs/PATCHCORE_ROTATION_PROBE.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# 공식 PatchCore: 정상 cable 회전 실험

## 결과 (2026-09-29)

실행 폴더: `output/experiments/PatchCore_20260929_142711_cable_official_patchcore_wr50_224_rotation`.

| 정상 이미지 회전 | NG 판정 / 58 | 점수/임계값 중앙값 | 원래 OK였다가 NG로 바뀐 수 |
|---|---:|---:|---:|
| 0도 | 1 | 0.800 | 0 |
| 90도 | 58 | 1.510 | 57 |
| 180도 | 58 | 1.489 | 57 |
| 270도 | 58 | 1.475 | 57 |

원본 테스트 150장: 이미지 AUROC 99.419%, TN 57 / FP 1 / TP 87 / FN 5, 정확도 96.0%. cable_swap은 8/12 검출, missing_wire는 9/10 검출, 나머지 불량 종류는 전부 검출했다. 임계값은 4.308967590332031.

이 설정은 위치 자유로운 최근접 패치 검색만으로 회전 불변성을 확보하지 못했다. 방향 변화가 정상으로 허용된다는 가정 아래 회전 테스트 오탐은 각 각도 100%다. 학습 회전 증강이나 정합은 이번에 사용하지 않았으므로 그 효과는 이 실험으로 판단할 수 없다. 전체 장면의 디지털 회전이며 실제 물체만 회전한 재촬영, 작은 각도 회전, 다른 제품으로 일반화하지 않는다.

목적: 정상 케이블의 방향만 바뀌었을 때, 위치를 고정하지 않는 패치 최근접 검색이 회전에도 안정적인지 확인한다. DINO와 결합하지 않는다.

- 공식 저장소: https://github.com/amazon-science/patchcore-inspection
- 고정 커밋: `fcaa92f124fb1ad74a7acf56726decd4b27cbcad`.
- 공식 Python 소스를 수정하지 않고 `PatchCore.fit`, `predict`, `save_to_path`, `load_from_path`를 직접 호출한다.
- README 단일 모델 설정: ImageNet V1 WideResNet50, layer2/layer3, 3x3 패치, 1024차원, approximate greedy coreset 10%, 최근접 이웃 1개.
- 공식 전처리: Resize 256 → CenterCrop 224 → ImageNet 정규화. CNN/coreset은 CUDA, FAISS exact IndexFlatL2 검색은 CPU. 현재 패키지 버전은 실행 로그에 기록한다.
- 공식 구현 점수: 패치별 최근접 **제곱 L2 거리의 최댓값**. 맵은 보간과 sigma=4 Gaussian smoothing을 거치므로, 맵 최댓값과 이미지 점수는 같지 않을 수 있다. 테스트 데이터 기반 min-max 정규화는 하지 않는다.

기존 cable 분할을 재사용한다: 정상 fit 179장, 정상 calibration 45장, official test 150장(정상 58/불량 92). seed 42. 임계값은 회전하지 않은 정상 calibration 점수의 95% 분위수(higher)로 고정한다. 공식 논문 수치나 seed 0/full-train 224장 실행의 재현은 아니다. 동일 테스트를 반복 관찰한 탐색 결과다.

정상 테스트 58장 각각에 0/90/180/270도 반시계 회전을 적용한다. `np.rot90` 픽셀 순열이므로 보간, 추가 패딩, 새 빈 모서리가 없다. 회전 이미지는 학습/보정에 사용하지 않는다. 원본을 덮어쓰지 않는다. 전체 장면을 회전하므로 물체뿐 아니라 배경 방향도 달라진다. 실제 물체만 회전한 재촬영과 완전히 같지는 않다.

합성 회전의 확정 라벨은 null, 의도 라벨은 정상(0)으로 저장한다. 방향이 검사 사양상 허용된다는 가정 아래 NG 판정 비율을 회전 오탐률로 해석한다. 232개의 독립 표본이 아니라 58개 원본의 반복 관측이다.

1024 원본에서 모델이 관찰하는 영역은 중앙 `[64:960,64:960]`이다. 원본 크기 맵의 바깥 0은 미관찰 영역의 자리표시자이며 정상 판정이 아니다. 회전 NPZ의 `valid` 마스크와 시각화의 원본 색상 테두리로 구별한다. 공통 리포트의 전체 이미지 픽셀 지표는 이 미관찰 테두리까지 포함하므로 cropped official pixel metric과 다르다. 고정 스케일 갤러리에서는 빨강이 이미지 임계값의 2배이며 결함 확률을 뜻하지 않는다.

```powershell
.venv/Scripts/python.exe -m pip install faiss-cpu
.venv/Scripts/python.exe -m unittest tests.test_patchcore_rotation tests.test_benchmark
.venv/Scripts/python.exe -m tools.probe_patchcore_rotation
```

공식 저장소가 없다면 먼저 `references/patchcore-inspection`으로 clone하고 위 커밋으로 checkout한다. 기존 baseline 이후 회전 보고서 재생성은 `--run <실험 폴더>`를 사용한다.

산출물은 `output/experiments/PatchCore_<실행시각>_cable_official_patchcore_wr50_224_rotation`에 저장한다. 공식 FAISS 인덱스와 파라미터, 실제 백본 가중치, 정상 학습 이미지와 평가 원본, 195개 baseline 점수/맵, 232개 회전 점수/맵, 원본별 4각도 비교판, 고정 임계값 대비 점수 곡선을 포함한다. 재로딩 후 정상 58장의 원본 점수와 맵을 대조하고 원본 파일 해시·공식 코드 무변경·보고서 링크를 검증한다.
