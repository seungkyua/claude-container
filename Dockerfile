# Dockerfile
FROM node:20

# shadow 패키지 설치 (usermod, groupmod 사용 위함)
#RUN apt-get update && apt-get install -y shadow && rm -rf /var/lib/apt/lists/*

# 보안을 위해 비루트(non-root) 사용자 생성 (선택 사항이지만 권장)
#RUN useradd -m -u 1000 claude

# 기본적으로 Mac 사용자의 ID인 501, 20을 기본값으로 설정 (빌드 시 변경 가능)
ARG USER_ID=502
ARG GROUP_ID=20
ARG USER_NAME=ask.ahn

# 1. 시스템 패키지 업데이트 및 필요한 도구 설치
# python3, sudo, bash는 기본 포함되거나 추가 설치됨
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    sudo \
    bash \
    && rm -rf /var/lib/apt/lists/*

# 1. 기존 node 사용자 삭제
# 2. 그룹 ID가 이미 존재하면 그 이름을 쓰고, 없으면 새로 생성
# 3. 사용자 생성 및 해당 그룹 할당
RUN userdel -r node || true && \
    CURRENT_GROUP=$(getent group ${GROUP_ID} | cut -d: -f1) && \
    if [ -z "$CURRENT_GROUP" ]; then \
        groupadd -g ${GROUP_ID} ${USER_NAME}; \
        CURRENT_GROUP=${USER_NAME}; \
    fi && \
    useradd -l -u ${USER_ID} -g ${CURRENT_GROUP} -m -s /bin/bash ${USER_NAME} && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


# Claude Code CLI 설치
RUN npm install -g @anthropic-ai/claude-code

# 작업 디렉토리 설정 및 소유권 변경
WORKDIR /workspace

# 변수 대신 생성된 사용자의 권한을 직접 부여 (가장 안전)
RUN chown -R ${USER_ID}:${GROUP_ID} /workspace

# 사용자 전환
USER ${USER_NAME}

# 기본 쉘을 bash로 설정
ENV SHELL=/bin/bash

# 실행 명령
#ENTRYPOINT ["claude"]
CMD ["sleep", "3153600000"]