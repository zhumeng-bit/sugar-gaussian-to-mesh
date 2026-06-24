# SuGaR Pipeline - Gaussian to Mesh

将 3D Gaussian Splatting 的结果转换为更容易进入传统三维资产管线的 mesh / textured mesh / refined Gaussian 输出。

<a href="https://zhumeng-bit.github.io/sugar-gaussian-to-mesh/sugar-pipeline-docs/sugar-pipeline-docs.html" target="_blank">
  <img src="https://img.shields.io/badge/在线完整文档-GitHub%20Pages-2ea44f?style=for-the-badge&logo=github" alt="Docs Site">
</a>

> PyTorch 2.6 + CUDA12.4 WSL2 高斯泼溅转网格完整流水线文档

## 快速开始

```bash
# 一键运行完整流程
bash full_pipeline.sh /path/to/scene_data
```

**[查看完整接口文档](https://zhumeng-bit.github.io/sugar-gaussian-to-mesh/sugar-pipeline-docs/sugar-pipeline-docs.html)**

## 流程概览

```
输入图像 (COLMAP) → 3DGS 训练 → SuGaR Coarse → Coarse Mesh → Refined → UV-Textured Mesh
```

## 输出分类

| 类型 | 格式 | 用途 |
|------|------|------|
| Mesh | .ply / .obj | Blender、游戏引擎、3D 打印 |
| Refined Gaussian | .pt | 分析、渲染 |
| 渲染用 | .ply | SIBR Viewer、poly.cam |
| 纹理 | .png | 与 .obj 配合使用 |

## 环境要求

- PyTorch 2.6 + CUDA 12.4
- NVIDIA GPU (CUDA 7.x+, 8GB+ VRAM)
- Python 3.11
- Ubuntu 22.04 (WSL2)

## 文件说明

- `sugar-pipeline-docs/` - 完整接口文档（HTML）
- `full_pipeline.sh` - 一键运行脚本
- `mesh_output_7000/` - truck 场景 coarse mesh
- `refined_mesh_output/` - truck 场景 refined mesh + 纹理

## 已验证场景

- [x] Tanks & Temples - truck
- [ ] Tanks & Temples - train (进行中)

## 参考

- [SuGaR Paper](https://antwo.github.io/sugar/)
- [SuGaR GitHub](https://github.com/Anttwo/SuGaR)
- [3D Gaussian Splatting](https://github.com/graphdeco-inria/gaussian-splatting)
