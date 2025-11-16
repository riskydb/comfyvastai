#!/bin/bash

source /venv/main/bin/activate
COMFYUI_DIR=${WORKSPACE}/ComfyUI

# Packages are installed after nodes so we can fix them...

APT_PACKAGES=(
    #"package-1"
    #"package-2"
)

PIP_PACKAGES=(
    #"package-1"
    #"package-2"
)

NODES=(
    #"https://github.com/ltdrdata/ComfyUI-Manager"
    #"https://github.com/cubiq/ComfyUI_essentials"
    "https://github.com/Fannovel16/comfyui_controlnet_aux"
    "https://github.com/cubiq/ComfyUI_IPAdapter_plus"
    "https://github.com/Acly/comfyui-inpaint-nodes"
    "https://github.com/Acly/comfyui-tooling-nodes"
)

WORKFLOWS=(

)

declare -A CHECKPOINT_MODELS=(
    ["https://civitai.com/api/download/models/2382874?type=Model&format=SafeTensor&size=pruned&fp=fp16"]="CyberRealistic_CyberIllustrious_Semi-Realistic"
)

declare -A UNET_MODELS=(
)

declare -A LORA_MODELS=(
    ["https://huggingface.co/ByteDance/Hyper-SD/resolve/main/Hyper-SDXL-8steps-CFG-lora.safetensors"]="Hyper-SDXL-8steps-CFG-lora.safetensors"
)

declare -A VAE_MODELS=(
)

declare -A ESRGAN_MODELS=(
)

declare -A CONTROLNET_MODELS=(
    ["https://huggingface.co/Eugeoter/noob-sdxl-controlnet-scribble_pidinet/resolve/main/diffusion_pytorch_model.fp16.safetensors"]="noob-sdxl-controlnet-scribble_pidinet.fp16.safetensors"
    ["https://huggingface.co/Eugeoter/noob-sdxl-controlnet-lineart_anime/resolve/main/diffusion_pytorch_model.fp16.safetensors"]="noob-sdxl-controlnet-lineart_anime.fp16.safetensors"
    ["https://huggingface.co/Eugeoter/noob-sdxl-controlnet-softedge_hed/resolve/main/diffusion_pytorch_model.fp16.safetensors"]="noob-sdxl-controlnet-softedge_hed.fp16.safetensors"
    ["https://huggingface.co/Eugeoter/noob-sdxl-controlnet-canny/resolve/main/noob_sdxl_controlnet_canny.fp16.safetensors"]="noob_sdxl_controlnet_canny.fp16.safetensors"
    ["https://huggingface.co/Eugeoter/noob-sdxl-controlnet-depth_midas-v1-1/resolve/main/diffusion_pytorch_model.fp16.safetensors"]="noob-sdxl-controlnet-depth_midas-v1-1.fp16.safetensors"
    ["https://huggingface.co/Eugeoter/noob-sdxl-controlnet-normal/resolve/main/diffusion_pytorch_model.fp16.safetensors"]="noob-sdxl-controlnet-normal.fp16.safetensors"
    ["https://huggingface.co/Laxhar/noob_openpose/resolve/main/openpose_pre.safetensors"]="noobaiXLControlnet_openposeModel.safetensors"
    ["https://huggingface.co/Eugeoter/noob-sdxl-controlnet-tile/resolve/main/diffusion_pytorch_model.fp16.safetensors"]="noob-sdxl-controlnet-tile.fp16.safetensors"
)

declare -A UPSCALE_MODELS=(
    ["https://huggingface.co/gemasai/4x_NMKD-Superscale-SP_178000_G/resolve/main/4x_NMKD-Superscale-SP_178000_G.pth"]="4x_NMKD-Superscale-SP_178000_G.pth"
    ["https://huggingface.co/Acly/Omni-SR/resolve/main/OmniSR_X2_DIV2K.safetensors"]="OmniSR_X2_DIV2K.safetensors"
    ["https://huggingface.co/Acly/Omni-SR/resolve/main/OmniSR_X3_DIV2K.safetensors"]="OmniSR_X3_DIV2K.safetensors"
    ["https://huggingface.co/Acly/Omni-SR/resolve/main/OmniSR_X4_DIV2K.safetensors"]="OmniSR_X4_DIV2K.safetensors"
    ["https://huggingface.co/Acly/hat/resolve/main/HAT_SRx4_ImageNet-pretrain.pth"]="HAT_SRx4_ImageNet-pretrain.pth"
    ["https://huggingface.co/Acly/hat/resolve/main/Real_HAT_GAN_sharper.pth"]="Real_HAT_GAN_sharper.pth"
)

declare -A CLIP_VISION=(
    ["https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/image_encoder/model.safetensors"]="clip-vision_vit-g.safetensors"
    ["https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter_sdxl_vit-h.safetensors"]="clip-vision_vit-h.safetensors"
)

declare -A IPADAPTER=(
    ["https://huggingface.co/r3gm/noob-ipa/resolve/main/model_G/noobIPAMARK1_mark1.safetensors"]="noobIPAMARK1_mark1.safetensors"
    ["https://huggingface.co/h94/IP-Adapter/resolve/main/sdxl_models/ip-adapter_sdxl_vit-h.safetensors"]="ip-adapter_sdxl_vit-h.safetensors"
)

declare -A INPAINT=(
    ["https://huggingface.co/Acly/MAT/resolve/main/MAT_Places512_G_fp16.safetensors"]="MAT_Places512_G_fp16.safetensors"
    ["https://huggingface.co/lllyasviel/fooocus_inpaint/resolve/main/fooocus_inpaint_head.pth"]="fooocus_inpaint_head.pth"
    ["https://huggingface.co/lllyasviel/fooocus_inpaint/resolve/main/inpaint_v26.fooocus.patch"]="inpaint_v26.fooocus.patch"
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_get_nodes
    provisioning_get_pip_packages



    #CHECKPOINT_MODELS
    dir="${COMFYUI_DIR}/models/checkpoints"
    mkdir -p "$dir"

    printf "Downloading %s model(s) to %s...\n" "${#CHECKPOINT_MODELS[@]}" "$dir"
    for url in "${!CHECKPOINT_MODELS[@]}"; do
        printf "Downloading: %s (%s)\n" "${CHECKPOINT_MODELS[$url]}" "${url}"
        provisioning_download "${url}" "${dir}" "${CHECKPOINT_MODELS[$url]}"
        printf "\n"
    done


    #UNET_MODELS
    dir="${COMFYUI_DIR}/models/unet" 
    mkdir -p "$dir"

    printf "Downloading %s model(s) to %s...\n" "${#UNET_MODELS[@]}" "$dir"
    for url in "${!UNET_MODELS[@]}"; do
        printf "Downloading: %s (%s)\n" "${UNET_MODELS[$url]}" "${url}"
        provisioning_download "${url}" "${dir}" "${UNET_MODELS[$url]}"
        printf "\n"
    done


    #LORA_MODELS
    dir="${COMFYUI_DIR}/models/lora"
    mkdir -p "$dir"

    printf "Downloading %s model(s) to %s...\n" "${#LORA_MODELS[@]}" "$dir"
    for url in "${!LORA_MODELS[@]}"; do
        printf "Downloading: %s (%s)\n" "${LORA_MODELS[$url]}" "${url}"
        provisioning_download "${url}" "${dir}" "${LORA_MODELS[$url]}"
        printf "\n"
    done


    #CONTROLNET_MODELS
    dir="${COMFYUI_DIR}/models/controlnet"
    mkdir -p "$dir"

    printf "Downloading %s model(s) to %s...\n" "${#CONTROLNET_MODELS[@]}" "$dir"
    for url in "${!CONTROLNET_MODELS[@]}"; do
        printf "Downloading: %s (%s)\n" "${CONTROLNET_MODELS[$url]}" "${url}"
        provisioning_download "${url}" "${dir}" "${CONTROLNET_MODELS[$url]}"
        printf "\n"
    done


    #VAE_MODELS
    dir="${COMFYUI_DIR}/models/vae"
    mkdir -p "$dir"

    printf "Downloading %s model(s) to %s...\n" "${#VAE_MODELS[@]}" "$dir"
    for url in "${!VAE_MODELS[@]}"; do
        printf "Downloading: %s (%s)\n" "${VAE_MODELS[$url]}" "${url}"
        provisioning_download "${url}" "${dir}" "${VAE_MODELS[$url]}"
        printf "\n"
    done



    #ESRGAN_MODELS
    dir="${COMFYUI_DIR}/models/esrgan"
    mkdir -p "$dir"

    printf "Downloading %s model(s) to %s...\n" "${#ESRGAN_MODELS[@]}" "$dir"
    for url in "${!ESRGAN_MODELS[@]}"; do
        printf "Downloading: %s (%s)\n" "${ESRGAN_MODELS[$url]}" "${url}"
        provisioning_download "${url}" "${dir}" "${ESRGAN_MODELS[$url]}"
        printf "\n"
    done


    #UPSCALE_MODELS
    dir="${COMFYUI_DIR}/models/upscale_models"
    mkdir -p "$dir"

    printf "Downloading %s model(s) to %s...\n" "${#UPSCALE_MODELS[@]}" "$dir"
    for url in "${!UPSCALE_MODELS[@]}"; do
        printf "Downloading: %s (%s)\n" "${UPSCALE_MODELS[$url]}" "${url}"
        provisioning_download "${url}" "${dir}" "${UPSCALE_MODELS[$url]}"
        printf "\n"
    done



    #CLIP_VISION
    dir="${COMFYUI_DIR}/models/clip_vision"
    mkdir -p "$dir"

    printf "Downloading %s model(s) to %s...\n" "${#CLIP_VISION[@]}" "$dir"
    for url in "${!CLIP_VISION[@]}"; do
        printf "Downloading: %s (%s)\n" "${CLIP_VISION[$url]}" "${url}"
        provisioning_download "${url}" "${dir}" "${CLIP_VISION[$url]}"
        printf "\n"
    done



    # IPADAPTER
    dir="${COMFYUI_DIR}/models/ipadapter"
    mkdir -p "$dir"

    printf "Downloading %s model(s) to %s...\n" "${#IPADAPTER[@]}" "$dir"
    for url in "${!IPADAPTER[@]}"; do
        printf "Downloading: %s (%s)\n" "${IPADAPTER[$url]}" "${url}"
        provisioning_download "${url}" "${dir}" "${IPADAPTER[$url]}"
        printf "\n"
    done


    : '
    provisioning_get_files \
        "${COMFYUI_DIR}/models/checkpoints" \
        CHECKPOINT_MODELS
    provisioning_get_files \
        "${COMFYUI_DIR}/models/unet" \
        UNET_MODELS
    provisioning_get_files \
        "${COMFYUI_DIR}/models/lora" \
        LORA_MODELS
    provisioning_get_files \
        "${COMFYUI_DIR}/models/controlnet" \
        CONTROLNET_MODELS
    provisioning_get_files \
        "${COMFYUI_DIR}/models/vae" \
        VAE_MODELS
    provisioning_get_files \
        "${COMFYUI_DIR}/models/esrgan" \
        ESRGAN_MODELS
    provisioning_get_files \
        "${COMFYUI_DIR}/models/upscale_models" \
        UPSCALE_MODELS
    provisioning_get_files \
        "${COMFYUI_DIR}/models/clip_vision" \
        CLIP_VISION
    provisioning_get_files \
        "${COMFYUI_DIR}/models/ipadapter" \
        IPADAPTER 
    '
    provisioning_print_end
}

function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
            sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
            pip install --no-cache-dir ${PIP_PACKAGES[@]}
    fi
}

function provisioning_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="${COMFYUI_DIR}custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                   pip install --no-cache-dir -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                pip install --no-cache-dir -r "${requirements}"
            fi
        fi
    done
}

function provisioning_get_files() {
    if [[ -z $2 ]]; then return 1; fi
    
    dir="$1"
    mkdir -p "$dir"
    shift

    
    arr=("$@")
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
        printf "\n"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Application will start now\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $CIVITAI_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    elif 
        [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
    fi
    if [[ -n $auth_token ]];then
        wget --header="Authorization: Bearer $auth_token" -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1" -O "$3"
    else
        wget -qnc --content-disposition --show-progress -e dotbytes="${4:-4M}" -P "$2" "$1" -O "$3"
    fi
}

# Allow user to disable provisioning if they started with a script they didn't want
if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi
