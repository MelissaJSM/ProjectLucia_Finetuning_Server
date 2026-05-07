# 🎀 Project Lucia Finetuning Guide

> 💡 **안내:** 이 가이드는 기존 모델이 아닌, 사용자가 직접 데이터셋을 준비하여 모델을 학습(Fine-tuning)하고 싶은 경우에 사용합니다.
> **도커(Docker) 환경을 사용하시는 경우, 의존성 충돌 없이 완벽하게 분리된 환경에서 안전하게 학습을 진행할 수 있어 적극 권장합니다.**

## 1. 🐳 Docker 환경 (권장)

최신 환경에서는 `docker-compose.yml` 내에 Windows와 Linux 프로필이 분리되어 있으며, 로컬 폴더(`./project_lucia_docker`)가 자동으로 마운트됩니다.

### 1-1. 사전 준비
* 다운로드 받은 `Dockerfile.txt`가 있다면 확장자를 지워 `Dockerfile`로 만들어 줍니다.
* 현재 디렉토리에 `project_lucia_docker` 폴더가 없다면 미리 생성해 줍니다.

### 1-2. 컨테이너 실행 (OS별 선택)
터미널에서 파일이 있는 경로로 이동 후, 운영체제에 맞는 명령어를 입력하세요. *(파인튜닝 전용 환경변수를 강제 주입하여 실행합니다.)*

**🪟 Windows (WSL2 / PowerShell 기준):**
```powershell
$env:COMPOSE_PROFILES="windows"; $env:DOCKER_MODE="finetuning"; docker-compose up -d --build --force-recreate
```

**🐧 Linux:**
```bash
COMPOSE_PROFILES=linux DOCKER_MODE=finetuning docker compose up -d --build --force-recreate
```

### 1-3. Jupyter Lab 접속 및 학습 시작
환경 구성이 완료되면 컨테이너 내부로 접속하여 Jupyter를 실행합니다.
```bash
# 컨테이너 내부 쉘로 진입
docker exec -it lucia_finetuning bash 

# Jupyter Lab 실행
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --ServerApp.allow_origin='*' --ServerApp.iopub_data_rate_limit=1.0e10 --ServerApp.max_buffer_size=1000000000 --notebook-dir=/workspace
```
* 브라우저에서 `http://localhost:8888` 에 접속한 뒤, `/workspace/` 경로 내에 있는 `.ipynb` 파일을 실행하세요.
* ⚠️ **주의:** exllama 양자화 도중 멈췄을 경우 당황하지 마시고 노트북 커널을 초기화하신 후, exllama 블록부터 다시 시작하시면 이어서 진행됩니다.

---

## 2. 🪟 Native Windows / 🐧 Native Linux 환경

Docker를 사용할 수 없는 경우, 로컬 환경에 직접 구성하는 방법입니다.

### 2-1. 필수 프로그램 설치
1. **CUDA Toolkit 13.0** 설치
2. **Python 3.13** 가상환경 구성 (Anaconda 등 활용)
3. **GIT** 설치 (`winget install --id Git.Git -e --source winget` 또는 `sudo apt install git`)

### 2-2. 패키지 및 PyTorch 설치
터미널에서 순서대로 입력하세요.

**1. 패키지 매니저 `uv` 설치**
```bash
pip install uv
```

**2. 파인튜닝용 PyTorch 설치 (고정 버전)**
```bash
uv pip install torch==2.10.0 torchvision==0.25.0 torchaudio==2.10.0 --index-url https://download.pytorch.org/whl/cu130
```

**3. 필수 라이브러리 일괄 설치**
```bash
uv pip install notebook ipywidgets hf_xet wordsegment python-multipart PyQt5 pytz flask ddgs nvidia-ml-py trafilatura mysql-connector-python fastapi transformers soundfile "uvicorn[standard]" ffmpeg-python librosa pytorch_lightning matplotlib x_transformers peft jieba fast_langdetect g2p_en split_lang cn2an pypinyin jieba_fast pyopenjtalk jamo ko_pron g2pk2 python-mecab-ko onnxruntime-gpu opencc packaging ninja wheel setuptools nltk git+https://github.com/turboderp-org/exllamav3.git
```

**4. 파인튜닝용 Flash Attention 설치 (OS에 맞는 Wheel 주소 사용)**
```bash
# 리눅스용
uv pip install https://github.com/MelissaJSM/build_flash_attn/releases/download/whl/flash_attn-2.8.3+cu130torch2100-cp313-cp313-linux_x86_64.whl

# 윈도우용
uv pip install https://github.com/MelissaJSM/build_flash_attn/releases/download/whl/flash_attn-2.8.3+cu130torch2100-cp313-cp313-win_amd64.whl
```

### 2-3. 실행
아래 명령어로 Jupyter Lab을 실행한 뒤, `Gemma3_Lucia_exllamav3_clean.ipynb` 파일을 열어 실행하세요.
```bash
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --ServerApp.allow_origin='*' --ServerApp.iopub_data_rate_limit=1.0e10 --ServerApp.max_buffer_size=1000000000 --notebook-dir=/workspace
```

<br>

---

# 🖥️ Project Lucia Server Guide

> 💡 **안내:** 이 가이드는 학습이 완료된 모델을 로드하여 서버(추론) 용도로 구동할 때 사용합니다.
> **도커(Docker) 환경을 사용하시는 경우, 별도의 복잡한 세팅 없이 가장 안정적인 실행이 가능하므로 Docker 사용을 적극 권장합니다.**

## 1. 🐳 Docker 환경 (권장)

최신 환경에서는 `docker-compose.yml` 내에 Windows와 Linux 프로필이 분리되어 있으며, 로컬 폴더(`./project_lucia_docker`)가 자동으로 마운트됩니다.

### 1-1. 사전 준비
* 다운로드 받은 `Dockerfile.txt`가 있다면 확장자를 지워 `Dockerfile`로 만들어 줍니다.
* 현재 디렉토리에 `project_lucia_docker` 폴더가 없다면 미리 생성해 줍니다.

### 1-2. 컨테이너 실행 (OS별 선택)
터미널에서 파일이 있는 경로로 이동 후, 운영체제에 맞는 명령어를 입력하세요. *(기본값이 Server 모드로 설정되어 있어 명령어 입력이 간편합니다.)*

**🪟 Windows (WSL2 / Docker Desktop):**
```powershell
$env:COMPOSE_PROFILES="windows"; $env:DOCKER_MODE="server"; docker-compose up -d --build --force-recreate
```

**🐧 Linux:**
```bash
COMPOSE_PROFILES=linux DOCKER_MODE=server docker compose up -d --build --force-recreate
```

### 1-3. 컨테이너 접속 및 실행
```bash
# 컨테이너 내부 쉘로 진입
docker exec -it lucia_server bash 

# 이후 파일 경로를 찾아서 ui_main.py 실행
python ui_main.py
```

---

## 2. 🪟 Native Windows / 🐧 Native Linux 환경

Docker를 사용할 수 없는 경우, 로컬 환경에 직접 구성하는 방법입니다.

### 2-1. 필수 프로그램 설치
1. **CUDA Toolkit 13.0** 설치
2. **Python 3.13** 가상환경 구성 (Anaconda 등 활용)
3. **GIT** 설치 (`winget install --id Git.Git -e --source winget` 또는 `sudo apt install git`)

### 2-2. 패키지 및 PyTorch 설치
터미널에서 순서대로 입력하세요.

**1. 패키지 매니저 `uv` 설치**
```bash
pip install uv
```

**2. 서버용 PyTorch 및 torchcodec 설치**
```bash
uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu130
uv pip install torchcodec
```

**3. 필수 라이브러리 일괄 설치**
```bash
uv pip install notebook ipywidgets hf_xet wordsegment python-multipart PyQt5 pytz flask ddgs nvidia-ml-py trafilatura mysql-connector-python fastapi transformers soundfile "uvicorn[standard]" ffmpeg-python librosa pytorch_lightning matplotlib x_transformers peft jieba fast_langdetect g2p_en split_lang cn2an pypinyin jieba_fast pyopenjtalk jamo ko_pron g2pk2 python-mecab-ko onnxruntime-gpu opencc packaging ninja wheel setuptools nltk git+https://github.com/turboderp-org/exllamav3.git
```

**4. Flash Attention 설치 (OS에 맞는 Wheel 주소 사용)**
```bash
# 리눅스용
uv pip install https://github.com/MelissaJSM/build_flash_attn/releases/download/whl/flash_attn-2.8.3+cu130torch2110-cp313-cp313-linux_x86_64.whl

# 윈도우용
uv pip install https://github.com/MelissaJSM/build_flash_attn/releases/download/whl/flash_attn-2.8.3+cu130torch2110-cp313-cp313-win_amd64.whl
```

<br>

---

# 🚨 공통 오류 및 해결 안내 (Troubleshooting)

### 1. 도커 환경에서 디스플레이를 찾지 못하는 문제
Jupyter Lab이나 UI 실행 시 아래와 같은 `qt.qpa.xcb` 오류가 발생할 수 있습니다.

> `qt.qpa.xcb: could not connect to display :0`  
> `qt.qpa.plugin: Could not load the Qt platform plugin "xcb" in "" even though it was found.`  
> `This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.`  
> `Available platform plugins are: eglfs, linuxfb, minimal, minimalegl, offscreen, vnc, wayland-egl, wayland, wayland-xcomposite-egl, wayland-xcomposite-glx, webgl, xcb.`  
> `Aborted (core dumped)`

**✅ 해결 방법:**
해당 오류 발생 시, 도커 내부가 아닌 **리눅스 메인 호스트 환경의 터미널**에서 아래 명령어를 입력하여 접근 권한을 허용해 주면 해결됩니다.
```bash
xhost +local:docker
```

### 2. UI가 너무 작거나 크게 나오는 문제
**✅ 해결 방법:**
사용 중인 OS(Windows/Linux)의 디스플레이 설정에서 **비율 및 배율 조정(Scale)을 100%**로 설정하시면 정상적으로 출력됩니다.
