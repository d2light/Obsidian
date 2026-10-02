---
type: source-snapshot
project: Dinopatch
imported: 2026-10-02
---

> 원문 스냅샷. 기록 안의 당시 결론은 이후 실험에서 바뀔 수 있습니다.
> 출처: [REASONING_REPRODUCE_20261001.md](file:///E:/DH/Sandbox/Dinopatch/docs/REASONING_REPRODUCE_20261001.md) · 가져온 날짜는 실험 날짜가 아닙니다. 로컬 경로 링크는 이 PC에서만 열립니다.

# 근거 기반 검사 실험 재현

작업 디렉터리는 `E:\DH\Sandbox\Dinopatch`이며 아래 명령은 PowerShell에서 실행한다. Python은 `.venv\Scripts\python.exe`, 모델은 로컬 Hugging Face 캐시를 사용한다. 원본 데이터·과거 결과는 덮어쓰지 않고 실행마다 새 폴더를 만든다. 각 결과 폴더의 코드 사본과 모델 revision이 해당 실행의 최종 근거다. 현 코드는 이후 검증·보고서 수정이 포함될 수 있다.

## Cable 핵심 비교

```powershell
.venv\Scripts\python.exe -m tools.experiment_reasoning_visual --limit 0
.venv\Scripts\python.exe -m tools.experiment_reasoning_augmentation --source output\comparisons\reasoning_visual_20261001_000825
.venv\Scripts\python.exe -m tools.experiment_reasoning_structure --visual output\comparisons\reasoning_visual_20261001_000825
.venv\Scripts\python.exe -m tools.experiment_reasoning_fusion --visual output\comparisons\reasoning_augmentation_20261001_002345 --structure output\comparisons\reasoning_structure_20261001_002019 --component both
.venv\Scripts\python.exe -m tools.experiment_reasoning_fusion --visual output\comparisons\reasoning_augmentation_20261001_002345 --structure output\comparisons\reasoning_structure_20261001_002019 --component color
.venv\Scripts\python.exe -m tools.experiment_reasoning_fusion --visual output\comparisons\reasoning_augmentation_20261001_002345 --structure output\comparisons\reasoning_structure_20261001_002019 --component geometry
.venv\Scripts\python.exe -m tools.experiment_reasoning_relations --source output\comparisons\reasoning_structure_20261001_002019
```

경로는 이번 완료 실행을 가리킨다. 새로 재실행한 결과를 조합하려면 출력된 새 경로로 바꾼다. `--limit 0`을 생략하면 visual 실험은 기본 소규모 표본만 평가한다. Canonical split은 정상 FIT179/CAL45, 개발 평가150(정상58/NG92)이며 마지막 평가150은 새로운 독립 holdout이 아니다.

## 정합·VLM

```powershell
.venv\Scripts\python.exe -m tools.experiment_reasoning_visual --limit 0 --sam-structure output\comparisons\reasoning_structure_20261001_002019 --sam-mode validated_color_identity --raw-baseline output\comparisons\reasoning_visual_20261001_000825
.venv\Scripts\python.exe -m tools.audit_reasoning_pose --source output\comparisons\reasoning_visual_sam_20261001_010031
.venv\Scripts\python.exe -m tools.experiment_reasoning_vlm --visual output\comparisons\reasoning_visual_20261001_000548 --structure output\comparisons\reasoning_structure_20261001_000809 --coordinate-grid 1000 --model Qwen/Qwen3-VL-4B-Instruct
```

VLM 비교는18개 원본의 원본·복합 조건, 총36개 입력을 두 프롬프트로 평가한다. 학습된 추론기나 VLM 도구 호출 에이전트 전체 구현이 아니다. 수치 모델의 판정을 바꾸지 않는다. SAM 자세 추정에 색상 대응을 사용하는 모드는 초기 색상 비사용 설계와 구분된 명시적 실험 대안이다.

## 실제 검사 데이터

```powershell
.venv\Scripts\python.exe -m tools.experiment_industrial_reasoning --cohort iv_ring
.venv\Scripts\python.exe -m tools.experiment_industrial_reasoning --cohort bolt_cam1
.venv\Scripts\python.exe -m tools.report_industrial_calibration --source output\experiments\DinoPatch_20261001_004646_iv_ring_normal_baseline_full_ls392
.venv\Scripts\python.exe -m tools.report_industrial_calibration --source output\experiments\DinoPatch_20261001_004719_bolt_cam1_normal_baseline_full_ls392
.venv\Scripts\python.exe -m tools.experiment_industrial_supervised --source output\experiments\DinoPatch_20261001_004646_iv_ring_normal_baseline_full_ls392
.venv\Scripts\python.exe -m tools.experiment_industrial_stress --source output\comparisons\industrial_supervised_20261001_005309
```

분할만 확인하려면 현장 실험에 `--prepare-only`를 붙인다. 볼트는 동일 카메라/해상도만, IV는 시간 분 그룹과 RGB 중복을 묶는다. IV 정상 전용 모델에서 제외한 FIT 그룹 NG196장을 지도학습 비교에만 사용한다. CAL 그룹 NG104장은 계속 미평가다. 합성 변형의 라벨은 확정된 새 정답이 아니며 원본 라벨을 가정한 민감도 분석이다.

## 검증 및 기록

```powershell
.venv\Scripts\python.exe -m unittest discover -s tests -p test_reasoning*.py
.venv\Scripts\python.exe -m unittest discover -s tests -p test_industrial*.py
.venv\Scripts\python.exe -m unittest discover -s tests -p test_artifact_atomic_retry.py
.venv\Scripts\python.exe tools/validate_experiment_artifacts.py --run output\experiments\DinoPatch_20261001_004646_iv_ring_normal_baseline_full_ls392
.venv\Scripts\python.exe tools/validate_experiment_artifacts.py --run output\experiments\DinoPatch_20261001_004719_bolt_cam1_normal_baseline_full_ls392
```

비교 실험은 자체 검증 로그와 전체 파일 SHA256 manifest를 남긴다. 일반 현장 기준모델은 공통 artifact validator도 통과해야 한다. 초기 샘플 선택 오류·Windows 파일 잠금 실패·수정 전 시각화 문제를 포함한 진행 이력은 `REASONING_EXPERIMENT_LOG_20260930.md`에 보존한다. 완료된 실험을 수정하지 말고, 후처리 보고서는 별도 폴더로 생성한다.

추가 실험 전 필요한 실제 정보: 제품별 허용 회전/구성 규칙, 실제 독립 촬영 세션 또는 제품 식별자, 볼트의 더 많은 결함 표본, IV 결함 영역 라벨. 이러한 정보가 없으면 모든 환경의 100% 성능이나 정확한 결함 경계를 주장하지 않는다.

## 추가 부품 확대 비교

완료된 확대 실험은 `reasoning_parts_20261001_012334`이며 아래 명령으로 모델 실험, 통합 및 판단 근거를 재생성할 수 있다.

```powershell
.venv\Scripts\python.exe -m tools.experiment_reasoning_parts --source output\comparisons\reasoning_structure_20261001_002019
.venv\Scripts\python.exe -m tools.experiment_reasoning_fusion --visual output\comparisons\reasoning_augmentation_20261001_002345 --structure output\comparisons\reasoning_structure_20261001_002019 --component color --parts output\comparisons\reasoning_parts_20261001_012334
.venv\Scripts\python.exe -m tools.report_reasoning_trace --fusion output\comparisons\reasoning_fusion_20261001_013056
```

이 추가 분기는 전체 개선에 실패한 비교군이다. 새 출력 폴더 이름은 실행 시각에 따라 달라진다. 통합 보고서는 `tools/report_reasoning_experiments.py`로 생성하며 보고서의 `sources.json`에 모든 입력 경로와 manifest 해시가 보존된다. IV 시각화는 두 임계값을 올바르게 표시하는 `industrial_stress_report_20261001_012206`을 사용한다.
