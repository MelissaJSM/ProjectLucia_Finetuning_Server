# Base Image: 최신 CUDA 13.0 및 Ubuntu 24.04 적용
FROM nvidia/cuda:13.0.0-cudnn-devel-ubuntu24.04

# 상호작용 방지 및 언어 설정
ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    PYTHONUNBUFFERED=1

# 1. 시스템 패키지 설치 및 Python 3.13 강제 설치 (pip 주입 포함)
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common git wget nano curl build-essential cmake ninja-build \
    libcurl4-openssl-dev libssl-dev fonts-nanum \
    libglib2.0-0 libgl1 \
    libxcb-xinerama0 libxkbcommon-x11-0 libxcb-cursor0 libxcb-icccm4 \
    libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 \
    libxcb-xfixes0 libxcb-shape0 libfontconfig1 libdbus-1-3 \
    mecab libmecab-dev mecab-ipadic-utf8 \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update \
    && apt-get install -y --no-install-recommends python3.13 python3.13-dev python3.13-venv \
    && ln -sf /usr/bin/python3.13 /usr/bin/python \
    && ln -sf /usr/bin/python3.13 /usr/bin/python3 \
    # 🔥 Python 3.13 전용 pip 강제 수혈
    && wget https://bootstrap.pypa.io/get-pip.py \
    && python3.13 get-pip.py \
    && rm get-pip.py \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. uv 초고속 패키지 매니저 설치
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && mv /root/.local/bin/uv /usr/local/bin/uv

# 3. PyTorch 설치 (CUDA 13.0 대응 최신 버전)
RUN uv pip install --system torch==2.10.0 torchvision==0.25.0 torchaudio==2.10.0 \
    --index-url https://download.pytorch.org/whl/cu130

# 4. 특수 Wheel 파일 설치 (회원님의 커스텀 flash-attn 2.8.3)
RUN uv pip install --system https://github.com/MelissaJSM/build_flash_attn/releases/download/whl/flash_attn-2.8.3+cu130torch2100-cp313-cp313-linux_x86_64.whl

# 5. 일반 라이브러리 일괄 설치
RUN uv pip install --system \
    notebook ipywidgets hf_xet wordsegment python-multipart \
    pytz flask ddgs nvidia-ml-py trafilatura \
    mysql-connector-python fastapi transformers soundfile \
    "uvicorn[standard]" ffmpeg-python librosa pytorch_lightning \
    matplotlib x_transformers peft jieba fast_langdetect g2p_en \
    split_lang cn2an pypinyin jieba_fast pyopenjtalk jamo ko_pron g2pk2 python-mecab-ko onnxruntime-gpu opencc \
    packaging ninja wheel setuptools nltk

# 6. exllamav3 최신 소스코드 설치
RUN uv pip install --system git+https://github.com/turboderp-org/exllamav3.git

# 7. NLTK 데이터 다운로드 (순서 당김)
RUN python -m nltk.downloader averaged_perceptron_tagger_eng

# 작업 디렉토리 설정
WORKDIR /workspace

CMD ["/bin/bash"]
