# SuGaR 高斯泼溅转网格项目 - 标准化输出目录清单

> 本文档记录 SuGaR（Surface-Aligned Gaussian Splatting）项目中"高斯泼溅转网格"流程所产出的标准化结果目录结构、文件分类、文件大小、命名规范、跨平台路径定位方式，以及 Blender 资产检查结果摘要。
>
> 文档版本：1.0
> 最后更新：2026-06-24
> 适用场景：truck（卡车）与 train（火车）两个数据集

---

## 目录

1. [标准目录结构（树状图）](#1-标准目录结构树状图)
2. [文件分类](#2-文件分类)
3. [文件大小与描述](#3-文件大小与描述)
4. [命名规范](#4-命名规范)
5. [文件定位方式（Windows 路径 vs WSL 路径）](#5-文件定位方式windows-路径-vs-wsl-路径)
6. [Blender 资产检查结果摘要](#6-blender-资产检查结果摘要)

---

## 1. 标准目录结构（树状图）

### 1.1 Windows 可直接访问的输出目录

以下目录位于 Windows 文件系统，可直接通过资源管理器或 Blender 打开：

```
d:\3D_Project\
├── mesh_output_7000\                          # truck 粗网格输出（SuGaR coarse mesh）
│   ├── sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level01_decim1000000.ply
│   ├── sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level01_decim200000.ply
│   ├── sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level03_decim1000000.ply
│   ├── sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level03_decim200000.ply
│   ├── sugarmesh_3Dgs7000_densityestim02_level05_decim1000000.ply
│   └── sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level05_decim200000.ply
│
├── refined_mesh_output\                       # truck 精修网格输出（SuGaR refined mesh）
│   ├── truck.obj                              # 最终网格模型（含 UV）
│   ├── truck.mtl                              # 材质定义文件
│   └── truck.png                              # 纹理贴图
│
├── train_mesh_output\                         # train 场景输出（粗网格 + 精修网格）
│   ├── sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level01_decim1000000.ply
│   ├── sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level01_decim200000.ply
│   ├── sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level03_decim1000000.ply
│   ├── sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level03_decim200000.ply
│   ├── sugarmesh_3Dgs7000_densityestim02_level05_decim1000000.ply
│   ├── sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level05_decim200000.ply
│   ├── train.obj                              # 最终网格模型（含 UV）
│   ├── train.mtl                              # 材质定义文件
│   └── train.png                              # 纹理贴图
│
└── standardized_output\                       # 标准化输出说明目录
    └── README.md                              # 本文件
```

### 1.2 WSL2 内部输出目录（不可从 Windows 直接访问）

以下目录位于 WSL2（Windows Subsystem for Linux 2）虚拟磁盘内，需通过 WSL 终端访问。这些目录保存了完整的 SuGaR 训练管线中间产物与最终产物：

```
/home/happy/projects/sugar/output/
│
├── vanilla_gs/                                # 3D Gaussian Splatting 原始训练结果
│   ├── truck/
│   │   ├── point_cloud.ply                     # 3DGS 点云模型（~442 MB）
│   │   ├── cameras.json                        # 相机参数
│   │   ├── cfg_args                            # 训练配置参数
│   │   └── input.ply                           # 输入点云
│   └── train/
│       ├── point_cloud.ply                     # 3DGS 点云模型（~442 MB）
│       ├── cameras.json
│       ├── cfg_args
│       └── input.ply
│
├── coarse/                                     # SuGaR 粗对齐阶段检查点
│   ├── truck/
│   │   └── 15000.pt                            # 粗对齐检查点（~289 MB）
│   └── train/
│       └── 15000.pt                            # 粗对齐检查点（~289 MB）
│
├── coarse_mesh/                               # SuGaR 粗网格提取结果（PLY）
│   ├── truck/                                  # 对应 Windows: mesh_output_7000\
│   │   └── sugarmesh_*.ply
│   └── train/                                  # 对应 Windows: train_mesh_output\ 中的 PLY
│       └── sugarmesh_*.ply
│
├── refined/                                    # SuGaR 精修阶段检查点
│   ├── truck/
│   │   └── 3000.pt                             # 精修检查点（~914 MB）
│   └── train/
│       └── 3000.pt                             # 精修检查点（~914 MB）
│
└── refined_mesh/                               # SuGaR 精修网格提取结果（OBJ+MTL+PNG）
    ├── truck/                                  # 对应 Windows: refined_mesh_output\
    │   ├── truck.obj
    │   ├── truck.mtl
    │   └── truck.png
    └── train/                                  # 对应 Windows: train_mesh_output\ 中的 OBJ/MTL/PNG
        ├── train.obj
        ├── train.mtl
        └── train.png
```

---

## 2. 文件分类

SuGaR 管线产出的文件按用途可分为以下四大类别：

### 2.1 网格输出（Mesh Outputs）

SuGaR 管线最终生成的网格资产，用于可视化、渲染与下游应用。

| 子类 | 文件类型 | 说明 |
|------|----------|------|
| 粗网格（Coarse Mesh） | `.ply` | 由 SuGaR 粗对齐高斯提取的网格，按不同等值面级别与简化目标分类 |
| 精修网格（Refined Mesh） | `.obj` + `.mtl` + `.png` | 由精修高斯提取的最终带纹理网格，可直接导入 Blender / 3D 软件 |

### 2.2 精修高斯（Refined Gaussian）

SuGaR 精修阶段保存的高斯模型检查点，可用于重新提取网格或继续训练。

| 子类 | 文件类型 | 说明 |
|------|----------|------|
| 精修检查点 | `.pt` | PyTorch 模型权重，包含精修后的 3D 高斯参数 |
| 粗对齐检查点 | `.pt` | 粗对齐阶段的高斯参数，用于后续精修初始化 |

### 2.3 渲染输出（Render Outputs）

3DGS 原始训练阶段产出的高斯点云与渲染相关资产。

| 子类 | 文件类型 | 说明 |
|------|----------|------|
| 3DGS 点云 | `point_cloud.ply` | 原始 3D 高斯泼溅模型，可用于实时渲染 |
| 相机参数 | `cameras.json` | 训练相机内外参 |
| 训练配置 | `cfg_args` | 训练超参数与数据集路径 |
| 输入点云 | `input.ply` | 由 SfM（COLMAP）生成的初始稀疏点云 |

### 2.4 日志（Logs）

训练与提取过程中的日志文件（若启用）。通常位于各输出目录的父级或 `output/` 根目录下。

| 子类 | 文件类型 | 说明 |
|------|----------|------|
| 训练日志 | `.log` / `.txt` | 损失曲线、PSNR/SSIM/LPIPS 指标记录 |
| 控制台输出 | `*.out` | 终端重定向输出 |

---

## 3. 文件大小与描述

### 3.1 truck 粗网格输出（`d:\3D_Project\mesh_output_7000\`）

| 文件名 | 大小 | 说明 |
|--------|------|------|
| `sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level01_decim1000000.ply` | 54.46 MB | 等值面级别 1，简化目标 1,000,000 面 |
| `sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level01_decim200000.ply` | 14.56 MB | 等值面级别 1，简化目标 200,000 面 |
| `sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level03_decim1000000.ply` | 54.36 MB | 等值面级别 3，简化目标 1,000,000 面 |
| `sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level03_decim200000.ply` | 14.58 MB | 等值面级别 3，简化目标 200,000 面 |
| `sugarmesh_3Dgs7000_densityestim02_level05_decim1000000.ply` | 52.43 MB | 等值面级别 5，简化目标 1,000,000 面 |
| `sugarmesh_3Dgs7000_densityestim02_level05_decim200000.ply` | 14.33 MB | 等值面级别 5，简化目标 200,000 面 |

### 3.2 truck 精修网格输出（`d:\3D_Project\refined_mesh_output\`）

| 文件名 | 大小 | 说明 |
|--------|------|------|
| `truck.obj` | 171.25 MB | 最终精修网格模型，含顶点、面、UV 坐标 |
| `truck.mtl` | < 1 KB | Wavefront 材质定义，引用 `truck.png` 作为漫反射贴图 |
| `truck.png` | 75.73 MB | 纹理贴图（高分辨率），由精修高斯渲染烘焙 |

### 3.3 train 场景输出（`d:\3D_Project\train_mesh_output\`）

#### 粗网格（PLY）

| 文件名 | 大小 | 说明 |
|--------|------|------|
| `sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level01_decim1000000.ply` | 49.86 MB | 等值面级别 1，简化目标 1,000,000 面 |
| `sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level01_decim200000.ply` | 13.54 MB | 等值面级别 1，简化目标 200,000 面 |
| `sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level03_decim1000000.ply` | 49.31 MB | 等值面级别 3，简化目标 1,000,000 面 |
| `sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level03_decim200000.ply` | 13.55 MB | 等值面级别 3，简化目标 200,000 面 |
| `sugarmesh_3Dgs7000_densityestim02_level05_decim1000000.ply` | 47.48 MB | 等值面级别 5，简化目标 1,000,000 面 |
| `sugarmesh_3Dgs7000_densityestim02_level05_decim200000.ply` | 13.27 MB | 等值面级别 5，简化目标 200,000 面 |

#### 精修网格（OBJ + MTL + PNG）

| 文件名 | 大小 | 说明 |
|--------|------|------|
| `train.obj` | 155.42 MB | 最终精修网格模型，含顶点、面、UV 坐标 |
| `train.mtl` | < 1 KB | Wavefront 材质定义，引用 `train.png` 作为漫反射贴图 |
| `train.png` | 77.64 MB | 纹理贴图（高分辨率），由精修高斯渲染烘焙 |

### 3.4 WSL2 内部文件大小汇总

| 路径 | 文件 | 大小（约） | 说明 |
|------|------|-----------|------|
| `.../vanilla_gs/{scene}/` | `point_cloud.ply` | 442 MB | 3DGS 原始点云 |
| `.../vanilla_gs/{scene}/` | `cameras.json` | < 1 MB | 相机参数 |
| `.../vanilla_gs/{scene}/` | `cfg_args` | < 1 KB | 训练配置 |
| `.../vanilla_gs/{scene}/` | `input.ply` | < 10 MB | SfM 输入点云 |
| `.../coarse/{scene}/` | `15000.pt` | 289 MB | 粗对齐检查点 |
| `.../refined/{scene}/` | `3000.pt` | 914 MB | 精修检查点 |

> 说明：`{scene}` 代表 `truck` 或 `train`。

---

## 4. 命名规范

### 4.1 粗网格文件命名

粗网格 PLY 文件采用结构化命名，各字段以 `_` 分隔：

```
sugarmesh_3Dgs{N}_densityestim{D}_sdfnorm{S}_level{L}_decim{M}.ply
```

| 字段 | 含义 | 示例值 |
|------|------|--------|
| `sugarmesh` | 固定前缀，标识 SuGaR 提取的网格 | `sugarmesh` |
| `3Dgs{N}` | 3DGS 训练迭代数 | `3Dgs7000`（7000 次迭代） |
| `densityestim{D}` | 密度估计阈值参数 | `densityestim02` |
| `sdfnorm{S}` | SDF 归一化阈值参数 | `sdfnorm02` |
| `level{L}` | 等值面提取级别（Level-of-Detail） | `level01` / `level03` / `level05` |
| `decim{M}` | 网格简化目标面数 | `decim1000000`（100 万面）/ `decim200000`（20 万面） |

**级别说明：**
- `level01`：低细节层级，网格较粗糙，面数较少
- `level03`：中细节层级，平衡精度与性能
- `level05`：高细节层级，网格最精细，面数最多

**简化目标说明：**
- `decim1000000`：保留至多 100 万三角面，细节丰富
- `decim200000`：保留至多 20 万三角面，适合轻量渲染

### 4.2 精修网格文件命名

精修网格采用场景名作为统一前缀，三件套保持一致：

```
{scene}.obj    # 网格几何
{scene}.mtl    # 材质定义
{scene}.png    # 纹理贴图
```

| 字段 | 含义 | 示例值 |
|------|------|--------|
| `{scene}` | 场景名称 | `truck` / `train` |

### 4.3 检查点文件命名

```
{iterations}.pt
```

| 文件 | 含义 |
|------|------|
| `15000.pt` | 粗对齐阶段，迭代 15000 次保存的检查点 |
| `3000.pt` | 精修阶段，迭代 3000 次保存的检查点 |

### 4.4 目录命名规范

| 目录 | 命名规则 | 说明 |
|------|----------|------|
| `vanilla_gs/{scene}/` | `vanilla_gs` + 场景名 | 原始 3DGS 训练输出 |
| `coarse/{scene}/` | `coarse` + 场景名 | SuGaR 粗对齐输出 |
| `coarse_mesh/{scene}/` | `coarse_mesh` + 场景名 | 粗网格提取输出 |
| `refined/{scene}/` | `refined` + 场景名 | SuGaR 精修输出 |
| `refined_mesh/{scene}/` | `refined_mesh` + 场景名 | 精修网格提取输出 |

---

## 5. 文件定位方式（Windows 路径 vs WSL 路径）

由于 SuGaR 训练在 WSL2 环境中执行，而最终网格资产已拷贝至 Windows 文件系统，因此存在两套路径。下表列出同一资产在两个环境中的对应关系。

### 5.1 路径对应速查表

| 资产类型 | Windows 路径（可直接访问） | WSL2 路径（需 WSL 终端） |
|----------|---------------------------|------------------------|
| truck 粗网格 | `d:\3D_Project\mesh_output_7000\` | `/home/happy/projects/sugar/output/coarse_mesh/truck/` |
| truck 精修网格 | `d:\3D_Project\refined_mesh_output\` | `/home/happy/projects/sugar/output/refined_mesh/truck/` |
| train 粗网格 | `d:\3D_Project\train_mesh_output\`（PLY 部分） | `/home/happy/projects/sugar/output/coarse_mesh/train/` |
| train 精修网格 | `d:\3D_Project\train_mesh_output\`（OBJ/MTL/PNG 部分） | `/home/happy/projects/sugar/output/refined_mesh/train/` |
| 3DGS 点云 | 不可直接访问 | `/home/happy/projects/sugar/output/vanilla_gs/{scene}/` |
| 粗对齐检查点 | 不可直接访问 | `/home/happy/projects/sugar/output/coarse/{scene}/` |
| 精修检查点 | 不可直接访问 | `/home/happy/projects/sugar/output/refined/{scene}/` |

### 5.2 从 WSL 访问 Windows 文件

在 WSL 终端中，Windows 的 `d:` 盘映射为 `/mnt/d/`：

```bash
# 查看 truck 粗网格
ls -lh /mnt/d/3D_Project/mesh_output_7000/

# 查看 truck 精修网格
ls -lh /mnt/d/3D_Project/refined_mesh_output/

# 查看 train 场景输出
ls -lh /mnt/d/3D_Project/train_mesh_output/
```

### 5.3 从 Windows 访问 WSL 文件

WSL2 的文件系统默认不在 Windows 资源管理器中显示。可通过以下方式访问：

**方式一：资源管理器地址栏**

在资源管理器地址栏输入：
```
\\wsl$\Ubuntu\home\happy\projects\sugar\output\
```

**方式二：WSL 终端拷贝至 Windows**

```bash
# 将 3DGS 点云拷贝至 Windows
cp /home/happy/projects/sugar/output/vanilla_gs/truck/point_cloud.ply /mnt/d/3D_Project/

# 将检查点拷贝至 Windows
cp /home/happy/projects/sugar/output/refined/truck/3000.pt /mnt/d/3D_Project/
```

> 注意：跨文件系统拷贝大文件（如 914 MB 检查点）可能耗时较长，建议在非高峰时段操作。

### 5.4 在 Blender 中打开网格

| 操作 | 路径 |
|------|------|
| 导入 truck 精修网格 | `d:\3D_Project\refined_mesh_output\truck.obj` |
| 导入 train 精修网格 | `d:\3D_Project\train_mesh_output\train.obj` |
| 导入 truck 粗网格 | `d:\3D_Project\mesh_output_7000\sugarmesh_*.ply` |
| 导入 train 粗网格 | `d:\3D_Project\train_mesh_output\sugarmesh_*.ply` |

> 提示：导入 OBJ 时，Blender 会自动查找同目录下的 `.mtl` 与 `.png` 文件。请确保三者位于同一目录。

---

## 6. Blender 资产检查结果摘要

对 truck 与 train 两个场景的精修网格（OBJ）进行了 Blender 资产检查，结果如下。

### 6.1 truck 场景检查结果

| 检查项 | 结果 | 说明 |
|--------|------|------|
| 模型缩放（Scale） | 正常 | 网格尺度合理，无需额外缩放调整 |
| 法线方向（Normals） | 需重新计算 | 部分面法线朝向不一致，建议在 Blender 中执行 `Mesh > Normals > Recalculate Outside` |
| 浮空碎片（Floating Debris） | 存在 | 场景中存在少量脱离主体的浮空三角面碎片，建议手动清理或使用 `Edit Mode > Select > All by Trait > Non-Manifold` 筛选 |
| 纹理显示（Texture） | 正常 | 在 Material Preview（材质预览）模式下纹理正确显示，颜色与细节还原良好 |

### 6.2 train 场景检查结果

| 检查项 | 结果 | 说明 |
|--------|------|------|
| 模型缩放（Scale） | 正常 | 网格尺度合理，无需额外缩放调整 |
| 法线方向（Normals） | 需重新计算 | 与 truck 类似，部分面法线朝向不一致，需重新计算 |
| 浮空碎片（Floating Debris） | 存在（较多） | 由于 train 场景复杂度更高，浮空碎片数量明显多于 truck，建议优先清理 |
| 纹理显示（Texture） | 正常 | 在 Material Preview 模式下纹理正确显示 |

### 6.3 检查结论与建议

1. **法线问题**：两个场景均存在法线朝向不一致问题。这是 SuGaR 网格提取（Marching Tetrahedra / Dual Contouring）的常见现象。建议在 Blender 中统一执行法线重计算：
   - 进入 Edit Mode（`Tab`）
   - 全选（`A`）
   - `Mesh > Normals > Recalculate Outside`（`Shift+N`）

2. **浮空碎片问题**：train 场景因几何复杂度更高，碎片更多。建议清理流程：
   - 使用 `Select > All by Trait > Non-Manifold` 选中非流形边
   - 使用 `Select > All by Trait > Loose Geometry` 选中松散几何体
   - 删除（`X` > Vertices / Faces）

3. **纹理显示**：两个场景纹理在 Material Preview 模式下均正常。若在 Rendered 模式下纹理不显示，请检查：
   - 材质节点是否正确引用 `truck.png` / `train.png`
   - 渲染引擎是否设置为 Cycles 或 Eevee
   - 是否启用了 `Textured Solid` 显示选项

4. **粗网格选择建议**：
   - 需要高精度可视化：选用 `level05_decim1000000.ply`
   - 需要轻量预览：选用 `level01_decim200000.ply`
   - 平衡精度与性能：选用 `level03_decim1000000.ply`

---

## 附录：完整文件清单

### A. Windows 可访问文件

| 序号 | 文件路径 | 大小 |
|------|----------|------|
| 1 | `d:\3D_Project\mesh_output_7000\sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level01_decim1000000.ply` | 54.46 MB |
| 2 | `d:\3D_Project\mesh_output_7000\sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level01_decim200000.ply` | 14.56 MB |
| 3 | `d:\3D_Project\mesh_output_7000\sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level03_decim1000000.ply` | 54.36 MB |
| 4 | `d:\3D_Project\mesh_output_7000\sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level03_decim200000.ply` | 14.58 MB |
| 5 | `d:\3D_Project\mesh_output_7000\sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level05_decim1000000.ply` | 52.43 MB |
| 6 | `d:\3D_Project\mesh_output_7000\sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level05_decim200000.ply` | 14.33 MB |
| 7 | `d:\3D_Project\refined_mesh_output\truck.obj` | 171.25 MB |
| 8 | `d:\3D_Project\refined_mesh_output\truck.mtl` | < 1 KB |
| 9 | `d:\3D_Project\refined_mesh_output\truck.png` | 75.73 MB |
| 10 | `d:\3D_Project\train_mesh_output\sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level01_decim1000000.ply` | 49.86 MB |
| 11 | `d:\3D_Project\train_mesh_output\sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level01_decim200000.ply` | 13.54 MB |
| 12 | `d:\3D_Project\train_mesh_output\sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level03_decim1000000.ply` | 49.31 MB |
| 13 | `d:\3D_Project\train_mesh_output\sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level03_decim200000.ply` | 13.55 MB |
| 14 | `d:\3D_Project\train_mesh_output\sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level05_decim1000000.ply` | 47.48 MB |
| 15 | `d:\3D_Project\train_mesh_output\sugarmesh_3Dgs7000_densityestim02_sdfnorm02_level05_decim200000.ply` | 13.27 MB |
| 16 | `d:\3D_Project\train_mesh_output\train.obj` | 155.42 MB |
| 17 | `d:\3D_Project\train_mesh_output\train.mtl` | < 1 KB |
| 18 | `d:\3D_Project\train_mesh_output\train.png` | 77.64 MB |

**Windows 文件总计大小：约 762 MB**

### B. WSL2 内部文件（参考大小）

| 序号 | 文件路径 | 大小（约） |
|------|----------|-----------|
| 1 | `/home/happy/projects/sugar/output/vanilla_gs/truck/point_cloud.ply` | 442 MB |
| 2 | `/home/happy/projects/sugar/output/vanilla_gs/train/point_cloud.ply` | 442 MB |
| 3 | `/home/happy/projects/sugar/output/coarse/truck/15000.pt` | 289 MB |
| 4 | `/home/happy/projects/sugar/output/coarse/train/15000.pt` | 289 MB |
| 5 | `/home/happy/projects/sugar/output/refined/truck/3000.pt` | 914 MB |
| 6 | `/home/happy/projects/sugar/output/refined/train/3000.pt` | 914 MB |

---

*本文档由 SuGaR 项目标准化输出流程自动生成，用于记录与追踪网格资产。如有疑问，请参阅 SuGaR 官方文档。*
