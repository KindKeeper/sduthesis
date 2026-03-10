# sduthesis - 山东大学学位论文模板

符合《山东大学研究生学位论文撰写指南》的 LaTeX 模板，极简设计，开箱即用。

## 特点

- **极简配置**：仅需编辑 `thesis.tex` 一个文件
- **标准工具链**：使用 `latexmk`（TeX Live 自带）
- **跨平台**：支持 Windows/macOS/Linux
- **开源字体**：默认使用 Fandol 字体，无需安装 Windows 字体
- **现代 LaTeX3**：代码简洁，易于维护

## 快速开始

### 1. 安装 TeX Live

```bash
# macOS
brew install --cask mactex

# Windows
download from https://tug.org/texlive/

# Ubuntu
sudo apt-get install texlive-full
```

### 2. 编译论文

```bash
# 完整编译（自动处理参考文献）
latexmk

# 实时预览（保存文件自动重编译）
latexmk -pvc

# 清理临时文件
latexmk -c
```

编译完成后生成 `build/thesis.pdf`。

## 目录结构

```
.
├── thesis.tex          # 主文件：配置和结构
├── thesis.bib          # 参考文献（Zotero 自动生成）
├── latexmkrc           # 编译配置
├── sduthesis.cls       # 文档类（一般不需要修改）
├── chapters/           # 论文章节
│   ├── chapter1-introduction.tex
│   ├── chapter2-related-work.tex
│   ├── chapter3-methodology.tex
│   ├── chapter4-experiments.tex
│   ├── chapter5-conclusion.tex
│   └── acknowledgement.tex
├── figures/            # 图片目录
└── README.md
```

## 使用方法

### 1. 配置论文信息

编辑 `thesis.tex` 中的 `\sdusetup`：

```latex
\sdusetup{
  title = {你的论文题目},
  title-en = {English Title},
  author = {你的名字},
  student-id = {学号},
  supervisor = {导师姓名},
  college = {学院名称},
  major = {专业名称},
  date = {2025年6月},
}
```

### 2. 编写章节

在 `chapters/` 目录下创建 `.tex` 文件，然后在 `thesis.tex` 中引入：

```latex
\input{chapters/chapter1-introduction}
\input{chapters/chapter2-related-work}
% ... 其他章节
```

### 3. 插入图片

```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.8\textwidth]{figures/your-image.pdf}
  \caption{图片标题}
  \label{fig:label}
\end{figure}
```

### 4. 引用文献

使用 Zotero + Better BibTeX 插件管理文献，自动生成 `thesis.bib`。

在正文中引用：

```latex
\cite{example2024}          % 普通引用
\parencite{example2024}     % 括号引用
\textcite{example2024}      % 作者-年份引用
```

## 文档类选项

```latex
\documentclass[
  master,               % master|doctor
  colorcover,           % colorcover|bwcover
  % blindreview,        % 取消注释启用盲审
  % biblatex,           % 取消注释启用biblatex
]{sduthesis}
```

### biblatex 支持（可选）

启用 `biblatex` 选项后，可使用 Zotero + Better BibTeX 管理文献：

```latex
\documentclass[biblatex]{sduthesis}
\addbibresource{references.bib}  % 在导言区添加
% ...
\printbibliography  % 打印参考文献
```

编译链：`xelatex -> biber -> xelatex -> xelatex`（`latexmk` 自动处理）

### 字体自动回退

模板自动检测系统可用字体：
- **Windows**：SimSun/SimHei
- **Linux**：Fandol（TeX Live 自带）
- **macOS**：Songti SC/Heiti SC

## 编译流程

```
thesis.tex + thesis.bib
    ↓
latexmk (自动执行以下步骤)
    ↓
xelatex → biber → xelatex → xelatex
    ↓
build/thesis.pdf
```

## 常见问题

### 字体找不到？

- **Fandol（默认）**：TeX Live 自带，无需额外安装
- **Windows**：需安装 SimSun/SimHei 字体
- **macOS**：系统自带中文字体

### 参考文献不显示？

确保运行 `latexmk`（而非单独的 `xelatex`），以正确执行 biber。

### 如何插入表格？

```latex
\begin{table}[htbp]
  \centering
  \caption{表格标题}
  \begin{tabular}{lcc}
    \toprule
    列1 & 列2 & 列3 \\
    \midrule
    数据1 & 数据2 & 数据3 \\
    \bottomrule
  \end{tabular}
\end{table}
```

## 模板参数对照

| 参数 | 说明 | 示例 |
|------|------|------|
| `title` | 中文标题 | 基于深度学习的图像分类 |
| `title-en` | 英文标题 | Deep Learning ... |
| `author` | 作者姓名 | 张三 |
| `student-id` | 学号 | 2024-001 |
| `supervisor` | 导师 | 李四 教授 |
| `college` | 学院 | 计算机学院 |
| `major` | 专业 | 计算机科学与技术 |
| `date` | 日期 | 2025年6月 |
| `fenlei` | 中图分类号 | TP391 |
| `miji` | 密级 | 公开 |

## 许可证

CC BY-NC 4.0 - 署名-非商业性使用

## 致谢

基于 [cnDelbert/SDU_thesis_template_for_postgraduate](https://github.com/cnDelbert/SDU_thesis_template_for_postgraduate) 重构。
