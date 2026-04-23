# 🎀 Project Lucia Finetuning Guide

> **안내:** 이 가이드는 기존 Hiyori 버전이 아닌, 사용자가 직접 모델을 학습(Fine-tuning)하고 싶은 경우에 사용합니다.

환경에 따라 아래 4가지 방법 중 하나를 선택하여 진행해 주세요. 
**도커(Docker) 환경을 사용하시는 경우, 별도의 환경 세팅 없이 통합된 스크립트로 가장 안정적인 실행이 가능합니다.**

---

## 1. 🪟 Native Windows 환경

### 1-1. 필수 프로그램 설치
1. **CUDA Toolkit 13.0** 설치
   - [다운로드 링크 (NVIDIA Developer)](https://developer.nvidia.com/cuda-13-0-0-download-archive?target_os=Windows&target_arch=x86_64)
2. **Python 환경** 구성 (Python 3.13 권장)
   - **Anaconda(Miniconda):** 설치 후 Python 3.13 가상환경 생성
   - **Python:** 직접 설치 후 가상환경 생성
3. **GIT** 설치
   ```bash
   winget install --id Git.Git -e --source winget
   ```

### 1-2. 라이브러리 설치
터미널(CMD/PowerShell), 혹은 Anaconda Prompt에서 순서대로 입력하세요.

**1. 패키지 매니저 `uv` 설치**
```bash
pip install uv
```

**2. PyTorch (CUDA 13.0 호환) 설치**
```bash
uv pip install torch torchvision torchaudio --index-url [https://download.pytorch.org/whl/cu130](https://download.pytorch.org/whl/cu130)
```

**3. 필수 라이브러리 일괄 설치**
```bash
uv pip install notebook ipywidgets hf_xet wordsegment python-multipart PyQt5 pytz flask ddgs nvidia-ml-py trafilatura mysql-connector-python fastapi transformers soundfile "uvicorn[standard]" ffmpeg-python librosa pytorch_lightning matplotlib x_transformers peft jieba fast_langdetect g2p_en split_lang cn2an pypinyin jieba_fast pyopenjtalk jamo ko_pron g2pk2 python-mecab-ko onnxruntime-gpu opencc packaging ninja wheel setuptools nltk git+[https://github.com/turboderp-org/exllamav3.git](https://github.com/turboderp-org/exllamav3.git)
```

**4. Windows용 Wheel 파일 설치 (Flash Attention)**
*(주의: 아래는 예시 링크입니다. Python 3.13 및 CUDA 13.0에 맞는 Windows용 whl 파일 경로로 수정하여 사용하세요.)*
```bash
uv pip install <Windows용_Python3.13_CUDA13.0_FlashAttention_Whl_URL>
```

### 1-3. 실행
아래 명령어로 Jupyter Lab을 실행한 뒤, `Gemma3_Lucia_exllamav3_clean.ipynb` 파일을 열어 실행하세요.
```bash
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --ServerApp.allow_origin='*' --ServerApp.iopub_data_rate_limit=1.0e10 --ServerApp.max_buffer_size=1000000000 --notebook-dir=/workspace
```

---

## 2. 🐳 Windows WSL2 (Docker Desktop) 환경

최신 환경에서는 `docker-compose.yml` 내에 Windows와 Linux 프로필이 분리되어 있으며, 로컬 폴더(`./project_lucia_docker`)가 자동으로 마운트됩니다. 별도의 경로 수정이 필요 없습니다.

### 2-0. Dockerfile 및 폴더 확인
* 다운로드 받은 `Dockerfile.txt`가 있다면 확장자를 지워 `Dockerfile`로 만들어 줍니다.
* 현재 디렉토리에 `project_lucia_docker` 폴더가 없다면 미리 생성해 줍니다.

### 2-1. 컨테이너 실행 (Windows 프로필 적용)
터미널에서 해당 파일이 있는 경로로 이동 후, **`windows` 프로필**을 명시하여 실행합니다.
*(기본적으로 `server` 모드로 실행되며, 파인튜닝 환경이 필요한 경우 환경 변수를 추가합니다.)*

**기본 실행 (Server 모드):**
```bash
docker compose --profile windows up -d --build --force-recreate
```

**파인튜닝 실행 (Finetuning 모드):**
```bash
# PowerShell 기준
$env:DOCKER_MODE="finetuning"; docker compose --profile windows up -d --build --force-recreate
```

### 2-2. Jupyter Lab 접속
환경 구성이 완료되면 브라우저를 열고 `http://localhost:8888` 에 접속합니다.
이후 `/workspace/` 경로 내에 있는 `Gemma3_Lucia_exllamav3_clean.ipynb`를 실행하세요.

*(주의! exllama 양자화 도중 멈췄을 경우 당황하지 마시고 노트북 커널을 초기화하신 후 exllama 부분부터 다시 시작하시면 이어서 진행됩니다.)*

---

## 3. 🐧 Native Linux 환경

### 3-1. 라이브러리 설치
터미널에서 순서대로 입력하세요.

**1. 패키지 매니저 및 시스템 패키지 설치**
```bash
sudo apt update
sudo apt install git ffmpeg
curl -LsSf [https://astral.sh/uv/install.sh](https://astral.sh/uv/install.sh) | sh
```

**2. PyTorch 설치 (CUDA 13.0)**
```bash
uv pip install torch torchvision torchaudio --index-url [https://download.pytorch.org/whl/cu130](https://download.pytorch.org/whl/cu130)
```

**3. 필수 라이브러리 일괄 설치**
```bash
uv pip install notebook ipywidgets hf_xet wordsegment python-multipart PyQt5 pytz flask ddgs nvidia-ml-py trafilatura mysql-connector-python fastapi transformers soundfile "uvicorn[standard]" ffmpeg-python librosa pytorch_lightning matplotlib peft jieba fast_langdetect g2p_en split_lang cn2an pypinyin jieba_fast pyopenjtalk jamo ko_pron g2pk2 python-mecab-ko onnxruntime-gpu opencc packaging ninja wheel setuptools nltk git+[https://github.com/turboderp-org/exllamav3.git](https://github.com/turboderp-org/exllamav3.git)
```
*주의: `xformers`의 경우 소스코드 빌드가 필요할 수 있습니다 (`git+https://github.com/facebookresearch/xformers.git@main#egg=xformers`).*

**4. Linux용 Wheel 파일 설치 (Flash Attention)**
```bash
uv pip install [https://github.com/MelissaJSM/build_flash_attn/releases/download/whl/flash_attn-2.8.3+cu130torch2110-cp313-cp313-linux_x86_64.whl](https://github.com/MelissaJSM/build_flash_attn/releases/download/whl/flash_attn-2.8.3+cu130torch2110-cp313-cp313-linux_x86_64.whl)
```

### 3-2. 실행
```bash
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --ServerApp.allow_origin='*' --ServerApp.iopub_data_rate_limit=1.0e10 --ServerApp.max_buffer_size=1000000000 --notebook-dir=/workspace
```
Jupyter Lab 접속 후 `Gemma3_Lucia_exllamav3_clean.ipynb`를 실행하세요.

---

## 4. 🐳 Linux Docker 환경

가장 권장하는 방식입니다. 의존성 문제가 완벽하게 해결된 이미지를 사용합니다.

### 4-1. Docker 설치 및 설정
*(이미 Docker 및 NVIDIA Container Toolkit이 설치되어 있다면 이 단계는 건너뛰셔도 됩니다.)*

**1. Docker 설치**
```bash
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL [https://download.docker.com/linux/ubuntu/gpg](https://download.docker.com/linux/ubuntu/gpg) | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] [https://download.docker.com/linux/ubuntu](https://download.docker.com/linux/ubuntu) $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
```

**2. NVIDIA Runtime 설정**
`sudo nano /etc/docker/daemon.json` 명령어로 파일을 열고 아래 내용을 추가/수정합니다.
```json
{
  "runtimes": {
    "nvidia": {
      "path": "/usr/bin/nvidia-container-runtime",
      "runtimeArgs": []
    }
  }
}
```

**3. Container Config 설정**
`sudo nano /etc/nvidia-container-runtime/config.toml` 명령어로 파일을 열고 수정합니다.
```toml
# 아래 항목을 찾아 false로 변경
no-cgroups = false
```

**4. NVIDIA Container Toolkit 설치**
```bash
curl -fsSL [https://nvidia.github.io/libnvidia-container/gpgkey](https://nvidia.github.io/libnvidia-container/gpgkey) | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L [https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list](https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list) | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
```

### 4-2. 컨테이너 실행

* 다운로드 받은 `Dockerfile.txt`가 있다면 확장자를 지워 `Dockerfile`로 만들어 줍니다.
* 현재 디렉토리에 `project_lucia_docker` 폴더가 없다면 미리 생성해 줍니다.

`Dockerfile`과 `docker-compose.yml`이 있는 경로에서 **`linux` 프로필**을 명시하여 실행합니다.

**기본 실행 (Server 모드):**
```bash
DOCKER_MODE=server docker compose --profile linux up -d --build --force-recreate
```

**파인튜닝 실행 (Finetuning 모드):**
```bash
DOCKER_MODE=finetuning docker compose --profile linux up -d --build --force-recreate
```

### 4-3. Jupyter Lab 접속
컨테이너 내부로 진입하여 Jupyter Lab을 실행합니다.

```bash
docker exec -it lucia_server bash 
# 파인튜닝 모드로 실행한 경우: docker exec -it lucia_finetuning bash
```

(컨테이너 내부 쉘에서 입력)
```bash
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --ServerApp.allow_origin='*' --ServerApp.iopub_data_rate_limit=1.0e10 --ServerApp.max_buffer_size=1000000000 --notebook-dir=/workspace
```

### 주의!
> exllama 양자화 도중 멈췄을 경우 당황하지 마시고 노트북 커널을 초기화하신 후, exllama 블록부터 다시 시작하시면 이어서 진행됩니다.
