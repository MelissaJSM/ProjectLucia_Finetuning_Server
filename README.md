# 🎀 Project Lucia Finetuning Guide

> **안내:** 이 가이드는 기존 Hiyori 버전이 아닌, 사용자가 직접 모델을 학습(Fine-tuning)하고 싶은 경우에 사용합니다.

환경에 따라 아래 4가지 방법 중 하나를 선택하여 진행해 주세요.

---

## 1. 🪟 Native Windows 환경

### 1-1. 필수 프로그램 설치
1. **CUDA Toolkit 12.8** 설치
   - [다운로드 링크 (NVIDIA Developer)](https://developer.nvidia.com/cuda-12-8-0-download-archive?target_os=Windows&target_arch=x86_64&target_version=11&target_type=exe_local)
2. **Python 환경** 구성 (둘 중 택 1)
   - **Anaconda(Miniconda):** [다운로드 링크](https://www.anaconda.com/download/success) 설치 후 가상환경 생성
   - **Python:** 직접 설치 후 가상환경 생성

### 1-2. 라이브러리 설치
터미널(CMD/PowerShell)에서 순서대로 입력하세요.

**1. 패키지 매니저 `uv` 설치**
```bash
pip install uv
```

**2. PyTorch (CUDA 12.8 호환) 설치**
```bash
uv pip install torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0 --index-url https://download.pytorch.org/whl/cu128
```

**3. 필수 라이브러리 일괄 설치**
```bash
uv pip install notebook ipywidgets hf_xet wordsegment python-multipart PyQt5 pytz flask ddgs nvidia-ml-py trafilatura mysql-connector-python fastapi transformers soundfile "uvicorn[standard]" ffmpeg-python librosa pytorch_lightning matplotlib x_transformers peft jieba fast_langdetect g2p_en split_lang cn2an pypinyin jieba_fast pyopenjtalk jamo ko_pron g2pk2 python-mecab-ko onnxruntime-gpu opencc ddgs
```

**4. Windows용 Wheel 파일 설치 (Flash Attention & ExLlamaV3)**
*안정적인 설치를 위해 한 줄씩 순서대로 입력해 주세요.*

```bash
uv pip install https://github.com/kingbri1/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3+cu128torch2.8.0cxx11abiFALSE-cp310-cp310-win_amd64.whl
```
```bash
uv pip install https://github.com/turboderp-org/exllamav3/releases/download/v0.0.27/exllamav3-0.0.27+cu128.torch2.8.0-cp310-cp310-win_amd64.whl
```

### 1-3. 실행
아래 명령어로 Jupyter Lab을 실행한 뒤, `Gemma3_Lucia_exllamav3_clean.ipynb` 파일을 열어 실행하세요.
```bash
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --ServerApp.allow_origin='*' --ServerApp.iopub_data_rate_limit=1.0e10 --ServerApp.max_buffer_size=1000000000 --notebook-dir=/workspace
```

---

## 2. 🐳 Windows WSL2 (Docker Desktop) 환경
### 2-0 Dockerfile 수정
다운로드 받은 Dockerfile이 Dockerfile.txt 라면 확장자를 지워줍니다 (Dockerfile)

### 2-1. 설정 파일 수정 (`docker-compose.yml`)
`docker-compose.yml` 파일을 열어 `volumes` 부분을 수정합니다.

```yaml
volumes:
  # [변경] Windows 절대 경로 매핑 (역슬래시 \ 사용 가능)
  # 예: - 'c:\windows:/workspace'
  - '여기에_로컬_경로를_입력해주세요:/workspace'
```

### 2-2. 컨테이너 실행
터미널에서 해당 파일이 있는 경로로 이동 후 입력합니다.

```bash
docker compose up -d
```

### 2-3. 실행
환경 구성이 완료되면 아래 명령어로 Jupyter Lab 링크를 생성하여 접속합니다. 이후 `Gemma3_Lucia_exllamav3_clean.ipynb`를 실행하세요.

```bash
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --ServerApp.allow_origin='*' --ServerApp.iopub_data_rate_limit=1.0e10 --ServerApp.max_buffer_size=1000000000 --notebook-dir=/workspace
```

---

## 3. 🐧 Native Linux 환경

### 3-1. 라이브러리 설치
터미널에서 순서대로 입력하세요.

**1. 패키지 매니저 및 PyTorch 설치**
```bash
pip install uv

uv pip install torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0 --index-url [https://download.pytorch.org/whl/cu128](https://download.pytorch.org/whl/cu128)
```

**2. 필수 라이브러리 일괄 설치**
```bash
uv pip install notebook ipywidgets hf_xet wordsegment python-multipart PyQt5 pytz flask ddgs nvidia-ml-py trafilatura mysql-connector-python fastapi transformers soundfile "uvicorn[standard]" ffmpeg-python librosa pytorch_lightning matplotlib x_transformers peft jieba fast_langdetect g2p_en split_lang cn2an pypinyin jieba_fast pyopenjtalk jamo ko_pron g2pk2 python-mecab-ko onnxruntime-gpu opencc ddgs
```

**3. Linux용 Wheel 파일 설치 (Flash Attention & ExLlamaV3)**
*안정적인 설치를 위해 한 줄씩 순서대로 입력해 주세요.*

```bash
uv pip install https://github.com/Dao-AILab/flash-attention/releases/download/v2.8.3/flash_attn-2.8.3+cu12torch2.8cxx11abiTRUE-cp310-cp310-linux_x86_64.whl
```
```bash
uv pip install https://github.com/turboderp-org/exllamav3/releases/download/v0.0.27/exllamav3-0.0.27+cu128.torch2.8.0-cp310-cp310-linux_x86_64.whl
```

### 3-2. 실행
```bash
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --ServerApp.allow_origin='*' --ServerApp.iopub_data_rate_limit=1.0e10 --ServerApp.max_buffer_size=1000000000 --notebook-dir=/workspace
```
Jupyter Lab 접속 후 `Gemma3_Lucia_exllamav3_clean.ipynb`를 실행하세요.

---

## 4. 🐳 Linux Docker 환경

### 4-1. Docker 설치 및 설정
이미 Docker가 설치되어 있다면 이 단계는 건너뛰셔도 됩니다.

**1. Docker 설치**
```bash
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
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
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
```

### 4-2. 컨테이너 실행

다운로드 받은 Dockerfile이 Dockerfile.txt 라면 확장자를 지워줍니다 (Dockerfile)
`Dockerfile`과 `docker-compose.yml`이 있는 경로에서 실행합니다.



```bash
docker compose up -d
docker start exllama
```

### 4-3. Jupyter Lab 접속
컨테이너 내부로 진입하여 Jupyter Lab을 실행합니다.

```bash
docker exec -it exllama bash
```

(컨테이너 내부 쉘에서 입력)
```bash
jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --ServerApp.allow_origin='*' --ServerApp.iopub_data_rate_limit=1.0e10 --ServerApp.max_buffer_size=1000000000 --notebook-dir=/workspace
```



### 주의! exllama 양자화 도중 멈췄을경우 당황하지마시고 노트북 커널을 초기화 하신 후 exllama 부터 다시 시작하시면 이어서 진행합니다.

