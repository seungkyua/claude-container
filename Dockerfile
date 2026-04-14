# Dockerfile
FROM node:20

# 기본적으로 Mac 사용자의 ID인 501, 20을 기본값으로 설정 (빌드 시 변경 가능)
# 기본값 설정 (빌드 시 --build-arg로 변경 가능)
ARG USER_ID=502
ARG GROUP_ID=20
ARG USER_NAME=ask.ahn

# 필수 시스템 패키지 설치
# curl, git(플러그인용), procps(프로세스 관리), vim 추가
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    openjdk-17-jdk \
    golang-go \
    sudo \
    bash \
    curl \
    unzip \
    git \
    procps \
    vim \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 사용자 홈 디렉토리 베이스(/Users) 생성
RUN mkdir -p /Users

# 기존 node 사용자 삭제
# 그룹 ID가 이미 존재하면 그 이름을 쓰고, 없으면 새로 생성
# 기존 node 사용자 삭제 및 커스텀 사용자 생성
# -d 옵션으로 macOS와 동일한 /Users/ 경로를 홈으로 지정
RUN userdel -r node || true && \
    CURRENT_GROUP=$(getent group ${GROUP_ID} | cut -d: -f1) && \
    if [ -z "$CURRENT_GROUP" ]; then \
        groupadd -g ${GROUP_ID} ${USER_NAME}; \
        CURRENT_GROUP=${USER_NAME}; \
    fi && \
    useradd -l -u ${USER_ID} -g ${CURRENT_GROUP} -d /Users/${USER_NAME} -m -s /bin/bash ${USER_NAME} && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


# 사용자 전환 및 디렉토리 강제 생성
USER ${USER_NAME}
RUN mkdir -p /Users/${USER_NAME}/.local/bin


# Claude Code CLI 설치
#RUN npm install -g @anthropic-ai/claude-code
RUN curl -fsSL https://claude.ai/install.sh | bash
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# PATH 설정 (반드시 절대 경로로 확인)
ENV PATH="/Users/${USER_NAME}/.local/bin:${PATH}"


# 환경 변수 설정 (중요: 색상 및 터미널 인식 해결)
ENV TERM=xterm-256color
ENV SHELL=/bin/bash
ENV HOME=/Users/${USER_NAME}
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8


# 작업 디렉토리 설정 및 소유권 변경
#WORKDIR /workspace
WORKDIR /Users/${USER_NAME}


# 변수 대신 생성된 사용자의 권한을 직접 부여 (가장 안전)
#RUN chown -R ${USER_ID}:${GROUP_ID} /workspace


# 실행 명령
#ENTRYPOINT ["claude"]
CMD ["sleep", "3153600000"]