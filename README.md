# SuGaR Pipeline - Gaussian to Mesh

将 3D Gaussian Splatting 的结果转换为更容易进入传统三维资产管线的 mesh / textured mesh / refined Gaussian 输出。

<a href="https://zhumeng-bit.github.io/sugar-gaussian-to-mesh/sugar-pipeline-docs/sugar-pipeline-docs.html" target="_blank">
  <img src="https://img.shields.io/badge/在线完整文档-GitHub%20Pages-2ea44f?style=for-the-badge&logo=github" alt="Docs Site">
</a>

> PyTorch 2.6 + CUDA 12.4 | RTX 4060 8GB | WSL2 Ubuntu 22.04 | 高斯泼溅转网格完整流水线

## 快速开始

```bash
# 一键运行完整流程（5 步）
bash full_pipeline.sh /path/to/scene_data [iterations=7000] [refine_iterations=3000]
```

**[查看完整接口文档](https://zhumeng-bit.github.io/sugar-gaussian-to-mesh/sugar-pipeline-docs/sugar-pipeline-docs.html)**

## 流程概览

```
输入图像 (COLMAP) → 3DGS 训练 → SuGaR Coarse → Coarse Mesh → Refined → UV-Textured Mesh (.obj + .png)
```

| 步骤 | 脚本 | 输出 | 预计时间 |
|------|------|------|----------|
| 1. 3DGS 训练 | `train.py` | `point_cloud.ply` (~442MB) | 30-60 min |
| 2. SuGaR Coarse | `train.py -r dn_consistency` | `15000.pt` (~289MB) | 20-40 min |
| 3. Coarse Mesh | `extract_mesh.py` | 6x `.ply` (15-55MB each) | 5-10 min |
| 4. Refined | `train_refined.py` | `3000.pt` (~914MB) | 10-20 min |
| 5. Final Mesh | `extract_refined_mesh_with_texture.py` | `.obj + .mtl + .png` | 5-10 min |

## 输出分类

| 类型 | 格式 | 用途 |
|------|------|------|
| Coarse Mesh | `.ply` (6 个/场景) | 快速预览、基础建模、3D 打印 |
| Refined Mesh | `.obj + .mtl + .png` | Blender、游戏引擎、骨骼绑定、动画 |
| Refined Gaussian | `.pt` (checkpoint) | 分析、渲染、后续训练 |
| 3DGS Point Cloud | `.ply` | SIBR Viewer、poly.cam 实时渲染 |

## 环境要求

| 组件 | 版本 | 说明 |
|------|------|------|
| PyTorch | 2.6.0+cu124 | 深度学习框架 |
| CUDA Toolkit | 12.4 | GPU 计算 |
| Python | 3.11 | conda 环境 |
| NVIDIA GPU | 8GB+ VRAM | RTX 4060 已验证 |
| OS | Ubuntu 22.04 (WSL2) | Windows 子系统 |

## Blender 资产检查

导出 mesh 后需在 Blender 中检查以下项目：

- **Scale** - 查看尺寸是否合理
- **Normals** - `Recalculate Outside` 确保法线一致朝外
- **Broken Faces** - `Clean Up > Fill Holes` 修复孔洞
- **Floating Debris** - `Clean Up > Delete Loose` 清除碎片
- **Non-Manifold** - `Select All by Trait > Non Manifold` 检查流形
- **Texture** - 切换 `Material Preview` 模式验证纹理显示

详细检查结果见 [standardized_output/README.md](standardized_output/README.md)。

## 后续管线接入

| 管线 | 格式 | 操作 |
|------|------|------|
| 骨骼绑定 | OBJ (decim200000) | 清理 → Decimate < 50K 面 → Auto-Rig → Automatic Weights |
| 动画驱动 | FBX / GLB | NLA Strip / Action → 导出 FBX |
| Unreal Engine 5 | FBX / OBJ | Import → Create Blueprint |
| Unity | FBX / OBJ | 拖入 Assets 目录 |
| Godot | GLB / OBJ | Import Scene |
| 几何检查自动化 | Python (trimesh) | `is_watertight` / `euler_number` / `bounds` |

## 仓库文件说明

| 文件/目录 | 说明 |
|-----------|------|
| `sugar-pipeline-docs/` | 15 章完整接口文档（HTML） |
| `full_pipeline.sh` | 一键运行 5 步流程脚本 |
| `standardized_output/` | 标准化输出目录清单（文件分类、大小、命名规范） |
| `.github/workflows/` | GitHub Pages 自动部署 |

## 已验证场景

- [x] Tanks & Temples - **truck** (219 张图像, 1.87M Gaussians)
- [x] Tanks & Temples - **train** (263 张图像, 0.67M Gaussians)

## 常见问题速查

| 问题 | 解决方案 |
|------|----------|
| OOM Killed | 添加 `--data_device cpu` |
| torch.load 错误 | 添加 `weights_only=False` |
| libc10.so 找不到 | 添加 PyTorch lib 到 `LD_LIBRARY_PATH` |
| 命令路径截断 | 命令写在单行，不用 `\` 换行 |
| Mesh 碎片多 | Blender 清理 + 增加迭代次数 |

完整问题排查见 [在线文档第 14 章](https://zhumeng-bit.github.io/sugar-gaussian-to-mesh/sugar-pipeline-docs/sugar-pipeline-docs.html#troubleshoot)。

## 参考

- [SuGaR Paper](https://anttwo.github.io/sugar/) - Surface-Aligned Gaussian Splatting
- [SuGaR GitHub](https://github.com/Anttwo/SuGaR) - 官方代码仓库
- [3D Gaussian Splatting](https://github.com/graphdeco-inria/gaussian-splatting) - Inria 3DGS
