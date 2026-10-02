---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [SAM_CABLE_PROMPT_PROBE.md](file:///E:/DH/Sandbox/Dinopatch/docs/SAM_CABLE_PROMPT_PROBE.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# SAM 2 케이블 부품 분할 확인

최종 보고서: `output/comparisons/sam2_cable_prompt_20260929_171417/index.html`.

## 수행 조건

- 기존 정상 FIT 000/003/007, 총 3장만 사용했다. calibration/test는 평가하지 않았다.
- 캐시된 `facebook/sam2.1-hiera-small`, revision `ee5bba1d82bb8749febdf90f45e84b687142ba03`를 Transformers 4.57.5에서 실행했다. API 호출이나 새 모델 학습은 없다.
- CUDA FP32, TF32 비활성. 캐시 config의 model_type은 sam2_video여서 이미지 모델 로딩 경고가 발생하지만 loading_info의 missing/unexpected/mismatched/error 항목은 모두 비어 있음을 확인했다.
- 이미지별 내부 케이블 3개에 에이전트가 점/박스를 수동 지정했다. 사람 검수 정답이 아니며 자동 위치 검출을 수행하지 않았다.
- 조건은 점 1개, 박스, 박스+피복 점 3개+금속 중심 제외 점 1개다. 박스는 부품 전체, 마지막 조건은 피복만을 목표로 하므로 동일 목표의 정확도 비교가 아니다.
- 각 프롬프트의 후보 마스크 3개를 모두 보존하고 모델 품질 점수 최대 마스크를 표시했다. 총 선택 마스크 27개, 후보 81개. 모델 점수는 실측 IoU나 결함 확률이 아니다.

## 시각적으로 확인한 내용

박스로 지정한 경우 세 이미지의 내부 케이블 외곽을 각각 대체로 따라갔다. 이전 원형 근사보다 실제 외곽을 잘 표현하는 모습이다. 단, 정밀 마스크 정답이 없으므로 9/9 정확도 같은 수치는 주장하지 않는다. 000의 갈색 부품 주변 잔여 영역 등 오류도 존재한다.

피복과 금속 중심을 분리하는 것은 일관되지 않았다. 003의 파란 부품은 제외 점이 있어도 금속 중심을 포함하는 마스크가 선택됐다. 한 번의 제외 점으로 모든 금속 가닥을 제거하지 못하는 사례도 있다. 부품 외곽 분할과 피복 전용 마스크는 별도의 검증 대상이다.

초기 실행 `171312`에서 000 파랑, 007 노랑의 점 1개 조건이 작은 조각을 선택했다. 시각 검토상 해당 점들이 금속 경계에 가까워, 피복 내부로 옮겨 `171417`을 별도 실행했다. 기존 실행을 삭제하지 않았다. 수정 후 큰 부품 영역이 선택됐다. 따라서 초기 실패를 SAM 자체의 분할 실패로만 해석하면 안 된다. FIT에서 프롬프트를 조정한 탐색 결과이며 미관측 평가가 아니다.

## 검증과 한계

원본 SHA256 및 복사 이미지 픽셀, canonical FIT 소속, 27개 행/81개 마스크, 선택 규칙, 원본 해상도, CSV/JSON 일치와 보고서 링크를 검증했다. 실행 코드와 프롬프트, 모델 파일 해시를 기록했다. 지연 시간은 이미지 인코딩 포함 모델 forward의 GPU 동기화 구간이며 전처리/후처리/저장을 포함하지 않는다. 손실·AUROC·분할 IoU·불량 검출률은 산출하지 않았다.

분할 가능성은 확인했지만 자동화와 조도/회전 강건성, 중복 색상 부품 및 실제 결함 검출은 아직 검증하지 않았다. 다음 후보는 정상 기준에서 부품 위치를 자동으로 찾아 SAM 박스/점을 제공하는 방식이다. 최종 결함 검사는 원본과 경계 주변도 유지해야 한다.

```powershell
.venv/Scripts/python.exe -m tools.probe_sam_cable
.venv/Scripts/python.exe -m tools.probe_sam_cable --validate output/comparisons/sam2_cable_prompt_20260929_171417
.venv/Scripts/python.exe -m unittest tests.test_sam_cable_probe tests.test_reference_inspection
```

도구는 폐기 가능한 분할 가능성 실험이며 dinopatch 제품 모델에 적용하지 않았다. fit-only comparisons 보고서 형식으로 결과를 보존했다.
