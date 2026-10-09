# E드라이브 전체 용량 조사

- 질문: E 전체에서 추가 용량을 어떻게 확보할 수 있는가?
- 범위/방법: E 전체 WinDirStat 2.9.2 /SaveTo NTFS 읽기 전용 스캔. 파일 8,574,468개, 폴더 423,067개. 원시 CSV 행 수 검증. 디스크 실제 여유는 시점에 따라 변하며 다른 세션 정리 진행 중.
- 확인: Gitlab772.56GiB, TEST647.85GiB, JEON427.30GiB, Sandbox413.24GiB. D/E는 같은10TB HDD의 파티션이며 C는 별도NVMe.
- 핵심: 옛 OCR LMDB3개가307.2GiB를 점유하지만 last_pgno 기반 사용 페이지 범위는549.13MiB. 읽기전용·lock=False·create=False 검사했고 파일 크기/수정시각 불변. 엔트리 train63001/val18001/test9001.
- 판단: compact copy 후 전체키/값·레코드 수·로더 검증에 통과하면 약306.66GiB 회수 가능성이 큼. 이는 메타데이터 기반 예상치이며 실제 압축 실험은 아직 하지 않음. 원본 삭제/이동/압축 미실행.
- 기타 후보: samurai full_data.zip65.84GiB, ImageNet폴더158.89GiB(원본 보존·공용루트 이전), venv계열50곳182.98GiB(활성환경 제외), build50.37GiB/dist79.57GiB(패키지 필수파일 포함 가능), 휴지통7.94GiB. 후보끼리 중첩되므로 합산 금지.
- 실패/변경: 일반 순회와 diskusage는857만개 파일·HDD I/O 경쟁 때문에 오래 걸려 중단. 자동 승인에서 복합 준비명령이 거절됐으나 설정변경/프로세스종료를 뺀 읽기전용 스캔 명령은 허용되어 공식 도구로 전체 집계 완료. 초기 휴지통7.4GiB는 이후 전체 스캔7.94GiB로 갱신됨. 다른 정리 작업 영향과 도구/시점 차이로 이전 값을 조용히 대체하지 않음.
- 제한: 스캔 중 파일 변경 가능. CSV hardlink별 합산은 실제 고유할당량과 다를 수 있음. 동일 이름/크기는 중복 증명이 아님. LMDB 메타정보 검사는 전체 데이터 정합성 검사가 아님.
- 데이터/평가 설정: 모델 학습·분할·임계값 변경 없음. 학습은 기존백그라운드 작업 유지.
- 다음: OCR DB의 compact 복사 검증을 우선 제안. 사용자 작업 지시 후 원본 보존 상태에서 진행. 이후 비활성환경/빌드 산출물과 대형 보관본 정리.
- 출처: E:/DH/Sandbox/Dinopatch/output/drive_audit_20261009/REPORT.md, summary.json, groups.json, lmdb_metadata.json, provenance.json.
- 보관: 전체파일목록1.49GiB 임시CSV는 행 수·SHA256 기록 후 제거. 요약 약1MiB와JPG만 보존하며 전체 목록은 연구저장소에 포함하지 않음.
- 방법 자료: https://github.com/windirstat/windirstat/wiki/Command-Line-and-CSV ; https://lmdb.readthedocs.io/en/latest/#lmdb.Environment.copy

![[../첨부/20261009_034638_E드라이브용량.jpg]]
