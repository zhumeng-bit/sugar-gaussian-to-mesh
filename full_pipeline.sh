#!/bin/bash
# ============================================================
# SuGaR Pipeline - Gaussian to Mesh 完整转换脚本
# ============================================================
# 用法: bash full_pipeline.sh <scene_path> [iterations] [refine_iterations]
# 示例: bash full_pipeline.sh ./data/tandt/truck 7000 3000
#
# 输入:
#   $1 = COLMAP 格式的场景数据路径
#   $2 = 3DGS 训练迭代次数 (默认: 7000)
#   $3 = Refined 训练迭代次数 (默认: 3000)
#
# 输出:
#   output/vanilla_gs/<scene>/     - 3DGS Gaussian 点云
#   output/coarse/<scene>/        - SuGaR coarse checkpoint
#   output/coarse_mesh/<scene>/   - Coarse mesh (PLY)
#   output/refined/<scene>/       - Refined checkpoint
#   output/refined_mesh/<scene>/  - 最终 mesh + 纹理 (OBJ + PNG)
# ============================================================

set -e

# ---- 配置 ----
SCENE_PATH=${1:?用法: bash full_pipeline.sh <scene_path> [iterations] [refine_iterations]}
ITERATIONS=${2:-7000}
REFINE_ITERATIONS=${3:-3000}
SCENE_NAME=$(basename "$SCENE_PATH")
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$PROJECT_DIR/output"
GS_DIR="$PROJECT_DIR/gaussian_splatting"

echo "============================================================"
echo "SuGaR Pipeline - Gaussian to Mesh"
echo "============================================================"
echo "场景: $SCENE_NAME"
echo "数据路径: $SCENE_PATH"
echo "3DGS 迭代: $ITERATIONS"
echo "Refined 迭代: $REFINE_ITERATIONS"
echo "输出目录: $OUTPUT_DIR"
echo "============================================================"

# ---- 激活环境 ----
source ~/miniconda3/etc/profile.d/conda.sh
conda activate sugar

# ---- 步骤 1: 3DGS 基础训练 ----
echo ""
echo ">>> [步骤 1/5] 3DGS 基础训练 ($ITERATIONS iterations)..."
cd "$GS_DIR"
python train.py \
    -s "$SCENE_PATH" \
    -m "$OUTPUT_DIR/vanilla_gs/$SCENE_NAME" \
    --iterations $ITERATIONS \
    --test_iterations $ITERATIONS \
    --save_iterations $ITERATIONS \
    --data_device cpu

echo ">>> [步骤 1/5] 完成"
echo "    输出: $OUTPUT_DIR/vanilla_gs/$SCENE_NAME/point_cloud/iteration_${ITERATIONS}/point_cloud.ply"

# ---- 步骤 2: SuGaR Coarse 训练 ----
echo ""
echo ">>> [步骤 2/5] SuGaR Coarse 训练..."
cd "$PROJECT_DIR"
python train.py \
    -s "$SCENE_PATH" \
    -c "$OUTPUT_DIR/vanilla_gs/$SCENE_NAME" \
    -i $ITERATIONS \
    -r dn_consistency \
    --low_poly True \
    --refinement_time short

echo ">>> [步骤 2/5] 完成"
COARSE_DIR=$(ls -d "$OUTPUT_DIR/coarse/$SCENE_NAME/sugarcoarse_"* 2>/dev/null | head -1)
echo "    输出: ${COARSE_DIR}/15000.pt"

# ---- 步骤 3: Coarse Mesh 提取 ----
echo ""
echo ">>> [步骤 3/5] Coarse Mesh 提取..."
python extract_mesh.py \
    -s "$SCENE_PATH" \
    -c "$OUTPUT_DIR/vanilla_gs/$SCENE_NAME" \
    -i $ITERATIONS \
    -m "${COARSE_DIR}/15000.pt"

echo ">>> [步骤 3/5] 完成"
echo "    输出: $OUTPUT_DIR/coarse_mesh/$SCENE_NAME/"

# ---- 步骤 4: Refined 训练 ----
echo ""
echo ">>> [步骤 4/5] Refined 训练 ($REFINE_ITERATIONS iterations)..."
COARSE_MESH=$(ls "$OUTPUT_DIR/coarse_mesh/$SCENE_NAME/"*level03*decim1000000.ply 2>/dev/null | head -1)
if [ -z "$COARSE_MESH" ]; then
    echo "    警告: 未找到 level03 decim1000000 mesh, 使用第一个 PLY 文件"
    COARSE_MESH=$(ls "$OUTPUT_DIR/coarse_mesh/$SCENE_NAME/"*.ply 2>/dev/null | head -1)
fi
python train_refined.py \
    -s "$SCENE_PATH" \
    -c "$OUTPUT_DIR/vanilla_gs/$SCENE_NAME" \
    -m "$COARSE_MESH" \
    -i $ITERATIONS \
    -f $REFINE_ITERATIONS \
    -o "$OUTPUT_DIR/refined/$SCENE_NAME"

echo ">>> [步骤 4/5] 完成"
REFINED_DIR=$(ls -d "$OUTPUT_DIR/refined/$SCENE_NAME/sugarfine_"* 2>/dev/null | head -1)
echo "    输出: ${REFINED_DIR}/"

# ---- 步骤 5: Refined Mesh + 纹理提取 ----
echo ""
echo ">>> [步骤 5/5] Refined Mesh + 纹理提取..."
python extract_refined_mesh_with_texture.py -s "$SCENE_PATH" -c "$OUTPUT_DIR/vanilla_gs/$SCENE_NAME" -m "$REFINED_DIR" -i $ITERATIONS -o "$OUTPUT_DIR/refined_mesh/$SCENE_NAME"

echo ">>> [步骤 5/5] 完成"
echo "    输出: $OUTPUT_DIR/refined_mesh/$SCENE_NAME/"

# ---- 完成 ----
echo ""
echo "============================================================"
echo "全部完成！"
echo "============================================================"
echo ""
echo "输出文件:"
echo "  [渲染用]   $OUTPUT_DIR/vanilla_gs/$SCENE_NAME/point_cloud/iteration_${ITERATIONS}/point_cloud.ply"
echo "  [Refined Gaussian] ${COARSE_DIR}/15000.pt"
echo "  [Mesh]     $OUTPUT_DIR/coarse_mesh/$SCENE_NAME/"
echo "  [Refined Gaussian] ${REFINED_DIR}/"
echo "  [Mesh+纹理] $OUTPUT_DIR/refined_mesh/$SCENE_NAME/$SCENE_NAME.obj"
echo ""
echo "后续操作:"
echo "  1. 在 Blender 中导入 refined mesh: File > Import > Wavefront (.obj)"
echo "  2. 切换到 Material Preview 模式查看纹理"
echo "  3. 使用清理工具修复碎片和法线"
echo "============================================================"