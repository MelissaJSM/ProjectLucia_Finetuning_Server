# Base Image: CUDA 12.8
FROM nvidia/cuda:12.8.0-cudnn-devel-ubuntu22.04

# 상호작용 방지 및 언어 설정
ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    PYTHONUNBUFFERED=1

# 1. 시스템 패키지 설치
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 python3.10-dev python3-pip \
    git wget nano curl build-essential cmake ninja-build \
    libcurl4-openssl-dev libssl-dev fonts-nanum \
    libglib2.0-0 libgl1-mesa-glx \
    libxcb-xinerama0 libxkbcommon-x11-0 libxcb-cursor0 libxcb-icccm4 \
    libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 \
    libxcb-xfixes0 libxcb-shape0 libfontconfig1 libdbus-1-3 \
    && ln -s /usr/bin/python3.10 /usr/bin/python \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. uv 설치
RUN pip install uv

# [변경] 3. 가상환경 생성 생략 (시스템 전역 사용)
# --system 플래그를 사용하여 시스템 파이썬에 직접 설치합니다.

# 4. PyTorch 설치
RUN uv pip install --system torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0 \
    --index-url https://download.pytorch.org/whl/cu128

# 5. 특수 Wheel 파일 설치
RUN uv pip install --system \
    https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl \
    https://github.com/turboderp-org/exllamav3/releases/download/v0.0.23/exllamav3-0.0.23+cu128.torch2.8.0-cp310-cp310-linux_x86_64.whl

# 6. 일반 라이브러리 일괄 설치
RUN uv pip install --system \
    notebook ipywidgets hf_xet \
    wordsegment \
    python-multipart \
    PyQt5 pytz flask ddgs nvidia-ml-py trafilatura \
    mysql-connector-python fastapi transformers \
    "uvicorn[standard]" ffmpeg-python librosa pytorch_lightning \
    matplotlib x_transformers peft jieba fast_langdetect g2p_en \
    split_lang cn2an pypinyin jieba_fast pyopenjtalk jamo ko_pron g2pk2 python-mecab-ko onnxruntime-gpu opencc \
    ddgs exllamav3

# 7. Playwright 브라우저(Chromium) 및 시스템 의존성 설치
RUN playwright install chromium && \
    playwright install-deps && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 8. NLTK 데이터 다운로드 (시스템 파이썬 사용)
RUN python -m nltk.downloader averaged_perceptron_tagger_eng

# 작업 디렉토리 설정
WORKDIR /workspace

CMD ["/bin/bash"]


