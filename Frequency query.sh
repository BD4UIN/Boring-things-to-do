#!/bin/bash

# 定义业余无线电频率范围及其主要和次要用途
declare -A amateur_bands=(
    ["1.8-2.1"]="主要：共用，次要：无"
    ["3.5-3.9"]="主要：共用，次要：无"
    ["7.0-7.1"]="主要：专用，次要：无"
    ["10.1-10.15"]="主要：次要，次要：无"
    ["14-14.25"]="主要：专用，次要：无"
    ["14.25-14.35"]="主要：共用，次要：无"
    ["18.068-18.168"]="主要：共用，次要：无"
    ["21-21.45"]="主要：专用，次要：无"
    ["24.89-24.99"]="主要：共用，次要：无"
    ["28-29.7"]="主要：共用，次要：无"
    ["50-54"]="主要：次要，次要：无"
    ["144-146"]="主要：专用，次要：无"
    ["146-148"]="主要：共用，次要：无"
    ["430-440"]="主要：次要，次要：无"
    ["1.24-1.30"]="主要：次要，次要：无"
    ["2.30-2.45"]="主要：次要，次要：无"
    ["3.30-3.50"]="主要：次要，次要：无"
    ["5.65-6.35"]="主要：次要，次要：无"
    ["10-10.5"]="主要：次要，次要：无"
    ["24-24.25"]="主要：次要，次要：无"
    ["47-47.25"]="主要：共用，次要：无"
    ["75.5-76"]="主要：共用，次要：无"
    ["76-81"]="主要：次要，次要：无"
    ["142-144"]="主要：共用，次要：无"
    ["144-149"]="主要：次要，次要：无"
    ["241-248"]="主要：次要，次要：无"
    ["248-250"]="主要：共用，次要：无"
)

# 定义波段划分
declare -A bands=(
    ["0-300kHz"]="甚低频（VLF）"
    ["300kHz-3MHz"]="低频（LF）"
    ["3MHz-30MHz"]="中频（MF）"
    ["30MHz-300MHz"]="高频（HF）"
    ["300MHz-3GHz"]="甚高频（VHF）"
    ["3GHz-30GHz"]="超高频（UHF）"
    ["30GHz-300GHz"]="特高频（SHF）"
    ["300GHz-3000GHz"]="极高频（EHF）"
)

# 提示用户输入频率
echo "请输入无线电频率（单位：MHz）："
read freq

# 将输入频率转换为浮点数
freq=$(printf "%.2f" "$freq")

# 检查频率是否属于业余无线电频段
is_amateur=false
for band in "${!amateur_bands[@]}"; do
    IFS='-' read -r start end <<< "$band"
    if (( $(echo "$freq >= $start" | bc) )) && (( $(echo "$freq <= $end" | bc) )); then
        is_amateur=true
        echo "该频率属于业余无线电频段。"
        echo "波段：$(get_band "$freq")"
        IFS='，' read -r primary secondary <<< "${amateur_bands[$band]}"
        echo "主要用途：$primary"
        echo "次要用途：$secondary"
        break
    fi
done

if [ "$is_amateur" = false ]; then
    echo "该频率不属于业余无线电频段。"
fi

# 获取波段
get_band() {
    local freq=$1
    for band in "${!bands[@]}"; do
        IFS='-' read -r start end <<< "$band"
        if (( $(echo "$freq >= $start" | bc) )) && (( $(echo "$freq <= $end" | bc) )); then
            echo "${bands[$band]}"
            return
        fi
    done
    echo "未知波段"
}
