# sduthesis —— 山东大学研究生学位论文 LaTeX 模板

用 LaTeX 写山东大学硕士 / 博士学位论文的模板。封面、声明页、摘要、目录、章节、图表、
公式、参考文献的格式都按学校规范做好，你只需要填内容。

格式依据：

- 《山东大学研究生学位论文撰写指南》（山大研字〔2022〕1 号）
- 《2024 版学位论文封面（扉页）》（学校下发表单，13 个变体）

## 特点

- **封面自动生成**：13 种学位类型变体（学术学位 / 专业学位 / 学科交叉 / 同等学力 /
  工程硕博士专项），按你的选择自动出封面与页眉
- **格式已对齐规范**：页边距、字号、行距、页眉页码、章节标题、图表题注、公式编号
- **参考文献用标准工作流**：`.bib` 文件 + biblatex + GB/T 7714-2015，可从 Zotero 直接导出
- **一套配置管全部**：论文信息只写在 `sdusetup.tex` 一个文件里
- **跨平台**：Windows / macOS / Linux 都能编译

## 快速开始

### 1. 准备环境

| 必需 | 说明 |
|---|---|
| XeLaTeX | 中文排版必需，推荐 TeX Live 完整安装或 MiKTeX |
| biber | 生成参考文献，TeX Live / MiKTeX 默认自带 |

> Windows 用户如果 `latexmk` 报"找不到 perl"，装一个 [Strawberry Perl](https://strawberryperl.com/)
> 即可；或者直接用本仓库的 `build.ps1`（它会把 Git 自带的 perl 加进 PATH）。

### 2. 编译

```powershell
# Windows（无需 make）
pwsh -File build.ps1

# 通用
latexmk -xelatex thesis

# macOS / Linux
make
```

产物在 `build/thesis.pdf`。首次编译需要跑几遍才能把目录和引用编号稳定下来，
`latexmk` 会自动处理。

### 3. 开始写

1. 打开 `sdusetup.tex`，把题目、姓名、学号、学院、导师等信息改成你自己的
2. 在 `chapters/` 里写正文，`figures/` 放图
3. 参考文献放进 `thesis.bib`，正文用 `\cite{key}` 引用

**你只需要动这三处**；其余文件是模板本体，升级模板时可以直接覆盖。

## 目录结构

```
sduthesis.cls    模板本体（单文件，约 680 行）
thesis.tex       主文件：前置 / 正文 / 后置的顺序
sdusetup.tex     ★ 论文信息（唯一必改）
thesis.bib       参考文献库
chapters/        正文与致谢、附录、发表论文等
figures/         插图（含校名标识 SDUWords*.pdf）

README.md  LICENSE  NOTICE   说明、许可与来源
latexmkrc  build.ps1         编译配置与 Windows 一键脚本
```

整个模板只有 **一个类文件**，没有子目录依赖——下载即可用。
## 文档类选项

```latex
\documentclass[
  master,          % master 硕士 | doctor 博士
  bwcover,         % bwcover 黑白 | colorcover 彩色
  % blindreview,   % 盲审：隐去作者、导师、学号
  % chichapter,    % 章标题用「第一章」（默认「1」，工学建议）
  fontset=windows, % windows | mac | ubuntu | fandol
]{sduthesis}
```

> 封面用彩色还是黑白，看你的学位类型：2024 版表单里工程硕博士专项用彩色，其余用黑白。

## 填写论文信息

`sdusetup.tex` 里的每一项：

| 键 | 填什么 |
|---|---|
| `title` / `titleen` | 中文题目 / 外文题目（封面两者都要；外文留空则不显示） |
| `author` / `studentid` | 姓名 / 学号 |
| `college` | 培养单位（学院） |
| `trainingmode` | 全日制 / 非全日制 |
| `major` | 专业名称 |
| `supervisor` / `cosupervisor` | 导师 / 合作导师（没有就留空） |
| `date` | 完成时间，如 `2026年6月` |
| `fenlei` / `miji` | 分类号（中图法）/ 密级 |
| `degreetype` | `academic` 学术学位 · `professional` 专业学位 · `interdisciplinary` 学科交叉 · `equivalent` 同等学力 · `engineering` 工程硕博士专项 |
| `papertype` | 学位论文类型，仅 `engineering` 需要填 |

> ⚠️ 花括号里**不要留空行**——TeX 会把空行当成段落结束，导致解析中断。

## 排版示例

### 公式

单行公式用 `sduequation`，自动居中、编号右端对齐、中间用点线连接：

```latex
\begin{sduequation}
  \frac{\partial \rho}{\partial t} + \nabla\cdot(\rho\,\mathbf{v}) = 0
  \label{eq:continuity}
\end{sduequation}
```

多行公式照常写 `\begin{align}...\end{align}`，编号同样按章编排（`(1-1)`）。

### 跨页长表

普通三线表用 `booktabs`。表格太长需要跨页时用 `longtable`，续页会自动重复
"续表 x-y + 表题"和表头：

```latex
\begin{longtable}{ccc}
  \sdutablecaption{跨页长表示例}\label{tab:long}\\
  \toprule 序号 & 测量值 & 偏差 \\ \midrule
  \endfirsthead
  \sdutablecont\\            % 续页自动生成的表题
  \toprule 序号 & 测量值 & 偏差 \\ \midrule
  \endhead
  \bottomrule
  \endfoot
  1 & 0.312 & 0.004 \\
\end{longtable}
```

### 图注与表附注

需要给图或表加说明时，把说明放在图题下方或表格下方，会自动按 1) 2) 3) 编号：

```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.5\textwidth]{figures/xxx.pdf}
  \caption{图题}
  \begin{sdufigurenotes}
    \item 图注一
    \item 图注二
  \end{sdufigurenotes}
\end{figure}
```

```latex
\begin{table}[htbp]
  \centering
  \caption{表题}
  \begin{tabular}{...} ... \end{tabular}
  \begin{sdutablenotes}
    \item 附注一
  \end{sdutablenotes}
\end{table}
```

## 用在其他项目里

三种方式，按需要选：

### 方式一：整包复制（推荐写学位论文）

```powershell
git clone https://github.com/KindKeeper/sduthesis.git 我的论文
cd 我的论文
# 改 sdusetup.tex 填自己的信息，chapters/ 里写正文
latexmk -xelatex thesis
```

或者直接下载 GitHub 上的 zip 解压改名。

### 方式二：只借类文件（已有自己的项目结构）

把 `sduthesis.cls` 与两个校名标识复制进你的项目，然后自己写一个主文件：

```
你的项目/
├── sduthesis.cls
├── SDUWords.pdf          ← 或者放进 figures/
├── SDUWordsColor.pdf
├── 你的主文件.tex
├── 你的章节/
└── 你的图片/
```

最小主文件：

```latex
\documentclass[master,bwcover,fontset=windows]{sduthesis}

\sdusetup{
  title      = {论文题目},
  titleen    = {Thesis Title},
  author     = {张三},
  studentid  = {2020xxxxxxxx},
  college    = {示例学院},
  trainingmode = {全日制},
  major      = {示例专业},
  supervisor = {导师姓名},
  date       = {2026年6月},
  degreetype = {academic},
}

\begin{document}
\maketitle
\makestatement
\frontmatter ... \mainmatter
\end{document}
```

> 校名标识的查找顺序：`figures/` → 当前目录 → TeX 搜索路径。找不到会给出明确警告而不是直接崩。

### 方式三：装到本机，多项目共用

把 `sduthesis.cls` 与两个 PDF 放进 TeX 的用户目录，之后任何项目都能直接 `\documentclass{sduthesis}`：

```powershell
# Windows（MiKTeX，用户级）
mkdir C:\Users\<你>\texmf\tex\latex\sduthesis
copy sduthesis.cls  C:\Users\<你>\texmf\tex\latex\sduthesis\
copy SDUWords*.pdf  C:\Users\<你>\texmf\tex\latex\sduthesis\
initexmf --update-fndb
```

```bash
# macOS / Linux（TeX Live）
mkdir -p ~/texmf/tex/latex/sduthesis
cp sduthesis.cls SDUWords*.pdf ~/texmf/tex/latex/sduthesis/
texhash
```

> 这种方式**没有** `thesis.tex` 与 `sdusetup.tex` 模板可抄，主文件得自己写（见方式二）。

## 常见问题

**编译报错找不到字体？**
把 `fontset` 改成与你系统匹配的：Windows 用 `windows`，macOS 用 `mac`，Linux 用 `ubuntu` 或 `fandol`。

**参考文献是空的 / 显示 [?]？**
确认有 `biber`（命令行执行 `biber --version`），并让 `latexmk` 完整跑一遍（不要只跑一次 `xelatex`）。

**中文加粗看不出来？**
模板已为 SimSun / SimHei 启用了假粗，正常编译即可。如果仍不正常，检查是否用了非 `fontset` 指定的字体。

**封面信息对不上？**
先看 `degreetype` 是否与你的学位类型一致；工程硕博士专项还需要填 `papertype`。

**编译时提示"必填项未填写"？**
模板会检查 `sdusetup.tex` 里的题目 / 姓名 / 学号 / 学院 / 专业 / 导师 / 日期，缺项编译仍会继续但封面会留白——按警告补全即可。

**参考文献标了 `[J/OL]` 而不是 `[J]`？**
这是 GB/T 7714-2015 的在线载体标识（条目带 DOI/URL 时自动加）。要一律用印刷版标识，在 `thesis.tex` 里加一行
`\ExecuteBibliographyOptions{gbmedium=false}`（文件里已有注释示例）。

**英文目录（Contents）少了条目？**
英文目录靠 `\echapter` / `\esection` / `\esubsection` 手工登记。可直接用包装命令一次写两条：
`\bichapter{绪论}{Introduction}`、`\bisection{研究背景}{Background}`。
章级条目数不一致时，编译日志会给出警告。

**算法编号不是 `3-1` 而是 `1`？**
只要你加载了 `algorithm` 或 `algorithm2e`，模板会自动把编号改为按章（`3-1`）并把题注名改成"算法"。

**`build.ps1 -Check` 报找不到 `tests/`？**
已修复：仓库不附带测试脚本时自动退回内置快速自检（编译错误 / 未定义引用 / PDF 产出 / 封面字段）。
页数统计需要 `pypdf`（可选）：`py -m pip install pypdf`。

**要用盲审模式？**
文档类加 `blindreview` 选项即可：

```latex
\documentclass[master,bwcover,blindreview]{sduthesis}
```

封面上的作者姓名、学号、指导教师会显示为「（隐去）」。
**注意**：致谢、攻读学位期间成果、页眉等处的个人信息属内容层，需你自行删除或脱敏。

**题目太长，封面显示异常？**
编译日志会给出「封面内容超出页面高度」警告。在 `sdusetup.tex` 的 `title` / `titleen` 里用 `\\` 手动断行，
或适当缩短题目即可；中英文题目分别控制在两行 / 三行以内最稳妥。

## 已知限制

1. **封面信息栏字号**：2022 指南写"四号加粗黑体"，而学校 2024 年下发的封面表单是 15pt 宋体。
   模板采用 2024 表单（较新且更具体）。若学院另有要求，改 `sduthesis.cls` 中封面部分的一处 `\fontsize{15pt}` 即可。
2. **不支持手写 `thebibliography`**：参考文献固定用 biblatex + GB/T 7714-2015。
3. **`gbmedium` 默认开启**：带 DOI/URL 的条目输出 `[J/OL]`。若学院要求 `[J]`，加一行
   `\ExecuteBibliographyOptions{gbmedium=false}`。
4. **扉页**尚未提供（指南二（二））——如需单独一页扉页，请先确认学院要求。
5. **扩展包加载顺序**：`hyperref` 由模板在导言区加载；`cleveref`、`tcolorbox` 等依赖它的宏包
   放在 `\begin{document}` 之前自行加载即可。`tabularx` / `siunitx` / `algorithm2e` / `listings`
   等常用包模板不预加载，避免与其他项目冲突。
6. **许可**：本仓库为 **MIT**，可自由使用、修改、再分发（含商业用途）；文档类设计源自 CTAN `sduthesis`（LPPL-1.3+），
   来源与署名见 [`NOTICE`](NOTICE)。

## 致谢

- 设计思路借鉴清华大学 [thuthesis](https://github.com/tuna/thuthesis)
- 早期版本来自 [cnDelbert/SDU_thesis_template_for_postgraduate](https://github.com/cnDelbert/SDU_thesis_template_for_postgraduate)
  与 CTAN [sduthesis](https://ctan.org/pkg/sduthesis)
- 格式依据来自山东大学研究生院与校长办公室发布的规范文件

来源、署名与许可见 [`NOTICE`](NOTICE)。当前版本 **v5.0.3**。









