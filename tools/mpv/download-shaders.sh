#!/bin/bash

# Download High-Quality mpv Shaders for Ultimate Video Quality

SHADER_DIR="$HOME/.config/mpv/shaders"
mkdir -p "$SHADER_DIR"

echo "📥 Downloading high-quality mpv shaders to: $SHADER_DIR"

# RAVU (Neural network upscaler - excellent for live action)
echo "🧠 Downloading RAVU neural network upscaler..."
wget -q "https://raw.githubusercontent.com/bjin/mpv-prescalers/master/ravu-zoom-ar-r3.hook" -O "$SHADER_DIR/ravu-zoom-ar-r3.hook"

# Anime4K (Best for anime content)
echo "🎌 Downloading Anime4K shaders..."
ANIME4K_BASE="https://raw.githubusercontent.com/bloc97/Anime4K/master/glsl"
wget -q "$ANIME4K_BASE/Anime4K_Clamp_Highlights.glsl" -O "$SHADER_DIR/Anime4K_Clamp_Highlights.glsl"
wget -q "$ANIME4K_BASE/Anime4K_Restore_CNN_VL.glsl" -O "$SHADER_DIR/Anime4K_Restore_CNN_VL.glsl"
wget -q "$ANIME4K_BASE/Anime4K_Upscale_CNN_x2_VL.glsl" -O "$SHADER_DIR/Anime4K_Upscale_CNN_x2_VL.glsl"
wget -q "$ANIME4K_BASE/Anime4K_AutoDownscalePre_x2.glsl" -O "$SHADER_DIR/Anime4K_AutoDownscalePre_x2.glsl"
wget -q "$ANIME4K_BASE/Anime4K_AutoDownscalePre_x4.glsl" -O "$SHADER_DIR/Anime4K_AutoDownscalePre_x4.glsl"
wget -q "$ANIME4K_BASE/Anime4K_Upscale_CNN_x2_M.glsl" -O "$SHADER_DIR/Anime4K_Upscale_CNN_x2_M.glsl"

# FSR (FidelityFX Super Resolution - AMD's upscaler, works great on any GPU)
echo "🚀 Downloading FSR shader..."
wget -q "https://gist.githubusercontent.com/agyild/82219c545228d70c861413637e275990/raw/FSR.glsl" -O "$SHADER_DIR/FSR.glsl"

# CAS (Contrast Adaptive Sharpening)
echo "🔪 Downloading CAS sharpening shader..."
wget -q "https://gist.githubusercontent.com/agyild/bbb4e58298b2f86aa24da3032a0d2ee6/raw/CAS-scaled.glsl" -O "$SHADER_DIR/CAS-scaled.glsl"

# FSRCNNX (Neural network upscaler - requires model files)
echo "🧠 Downloading FSRCNNX neural network upscaler..."
wget -q "https://raw.githubusercontent.com/igv/FSRCNN-TensorFlow/master/models/FSRCNNX_x2_56-16-4-1.glsl" -O "$SHADER_DIR/FSRCNNX_x2_56-16-4-1.glsl"

# SSimDownscaler (High-quality downscaling)
echo "📉 Downloading SSimDownscaler..."
wget -q "https://gist.githubusercontent.com/igv/36508af3ffc84410fe39761d6969be10/raw/SSimDownscaler.glsl" -O "$SHADER_DIR/SSimDownscaler.glsl"

echo ""
echo "✅ All shaders downloaded!"
echo ""
echo "📁 Shaders location: $SHADER_DIR"
echo "📄 Files downloaded:"
ls -la "$SHADER_DIR"
echo ""
echo "🎯 To use these shaders, edit upscale-ultimate.conf and uncomment the shader lines you want to use."
echo ""
echo "🎮 For live-action content: Use RAVU or FSR"
echo "🎌 For anime content: Use Anime4K shaders"
echo "🔪 For extra sharpening: Add CAS shader"