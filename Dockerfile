# Base Image: 최신 CUDA 13.0 및 Ubuntu 24.04 적용
FROM nvidia/cuda:13.0.2-cudnn-devel-ubuntu24.04

# 상호작용 방지 및 언어 설정
ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    PYTHONUNBUFFERED=1

# 1. 시스템 패키지 설치 및 Python 3.13 강제 설치 (pip 주입 및 ffmpeg 추가)
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common git wget nano curl build-essential cmake ninja-build \
    libcurl4-openssl-dev libssl-dev fonts-nanum \
    libglib2.0-0 libgl1 \
    libxcb-xinerama0 libxkbcommon-x11-0 libxcb-cursor0 libxcb-icccm4 \
    libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 \
    libxcb-xfixes0 libxcb-shape0 libfontconfig1 libdbus-1-3 \
    mecab libmecab-dev mecab-ipadic-utf8 \
    ffmpeg \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update \
    && apt-get install -y --no-install-recommends python3.13 python3.13-dev python3.13-venv \
    && ln -sf /usr/bin/python3.13 /usr/bin/python \
    && ln -sf /usr/bin/python3.13 /usr/bin/python3 \
    && wget https://bootstrap.pypa.io/get-pip.py \
    && python3.13 get-pip.py \
    && rm get-pip.py \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. uv 초고속 패키지 매니저 설치
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && mv /root/.local/bin/uv /usr/local/bin/uv

# =========================================================
# 🔥 [분기점 설정] Compose 파일에서 전달받는 인자 (기본값: server)
ARG DOCKER_MODE="server"

# 3 & 4. 환경변수(ARG)에 따른 PyTorch 및 특수 Wheel 파일 분기 설치
RUN if [ "$DOCKER_MODE" = "server" ]; then \
        echo ">>> [SERVER 모드] PyTorch 최신 버전 및 flash-attn (torch2110) 설치를 진행합니다." && \
        uv pip install --system torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu130 && \
        uv pip install --system https://github.com/MelissaJSM/build_flash_attn/releases/download/whl/flash_attn-2.8.3+cu130torch2110-cp313-cp313-linux_x86_64.whl; \
    elif [ "$DOCKER_MODE" = "finetuning" ]; then \
        echo ">>> [FINE_TUNE 모드] PyTorch 2.10.0 고정 버전 및 flash-attn (torch2100) 설치를 진행합니다." && \
        uv pip install --system torch==2.10.0 torchvision==0.25.0 torchaudio==2.10.0 --index-url https://download.pytorch.org/whl/cu130 && \
        uv pip install --system https://github.com/MelissaJSM/build_flash_attn/releases/download/whl/flash_attn-2.8.3+cu130torch2100-cp313-cp313-linux_x86_64.whl; \
    else \
        echo "❌ 에러: 알 수 없는 DOCKER_MODE 값입니다 ($DOCKER_MODE). server 또는 finetuning을 입력하세요." && exit 1; \
    fi
# =========================================================

# 5. 일반 라이브러리 공통 설치 (여기서 torchcodec은 제외됨)
RUN uv pip install --system \
    notebook ipywidgets hf_xet wordsegment python-multipart \
    pytz flask ddgs nvidia-ml-py trafilatura \
    mysql-connector-python fastapi transformers soundfile \
    "uvicorn[standard]" ffmpeg-python librosa pytorch_lightning \
    matplotlib x_transformers peft jieba fast_langdetect g2p_en \
    split_lang cn2an pypinyin jieba_fast pyopenjtalk jamo ko_pron g2pk2 python-mecab-ko onnxruntime-gpu opencc \
    packaging ninja wheel setuptools nltk PyQt5

# =========================================================
# 🔥 5-1. SERVER 모드 전용 설치 (torchcodec 분리)
RUN if [ "$DOCKER_MODE" = "server" ]; then \
        echo ">>> [SERVER 모드] 멀티모달 확장을 위한 torchcodec을 추가 설치합니다." && \
        uv pip install --system torchcodec; \
    fi
# =========================================================

# 🔥 빌드 시 GPU 자동 감지 실패 방지 환경 변수
ENV TORCH_CUDA_ARCH_LIST="8.0;8.6;8.9;9.0+PTX" \
    CUDA_HOME="/usr/local/cuda"

# 6. xformers 공식 저장소에서 직접 빌드 및 설치
RUN python -m pip uninstall xformers -y || true \
    && python -m pip install -v -U git+https://github.com/facebookresearch/xformers.git@main#egg=xformers

# 7. exllamav3 메인 브랜치 빌드
RUN rm -rf exllamav3 && \
    git clone https://github.com/turboderp-org/exllamav3.git && \
    cd exllamav3 && \
    uv pip install --system --no-build-isolation .

# 8. NLTK 데이터 다운로드
RUN python -m nltk.downloader averaged_perceptron_tagger_eng

# 작업 디렉토리 설정
WORKDIR /workspace

CMD ["/bin/bash"]
