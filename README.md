# 🎀 Project Lucia Finetuning Guide

> **안내:** 이 가이드는 기존 모델이 아닌, 사용자가 직접 데이터셋을 준비하여 모델을 학습(Fine-tuning)하고 싶은 경우에 사용합니다.
> **도커(Docker) 환경을 사용하시는 경우, 의존성 충돌 없이 완벽하게 분리된 환경에서 안전하게 학습을 진행할 수 있어 적극 권장합니다.**

---

## 1. 🐳 Docker 환경 (권장)

최신 환경에서는 `docker-compose.yml` 내에 Windows와 Linux 프로필이 분리되어 있으며, 로컬 폴더(`./project_lucia_docker`)가 자동으로 마운트됩니다.

### 1-1. 사전 준비
* 다운로드 받은 `Dockerfile.txt`가 있다면 확장자를 지워 `Dockerfile`로 만들어 줍니다.
* 현재 디렉토리에 `project_lucia_docker` 폴더가 없다면 미리 생성해 줍니다.

### 1-2. 컨테이너 실행 (OS별 선택)
터미널에서 파일이 있는 경로로 이동 후, 운영체제에 맞는 명령어를 입력하세요.
*(파인튜닝 전용 환경변수를 강제 주입하여 실행합니다.)*

**🪟 Windows (WSL2 / PowerShell 기준):**
```powershell
$env:DOCKER_MODE="finetuning"; docker compose --profile windows up -d --build --force-recreate
```

**🐧 Linux:**
```bash
DOCKER_MODE=finetuning docker compose --profile linux up -d --build --force-recreate
```

### 1-3. Jupyter Lab 접속 및 학습 시작
환경 구성이 완료되면 컨테이너 내부로 접속하여 Jupyter를 실행합니다.

```bash
docker exec -it lucia_finetuning bash 

jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --ServerApp.allow_origin='*' --ServerApp.iopub_data_rate_limit=1.0e10 --ServerApp.max_buffer_size=1000000000 --notebook-dir=/workspace
```
브라우저에서 `http://localhost:8888` 에 접속한 뒤, `/workspace/` 경로 내에 있는 `Gemma3_Lucia_exllamav3_clean.ipynb`를 실행하세요.

*(주의! exllama 양자화 도중 멈췄을 경우 당황하지 마시고 노트북 커널을 초기화하신 후, exllama 블록부터 다시 시작하시면 이어서 진행됩니다.)*

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
uv pip install torch==2.10.0 torchvision==0.25.0 torchaudio==2.10.0 --index-url [https://download.pytorch.org/whl/cu130](https://download.pytorch.org/whl/cu130)
```

**3. 필수 라이브러리 일괄 설치**
```bash
uv pip install notebook ipywidgets hf_xet wordsegment python-multipart PyQt5 pytz flask ddgs nvidia-ml-py trafilatura mysql-connector-python fastapi transformers soundfile "uvicorn[standard]" ffmpeg-python librosa pytorch_lightning matplotlib x_transformers peft jieba fast_langdetect g2p_en split_lang cn2an pypinyin jieba_fast pyopenjtalk jamo ko_pron g2pk2 python-mecab-ko onnxruntime-gpu opencc packaging ninja wheel setuptools nltk git+[https://github.com/turboderp-org/exllamav3.git](https://github.com/turboderp-org/exllamav3.git)
```

**4. 파인튜닝용 Flash Attention 설치 (OS에 맞는 Wheel 주소 사용)**
```bash
# (예시) 파인튜닝 전용(torch2100 호환) Flash Attention 설치
uv pip install <해당_OS용_Finetune_FlashAttention_Whl_URL>
```

### 2-3. 실행
아래 명령어로 Jupyter Lab을 실행한 뒤, `Gemma3_Lucia_exllamav3_clean.ipynb` 파일을 열어 실행하세요.
```bash
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --ServerApp.allow_origin='*' --ServerApp.iopub_data_rate_limit=1.0e10 --ServerApp.max_buffer_size=1000000000 --notebook-dir=/workspace
```



# 🖥️ Project Lucia Server Guide

> **안내:** 이 가이드는 학습이 완료된 모델을 로드하여 서버(추론) 용도로 구동할 때 사용합니다.
> **도커(Docker) 환경을 사용하시는 경우, 별도의 복잡한 세팅 없이 가장 안정적인 실행이 가능하므로 Docker 사용을 적극 권장합니다.**

---

## 1. 🐳 Docker 환경 (권장)

최신 환경에서는 `docker-compose.yml` 내에 Windows와 Linux 프로필이 분리되어 있으며, 로컬 폴더(`./project_lucia_docker`)가 자동으로 마운트됩니다.

### 1-1. 사전 준비
* 다운로드 받은 `Dockerfile.txt`가 있다면 확장자를 지워 `Dockerfile`로 만들어 줍니다.
* 현재 디렉토리에 `project_lucia_docker` 폴더가 없다면 미리 생성해 줍니다.

### 1-2. 컨테이너 실행 (OS별 선택)
터미널에서 파일이 있는 경로로 이동 후, 운영체제에 맞는 명령어를 입력하세요.
*(기본값이 Server 모드로 설정되어 있어 명령어 입력이 간편합니다.)*

**🪟 Windows (WSL2 / Docker Desktop):**
```bash
docker compose --profile windows up -d --build --force-recreate
```

**🐧 Linux:**
```bash
docker compose --profile linux up -d --build --force-recreate
```

### 1-3. 컨테이너 접속 및 실행
```bash
# 컨테이너 내부 쉘로 진입
docker exec -it lucia_server bash 

# 이후 서버 구동 스크립트 또는 Jupyter Lab을 실행하세요.
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --ServerApp.allow_origin='*'
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
uv pip install torch torchvision torchaudio --index-url [https://download.pytorch.org/whl/cu130](https://download.pytorch.org/whl/cu130)
uv pip install torchcodec
```

**3. 필수 라이브러리 일괄 설치**
```bash
uv pip install notebook ipywidgets hf_xet wordsegment python-multipart PyQt5 pytz flask ddgs nvidia-ml-py trafilatura mysql-connector-python fastapi transformers soundfile "uvicorn[standard]" ffmpeg-python librosa pytorch_lightning matplotlib x_transformers peft jieba fast_langdetect g2p_en split_lang cn2an pypinyin jieba_fast pyopenjtalk jamo ko_pron g2pk2 python-mecab-ko onnxruntime-gpu opencc packaging ninja wheel setuptools nltk git+[https://github.com/turboderp-org/exllamav3.git](https://github.com/turboderp-org/exllamav3.git)
```

**4. Flash Attention 설치 (OS에 맞는 Wheel 주소 사용)**
```bash
# (예시) Server용 Flash Attention 설치
uv pip install <해당_OS용_FlashAttention_Whl_URL>
```
