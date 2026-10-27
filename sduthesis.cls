% ============================================================
%  sduthesis.cls —— 山东大学研究生学位论文文档类
%
%  版本: 5.0.4
%  引擎: XeLaTeX
%
%  依据:
%    《山东大学研究生学位论文撰写指南》山大研字〔2022〕1 号
%    《2024 版学位论文封面（扉页）》
%
%  文件结构（自上而下，共 5 部分）：
%    1. 选项与基类、宏包            —— 第 1 段
%    2. 用户配置接口（\sdusetup）  —— 用户信息键值与默认值
%    3. 版心、行距、字体            —— 页面与字形（唯一出处）
%    4. 章节标题、页眉页脚、题注、目录、公式与表格
%    5. 封面、声明、摘要、参考文献、后置页面、附录、盲审
% ============================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sduthesis}[2026/10/28 v5.0.4 SDU Thesis]
% Options
\newif\if@sdublindreview \@sdublindreviewfalse
\newif\if@sdumaster \@sdumastertrue
\newif\if@sducolorcover \@sducolorcovertrue
\newif\if@sduchichapter \@sduchichapterfalse

\DeclareOption{blindreview}{\@sdublindreviewtrue}
\DeclareOption{master}{\@sdumastertrue}
\DeclareOption{doctor}{\@sdumasterfalse}
\DeclareOption{colorcover}{\@sducolorcovertrue}
\DeclareOption{bwcover}{\@sducolorcoverfalse}
\DeclareOption{chichapter}{\@sduchichaptertrue}
% biblatex 现在恒为开启（指南四要求 GB/T 7714-2015），此选项保留仅为兼容旧文件
\DeclareOption{biblatex}{}
% 手写 thebibliography 路径已下线
\DeclareOption{manualbib}{%
  \ClassWarning{sduthesis}{选项 manualbib 已不再支持：参考文献固定使用 biblatex +
    GB/T 7714-2015。请改用 \string\addbibresource 与 \string\printbibliography}%
}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax

% Load base class
\LoadClass[12pt,a4paper,openany,twoside]{book}

% Required packages
\RequirePackage[heading=true]{ctex}
\RequirePackage{geometry}
\RequirePackage{indentfirst}
\RequirePackage{setspace}
\RequirePackage{fancyhdr}
\RequirePackage{tocloft}
\RequirePackage{hyperref}
% 关闭链接边框：默认的红色/绿色方框会出现在目录与交叉引用处（实测真实论文即暴露）
\hypersetup{hidelinks, bookmarksnumbered=true}
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{booktabs}
\RequirePackage{caption}
\RequirePackage{enumitem}
\RequirePackage{etoolbox}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{float}
\RequirePackage{multirow}
\RequirePackage{array}
\RequirePackage{longtable}
\RequirePackage{subcaption}   % 指南三（八）：分图 (a)(b)(c)

% ############################################################
%  以下为模板实现。历史版本曾拆为 sduthesis-*.def 五个文件，
%  为便于使用者分发与阅读，现合并为单文件。
% ############################################################

% ============================================================
%  用户配置接口：元数据键值与默认值
% ============================================================
%  sduthesis-options.def
%  用户配置接口：\sdusetup 键值与默认值
%  由 sduthesis.cls 加载，不要单独编译。
%
%  键名对照（2024 版封面字段）：
%    title         论文中文题目
%    titleen       论文外文题目
%    author        作者姓名
%    studentid     学号
%    college       培养单位
%    trainingmode  培养方式（全日制 / 非全日制）
%    major         专业名称
%    supervisor    指导教师
%    cosupervisor  合作导师（无则留空）
%    date          论文完成时间（如 2026年6月）
%    fenlei        分类号（中国图书资料分类法）
%    miji          密级（公开 / 内部 / 秘密 / 机密）
%    unitcode      单位代码（默认 10422）
%    degreetype    学位类型：academic（学术学位）| professional（专业学位）
%                  | interdisciplinary（学科交叉）| equivalent（同等学力）
%                  | engineering（工程硕博士培养改革专项）
%    papertype     学位论文类型，仅 engineering 需要：
%                  专题研究类论文 | 方案设计 | 案例分析报告 | 调研报告 | 产品设计（作品创作）
% ============================================================
\RequirePackage{pgfkeys}

% ---- 元数据存储与默认值 ----
\newcommand{\sdu@title}{}
\newcommand{\sdu@titleen}{}
\newcommand{\sdu@author}{}
\newcommand{\sdu@studentid}{}
\newcommand{\sdu@college}{}
\newcommand{\sdu@trainingmode}{全日制}
\newcommand{\sdu@major}{}
\newcommand{\sdu@supervisor}{}
\newcommand{\sdu@cosupervisor}{}
\newcommand{\sdu@date}{}
\newcommand{\sdu@fenlei}{}
\newcommand{\sdu@miji}{公开}
\newcommand{\sdu@unitcode}{10422}
\newcommand{\sdu@degreetype}{academic}
\newcommand{\sdu@papertype}{}

\pgfkeys{
  /sdu/.is family,
  /sdu/.cd,
  title/.code         = {\def\sdu@title{#1}},
  titleen/.code       = {\def\sdu@titleen{#1}},
  author/.code        = {\def\sdu@author{#1}},
  studentid/.code     = {\def\sdu@studentid{#1}},
  college/.code       = {\def\sdu@college{#1}},
  trainingmode/.code  = {\def\sdu@trainingmode{#1}},
  major/.code         = {\def\sdu@major{#1}},
  supervisor/.code    = {\def\sdu@supervisor{#1}},
  cosupervisor/.code  = {\def\sdu@cosupervisor{#1}},
  date/.code          = {\def\sdu@date{#1}},
  fenlei/.code        = {\def\sdu@fenlei{#1}},
  miji/.code          = {\def\sdu@miji{#1}},
  unitcode/.code      = {\def\sdu@unitcode{#1}},
  degreetype/.code    = {\def\sdu@degreetype{#1}},
  papertype/.code     = {\def\sdu@papertype{#1}},
}

\newcommand{\sdusetup}[1]{\pgfkeys{/sdu/.cd,#1}}

% ---- 兼容旧接口 ----
\newcommand{\sdutitle}[1]{\sdusetup{title={#1}}}
\newcommand{\sdutitleen}[1]{\sdusetup{titleen={#1}}}
\newcommand{\sduauthor}[1]{\sdusetup{author={#1}}}
\newcommand{\sdustudentid}[1]{\sdusetup{studentid={#1}}}
\newcommand{\sdusupervisor}[1]{\sdusetup{supervisor={#1}}}
\newcommand{\sducollege}[1]{\sdusetup{college={#1}}}
\newcommand{\sdumajor}[1]{\sdusetup{major={#1}}}
\newcommand{\sdudate}[1]{\sdusetup{date={#1}}}
\newcommand{\sdufenlei}[1]{\sdusetup{fenlei={#1}}}
\newcommand{\sdumiji}[1]{\sdusetup{miji={#1}}}

% ---- 必填项校验：缺项只给中文警告，不阻断编译 ----
\newcommand{\sdu@reqwarn}[2]{%
  \ifdefempty{#1}{\ClassWarningNoLine{sduthesis}{必填项未填写：#2}}{}}
\AtBeginDocument{%
  \sdu@reqwarn{\sdu@title}{title（论文题目）}%
  \sdu@reqwarn{\sdu@author}{author（作者姓名）}%
  \sdu@reqwarn{\sdu@studentid}{studentid（学号）}%
  \sdu@reqwarn{\sdu@college}{college（培养单位）}%
  \sdu@reqwarn{\sdu@major}{major（专业名称）}%
  \sdu@reqwarn{\sdu@supervisor}{supervisor（指导教师）}%
  \sdu@reqwarn{\sdu@date}{date（完成时间）}%
  % papertype 仅 engineering 使用
  \ifdefstring{\sdu@degreetype}{engineering}{%
    \ifdefempty{\sdu@papertype}{%
      \ClassWarningNoLine{sduthesis}{degreetype=engineering 时 papertype 通常必填}%
    }{}%
  }{%
    \ifdefempty{\sdu@papertype}{}{%
      \ClassWarningNoLine{sduthesis}{papertype 仅 degreetype=engineering 时使用，当前已忽略语义}%
    }%
  }%
}

% ---- 中英文双标题：一次调用同时写中文目录与英文目录（Contents） ----
\newcommand{\bichapter}[2]{\chapter{#1}\echapter{#2}}
\newcommand{\bisection}[2]{\section{#1}\esection{#2}}
\newcommand{\bisubsection}[2]{\subsection{#1}\esubsection{#2}}

% 章级条目数校验：\echapter 调用次数与 chapter 计数器不一致时警告
\newif\if@sduengtoc \@sduengtocfalse
\newcounter{sdu@echapter}
\AtBeginDocument{\setcounter{sdu@echapter}{0}}
\AtEndDocument{%
  \if@sduengtoc
  \ifnum\value{chapter}=\value{sdu@echapter}\else
    \ClassWarningNoLine{sduthesis}{%
      英文目录章条目数（\arabic{sdu@echapter}）与章数（\arabic{chapter}）不一致，%
      请为每个 \string\chapter 补 \string\echapter 或改用 \string\bichapter}%
  \fi
    \fi
}

% ---- 算法编号：用户自行加载 algorithm / algorithm2e 时统一为按章编号 ----
\AtBeginDocument{%
  \@ifpackageloaded{algorithm}{%
    \@ifundefined{c@algorithm}{}{%
      \counterwithin{algorithm}{chapter}%
      \renewcommand{\thealgorithm}{\thechapter-\arabic{algorithm}}%
      \floatname{algorithm}{算法}}%
  }{}%
  \@ifpackageloaded{algorithm2e}{%
    \@ifundefined{c@algocf}{}{%
      \counterwithin{algocf}{chapter}%
      \renewcommand{\thealgocf}{\thechapter-\arabic{algocf}}%
      \SetAlgorithmName{算法}{算法}{算法列表}}%
  }{}%
}

% ---- 封面校名标识：按候选路径查找，便于整包复用或只拷类文件 ----
% 查找顺序：figures/ 下 → 当前目录 → TeX 搜索路径（kpsewhich）
\newcommand{\sdu@coverlogo}{}
\newcommand{\sdu@picklogo}[1]{%
  \IfFileExists{figures/#1}{\gdef\sdu@coverlogo{figures/#1}}{%
  \IfFileExists{#1}{\gdef\sdu@coverlogo{#1}}{%
  \IfFileExists{figures/SDUWords.pdf}{\gdef\sdu@coverlogo{figures/SDUWords.pdf}}{%
  \IfFileExists{SDUWords.pdf}{\gdef\sdu@coverlogo{SDUWords.pdf}}{%
  \gdef\sdu@coverlogo{#1}%
    \ClassWarningNoLine{sduthesis}{%
      未找到封面校名标识 #1，请把 SDUWords.pdf / SDUWordsColor.pdf 放到项目 figures/ 目录，或直接放当前目录}%
  }}}}}
\if@sducolorcover
  \sdu@picklogo{SDUWordsColor.pdf}
\else
  \sdu@picklogo{SDUWords.pdf}
\fi

% 图片来源：默认在 figures/ 下查找，其次当前目录
\graphicspath{{figures/}{figures//}{./}}

% 学位类别行（2024 版封面第三行）：查表法，避免多层 \ifstrequal 嵌套
\def\sdu@dt@academic{（学术学位）}
\def\sdu@dt@professional{（专业学位）}
\def\sdu@dt@interdisciplinary{（学科交叉）}
\def\sdu@dt@equivalent{（同等学力申请\if@sdumaster 硕士\else 博士\fi 学位）}
\def\sdu@dt@engineering{（工程硕博士培养改革专项）}

\newcommand{\sdu@degreetypetext}{%
  \@ifundefined{sdu@dt@\sdu@degreetype}{}{\csname sdu@dt@\sdu@degreetype\endcsname}}

% 仅在工程专项时执行 #1，否则执行 #2
\newcommand{\sdu@ifengineering}[2]{%
  \ifdefstring{\sdu@degreetype}{engineering}{#1}{#2}}

% ============================================================
%  版心、行距、字体
% ============================================================
%  sduthesis-layout.def
%  版心、行距、段首缩进、字体（唯一出处）
%  由 sduthesis.cls 加载，不要单独编译。
%
%  依据：《山东大学研究生学位论文撰写指南》（2022）
%    五、打印与装订：A4 双面；页边距 上 2.8 / 下 2.5 / 左 2.5 / 右 2.5 cm，
%                    装订线位置左侧、0 cm；页眉边距 1.5 cm，页脚边距 1.75 cm
%    三（一）：英文字母、阿拉伯数字、半角标点默认用 Times New Roman
%    三（六）：正文宋体小四号，两端对齐，首行缩进 2 字符，固定值 20 磅
% ============================================================

% ---- 版心 ----
% geometry 的 head 为页眉区高度，headsep 为页眉与正文间距；
% 由「页眉边距 1.5 cm」反推：headsep = 2.8cm - 1.5cm - headheight(15pt) ≈ 0.77cm
% 由「页脚边距 1.75 cm」反推：footskip = 2.5cm - 1.75cm ≈ 0.75cm
\geometry{
  paper      = a4paper,
  top        = 2.8cm,
  bottom     = 2.5cm,
  left       = 2.5cm,
  right      = 2.5cm,
  headheight = 15pt,
  headsep    = 0.77cm,
  footskip   = 0.75cm,
}

% ---- 行距与段落 ----
% 2022 指南三（六）：正文固定值 20 磅。
% 12pt 正文的正常基线距为 14.4pt，故 \baselinestretch = 20/14.4 ≈ 1.3889。
% 注意：靠 \AtBeginDocument 里 \setlength{\baselineskip}{20pt} 是无效的——
% 之后任何 \zihao/\selectfont 都会按 \baselinestretch 重算并覆盖它。
\linespread{1.38889}
\AtBeginDocument{%
  \setlength{\parindent}{2em}%
}

% ---- 字体 ----
% 英文与数字：Times New Roman（2022 三（一））
\IfFontExistsTF{Times New Roman}{%
  \setmainfont{Times New Roman}[Ligatures=TeX]%
}{}

% 中文加粗：SimSun / SimHei 均无独立 bold 字面，必须启用假粗，
% 否则 \bfseries 静默降级为正体（章标题"加粗"失效即由此而来）。
\IfFontExistsTF{SimSun}{%
  % Windows 字体集
  \setCJKfamilyfont{zhsong}[AutoFakeBold=2.5]{SimSun}%
  \setCJKfamilyfont{zhhei}[AutoFakeBold=2.5]{SimHei}%
  \setCJKfamilyfont{zhfs}[AutoFakeBold=2.5]{FangSong}%
  \setCJKfamilyfont{zhkai}[AutoFakeBold=2.5]{KaiTi}%
}{%
  \IfFontExistsTF{FandolSong-Regular}{%
    % fandol 字体集（TeX Live 自带，Linux/CI 用）
    \setCJKfamilyfont{zhsong}[AutoFakeBold=2.5]{FandolSong-Regular}%
    \setCJKfamilyfont{zhhei}[AutoFakeBold=2.5]{FandolHei-Regular}%
    \setCJKfamilyfont{zhfs}[AutoFakeBold=2.5]{FandolFang-Regular}%
    \setCJKfamilyfont{zhkai}[AutoFakeBold=2.5]{FandolKai-Regular}%
  }{%
    \IfFontExistsTF{Songti SC}{%
      % macOS 字体集
      \setCJKfamilyfont{zhsong}[AutoFakeBold=2.5]{Songti SC}%
      \setCJKfamilyfont{zhhei}[AutoFakeBold=2.5]{Heiti SC}%
      \setCJKfamilyfont{zhfs}[AutoFakeBold=2.5]{STFangsong}%
      \setCJKfamilyfont{zhkai}[AutoFakeBold=2.5]{STKaiti}%
    }{%
      \IfFontExistsTF{Noto Serif CJK SC}{%
        % Noto 字体集（fontset=ubuntu；Debian 包 fonts-noto-cjk）
        \setCJKfamilyfont{zhsong}[AutoFakeBold=2.5]{Noto Serif CJK SC}%
        \setCJKfamilyfont{zhhei}[AutoFakeBold=2.5]{Noto Sans CJK SC}%
      }{}%
    }%
  }%
}

% ============================================================
%  章节标题、页眉页脚、题注、目录、公式与表格
% ============================================================
%  sduthesis-styles.def
%  版式：章节标题、页眉页脚、图表题注与编号、列表、目录
%  由 sduthesis.cls 加载，不要单独编译。
%
%  依据：《山东大学研究生学位论文撰写指南》（2022）
%    三（七）章标题 黑体小三加粗 居中 段前24磅 段后18磅 单倍行距 每章另起一页
%           二级标题 黑体四号加粗 段前24磅 段后6磅
%           三级标题 黑体小四加粗 段前12磅 段后6磅
%    三（八）图题 宋体五号 居中 段前6磅 段后6磅 图题在图下方
%    三（九）表题 宋体五号 居中 段前6磅 段后6磅 表题在表上方
%    三（十）公式分章编号 (1-1)，编号右端对齐
%    三（十一）从摘要开始每页有页眉，居中「山东大学博（硕）士学位论文」，宋体五号
%              页码居中于页面底端，五号 Times New Roman，两侧不加修饰线
% ============================================================

% ---- 章节标题 ----
\if@sduchichapter
  \ctexset{
    chapter/name   = {第,章},
    chapter/number = \chinese{chapter},
  }
\else
  \ctexset{
    chapter/name   = {,},
    chapter/number = \arabic{chapter},
  }
\fi

\ctexset{
  chapter/format      = \linespread{1}\centering\zihao{-3}\heiti\bfseries,
  chapter/beforeskip  = 24pt,
  chapter/afterskip   = 18pt,
  chapter/fixskip     = true,
  section/format      = \linespread{1}\zihao{4}\heiti\bfseries,
  section/beforeskip  = 24pt,
  section/afterskip   = 6pt,
  section/fixskip     = true,
  subsection/format   = \linespread{1}\zihao{-4}\heiti\bfseries,
  subsection/beforeskip = 12pt,
  subsection/afterskip  = 6pt,
  subsection/fixskip    = true,
  contentsname        = 目录,
  figurename          = 图,
  tablename           = 表,
}

% ---- 页眉页脚 ----
% 页眉文字固定为「山东大学博（硕）士学位论文」，不再用章节名
\newcommand{\sdu@headertext}{%
  \if@sdumaster 山东大学硕士学位论文\else 山东大学博士学位论文\fi}

\pagestyle{fancy}
\fancyhf{}
\fancyhead[C]{\zihao{5}\songti\sdu@headertext}
\fancyfoot[C]{\zihao{5}\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}

% plain 用于章首页（book 的 \chapter 会自动切换至此），
% 2022 指南要求「从摘要开始每页要有页眉」，故 plain 同样带页眉。
% 封面与声明改用 empty，不受影响。
\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyhead[C]{\zihao{5}\songti\sdu@headertext}%
  \fancyfoot[C]{\zihao{5}\thepage}%
  \renewcommand{\headrulewidth}{0.4pt}%
}

% ---- 图表题注 ----
\DeclareCaptionFont{sduwuhao}{\linespread{1}\zihao{5}\songti}
\captionsetup{
  font          = sduwuhao,
  labelfont     = sduwuhao,
  labelsep      = space,
  justification = centering,
  skip          = 6pt,
}

% ---- 图表公式分章编号（图 1-1 / 表 1-1 / 式 (1-1)） ----
\counterwithin{figure}{chapter}
\counterwithin{table}{chapter}
\renewcommand{\thefigure}{\thechapter-\arabic{figure}}
\renewcommand{\thetable}{\thechapter-\arabic{table}}
\counterwithin{equation}{chapter}
\renewcommand{\theequation}{\thechapter-\arabic{equation}}

% ---- 公式排版：编号右端对齐，公式与编号之间用点线连接（三（十）） ----
% 提供 sduequation 环境：单行公式居中，编号右端对齐，中间以点线填充。
% amsmath 的 equation/align 等保持原样（多行公式仍用它们），编号同样分章。
% 注意：左侧必须用 \hfill（二阶无穷）而不是 \hfil，才能与点线的 \hfill 均分
% 伸缩量，使公式居中；否则点线会吃掉全部伸缩、把公式挤到左边距。
\newenvironment{sduequation}{%
  \refstepcounter{equation}%
  \par\addvspace{\abovedisplayskip}%
  \noindent\hbox to \linewidth\bgroup\hfill$\displaystyle
}{%
  $\leaders\hbox{$\m@th\mkern2mu\cdot\mkern2mu$}\hfill(\theequation)\egroup
  \par\addvspace{\belowdisplayskip}%
}

% ---- 列表 ----
\setlist[enumerate]{itemsep=0pt,parsep=0pt}
\setlist[itemize]{itemsep=0pt,parsep=0pt}

% ---- 续表支持（指南三（九）：转页接排时重复表号与表头） ----
% 用法（longtable 内）：
%   \sdutablecaption{表题}\label{tab:x}\\   ← 首次出现，正常表题
%   ...表头...
%   \endfirsthead
%   \sdutablecont\\                          ← 续页重复「续表 x-y + 表题」
%   ...表头...                               ← 续页重复表头
%   \endhead
\newcommand{\sdu@tabtitle}{}
\newcommand{\sdutablecaption}[1]{%
  \caption{#1}\gdef\sdu@tabtitle{#1}}
\newcommand{\sdutablecont}{%
  \caption*{续表~\thetable\hspace{1em}\sdu@tabtitle}}

% ---- 图注与表附注（指南三（八）（九）：阿拉伯数字按顺序编排） ----
% 图注排在图题下方、表附注排在表下方；每个浮动体内从 1 重新编号。
% 用法：
%   \begin{figure} ... \caption{...}
%     \begin{sdufigurenotes}\item 说明一 \item 说明二 \end{sdufigurenotes}
%   \end{figure}
%   \begin{table} ... \bottomrule
%     \begin{sdutablenotes}\item 说明一 \end{sdutablenotes}
%   \end{table}
\newlist{sdunotelist}{enumerate}{1}
\setlist[sdunotelist]{%
  label      = \arabic*),
  ref        = \arabic*,
  font       = \zihao{5}\songti,
  nosep,
  topsep     = 2pt,
  leftmargin = 2em,
  labelsep   = 0.4em,
}
\newenvironment{sdufigurenotes}%
  {\par\vspace{2pt}\begin{sdunotelist}}%
  {\end{sdunotelist}}
\newenvironment{sdutablenotes}%
  {\par\vspace{2pt}\begin{sdunotelist}}%
  {\end{sdunotelist}}

% ---- 目录 ----
% 目录标题：小三加粗黑体，居中，段前 24 磅、段后 18 磅（三（五））
\renewcommand{\cfttoctitlefont}{\hfill\linespread{1}\zihao{-3}\heiti\bfseries}
\renewcommand{\cftaftertoctitle}{\hfill}
\setlength{\cftbeforetoctitleskip}{24pt}
\setlength{\cftaftertoctitleskip}{18pt}

% 目录条目：小四号宋体，单倍行距（三（五））
\renewcommand{\cftchapfont}{\linespread{1}\zihao{-4}\songti}
\renewcommand{\cftsecfont}{\linespread{1}\zihao{-4}\songti}
\renewcommand{\cftsubsecfont}{\linespread{1}\zihao{-4}\songti}
\renewcommand{\cftchappagefont}{\linespread{1}\zihao{-4}\songti}
\renewcommand{\cftsecpagefont}{\linespread{1}\zihao{-4}\songti}
\renewcommand{\cftsubsecpagefont}{\linespread{1}\zihao{-4}\songti}
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}
\setlength{\cftbeforechapskip}{6pt}
\setlength{\cftbeforesecskip}{0pt}
\setlength{\cftbeforesubsecskip}{0pt}

% 下级标题比上级左边多空两个汉字符宽度（三（五））
\setlength{\cftchapindent}{0pt}
\setlength{\cftsecindent}{2em}
\setlength{\cftsubsecindent}{4em}

\newcommand{\tableofengcontents}{%
  \@sduengtoctrue
  \clearpage
  \chapter*{Contents}%
  \addcontentsline{toc}{chapter}{Contents}%
  \markboth{Contents}{}%
  \setlength{\baselineskip}{20pt}%
  \zihao{-4}%
  \@starttoc{toe}%
}



% ============================================================
%  封面、原创性声明、中英文摘要
% ============================================================
%  sduthesis-pages.def
%  前置页：封面（2024 版）、原创性声明、中英文摘要
%  由 sduthesis.cls 加载，不要单独编译。
%
%  封面依据：《2024 版学位论文封面（扉页）》Word 模板（13 个变体）
%    第 1 行  分类号：＿＿        单位代码：10422
%    第 2 行  密　级：＿＿        学　号：＿＿
%    校名标识（黑白/彩色由 colorcover|bwcover 决定）
%    学位名（黑体加粗 60pt）＋ 英文名（Times New Roman 18pt）＋ 学位类别（黑体 26pt）
%    工程专项另加「学位论文类型：…」（22pt 加粗）
%    论文题目：
%    作者姓名／培养单位／培养方式／专业名称／指导教师／合作导师（右对齐标签＋下划线）
%    年　月　日（黑体 16pt，居中）
%
%  摘要依据：2022 指南 三（三）（四）
% ============================================================

% 下划线填空
\newcommand{\sdu@fill}[1]{\underline{\makebox[6.4cm][c]{#1}}}
\newcommand{\sdu@field}[2]{\underline{\makebox[#1][l]{#2}}}

% 封面主体：先装进 vbox 测量，超出页面时整体缩放（防超长题目压到第二页）
\newbox\sdu@coverbox
% 封面主体：先量自然高度；超出页面则整体等比缩放，否则用 \vfill 撑满
\newbox\sdu@coverbox
\newcommand{\sdu@coverbody}{%
  \linespread{1}\selectfont
  \setlength{\parindent}{0pt}%
    % ---------- 顶部信息 ----------
    {\fontsize{15pt}{20pt}\selectfont\songti
      \noindent
      分类号：\sdu@field{2.8cm}{\sdu@fenlei}\hfill 单位代码：\sdu@field{2.4cm}{\sdu@unitcode}\par
      \vspace{10pt}%
      \noindent
      密\hspace{1em}级：\sdu@field{2.8cm}{\sdu@miji}\hfill
      学\hspace{1em}号：\sdu@field{3.4cm}{\sdu@studentid}\par
    }%
    % ---------- 校名标识 ----------
\vspace{0.6cm plus 0.2cm minus 0.45cm}%
    \begin{center}%
      \includegraphics[width=8.8cm]{\sdu@coverlogo}%
    \end{center}%
    % ---------- 学位名 ----------
\vspace{0.55cm plus 0.2cm minus 0.4cm}%
    \begin{center}%
      {\fontsize{60pt}{68pt}\selectfont\heiti\bfseries
        \if@sdumaster 硕士学位论文\else 博士学位论文\fi\par}%
      \vspace{0.15cm}%
      {\fontsize{18pt}{22pt}\selectfont
        \if@sdumaster Thesis for Master Degree\else Dissertation for Doctoral Degree\fi\par}%
      \vspace{0.1cm}%
      {\fontsize{26pt}{32pt}\selectfont\heiti \sdu@degreetypetext\par}%
      \sdu@ifengineering{%
        \vspace{0.15cm}%
        {\fontsize{22pt}{27pt}\selectfont\heiti\bfseries
          学位论文类型：\sdu@papertype\par}%
      }{}%
    \end{center}%
    % ---------- 题目标签 ----------
\vspace{0.5cm plus 0.3cm minus 0.35cm}%
    \noindent
    {\fontsize{15pt}{20pt}\selectfont\songti
      \sdu@ifengineering{题目：}{论文题目：}}%
    \parbox[t]{12.3cm}{\raggedright\fontsize{18pt}{24pt}\selectfont\heiti\bfseries
      \sdu@title}%
    \par
    % 封面的论文题目需中、外文标示（二（一）三（二））：三号加粗
    \ifdefempty{\sdu@titleen}{}{%
      \vspace{0.15cm}%
      \noindent\hspace*{3.1cm}%
      \parbox[t]{12.3cm}{\raggedright\fontsize{16pt}{20pt}\selectfont\bfseries
        \sdu@titleen}%
      \par}%
    % ---------- 作者信息 ----------
    \vfill
    \begin{center}%
      {\fontsize{15pt}{20pt}\selectfont\songti
        \renewcommand{\arraystretch}{1.55}%
        \begin{tabular}{@{}r@{\hspace{0.6em}}l@{}}%
          作\hspace{0.5em}者\hspace{0.5em}姓\hspace{0.5em}名 & \sdu@fill{\sdu@author}\\
          培\hspace{0.5em}养\hspace{0.5em}单\hspace{0.5em}位 & \sdu@fill{\sdu@college}\\
          培\hspace{0.5em}养\hspace{0.5em}方\hspace{0.5em}式 & \sdu@fill{\sdu@trainingmode}\\
          专\hspace{0.5em}业\hspace{0.5em}名\hspace{0.5em}称 & \sdu@fill{\sdu@major}\\
          指\hspace{0.5em}导\hspace{0.5em}教\hspace{0.5em}师 & \sdu@fill{\sdu@supervisor}\\
          合\hspace{0.5em}作\hspace{0.5em}导\hspace{0.5em}师 & \sdu@fill{\sdu@cosupervisor}\\
        \end{tabular}}%
    \end{center}%
    % ---------- 日期 ----------
    \vfill
    \begin{center}%
      {\fontsize{16pt}{20pt}\selectfont\heiti
        \ifdefempty{\sdu@date}{年\hspace{2em}月\hspace{2em}日}{\sdu@date}\par}%
    \end{center}%
% （末行间距已并入 \vfill，长标题时自动收缩）
}
\renewcommand{\maketitle}{%
  \begin{titlepage}%
    \thispagestyle{empty}%
    % 先量自然高度：超出页面时给出可操作警告（不自动缩放，避免缩小字号反而更不美观）
    \setbox\sdu@coverbox=\vbox{\sdu@coverbody}%
    \ifdim\ht\sdu@coverbox>\dimexpr\textheight+60pt\relax
      \ClassWarningNoLine{sduthesis}{%
        封面内容超出页面高度（\the\ht\sdu@coverbox > \the\textheight）：%
        请在 sdusetup 的 title / titleen 中用 \string\\ 手动断行，或缩短题目、精简封面信息}%
    \fi
    \setbox\sdu@coverbox=\vbox to \textheight{\unvbox\sdu@coverbox}%
    \noindent\box\sdu@coverbox
  \end{titlepage}%
}

% ---------------- 原创性声明 ----------------
\newcommand{\makestatement}{%
  \clearpage
  \thispagestyle{empty}%
  \begin{center}
    {\zihao{3}\heiti\bfseries 原创性声明}
  \end{center}
  \vspace{1cm}
  \setlength{\baselineskip}{20pt}
  \zihao{-4}\songti
  本人郑重声明：所呈交的学位论文，是本人在导师的指导下，独立进行研究所取得的成果。除文中已经注明引用的内容外，本论文不包含任何其他个人或集体已经发表或撰写过的科研成果。对本文的研究做出重要贡献的个人和集体，均已在文中以明确方式标明。本人完全意识到本声明的法律责任由本人承担。
  \vspace{2cm}
  \begin{flushright}
    论文作者签名：\underline{\hspace{4cm}} \hspace{1cm} 日期：\underline{\hspace{3cm}}
  \end{flushright}
  \vspace{2cm}
  \begin{center}
    {\zihao{3}\heiti\bfseries 关于学位论文使用授权的声明}
  \end{center}
  \vspace{1cm}
  本人完全了解山东大学有关保留、使用学位论文的规定，同意学校保留或向国家有关部门或机构送交论文的复印件和电子版，允许论文被查阅和借阅；本人授权山东大学可以将本学位论文的全部或部分内容编入有关数据库进行检索，可以采用影印、缩印或其他复制手段保存论文和汇编本学位论文。
  \vspace{2cm}
  \begin{flushright}
    论文作者签名：\underline{\hspace{4cm}} \hspace{1cm} 日期：\underline{\hspace{3cm}}
  \end{flushright}
  \clearpage
}

% ---------------- 中文摘要（2022 三（三）） ----------------
\newenvironment{cnabstract}{%
  \clearpage
  \pagestyle{fancy}%
  \chapter*{摘要}%
  \addcontentsline{toc}{chapter}{摘要}%
  \markboth{摘要}{}%
  \vspace*{24pt}%
  \setlength{\baselineskip}{20pt}%
  \zihao{-4}\songti
}{\clearpage}

\newcommand{\cnkeywords}[1]{%
  \par\vspace{1em}%
  \noindent{\songti\bfseries 关键词：}#1%
}
\let\keywords\cnkeywords

% ---------------- 外文摘要（2022 三（四）） ----------------
\newenvironment{enabstract}{%
  \clearpage
  \chapter*{ABSTRACT}%
  \addcontentsline{toc}{chapter}{ABSTRACT}%
  \markboth{ABSTRACT}{}%
  \vspace*{24pt}%
  \setlength{\baselineskip}{20pt}%
  \zihao{-4}%
}{\clearpage}

\newcommand{\enkeywords}[1]{%
  \par\vspace{1em}%
  \noindent{\bfseries Key words: }#1%
}
\let\keywordsen\enkeywords







% ============================================================
%  参考文献、后置页面、附录、盲审
% ============================================================
% Bibliography —— 始终使用 biblatex + GB/T 7714-2015
% 依据：指南 三（十二）参考文献格式；四、参考文献著录规则（GB/T 7714-2015）
% 用法：主文件导言区 \addbibresource{xxx.bib}，正文之后 \printbibliography
\RequirePackage[backend=biber,style=gb7714-2015]{biblatex}
% 参考文献文本：宋体小四，固定值 20 磅（三（十二））
\renewcommand*{\bibfont}{\zihao{-4}\songti}
% 标题由章格式承接：黑体小三加粗、居中、段前 24 磅、段后 18 磅、另起一页

% English TOC commands
\newcommand{\echapter}[1]{\addcontentsline{toe}{chapter}{#1}\stepcounter{sdu@echapter}}
\newcommand{\esection}[1]{\addcontentsline{toe}{section}{#1}}
\newcommand{\esubsection}[1]{\addcontentsline{toe}{subsection}{#1}}

% Symbol notation
\newcommand{\makesymbolnotation}{%
  \chapter*{符号说明}
  \addcontentsline{toc}{chapter}{符号说明}
  \markboth{符号说明}{}
  \setlength{\baselineskip}{20pt}
  \zihao{-4}\songti
}

% Publications
\newcommand{\makepublications}{%
  \chapter*{攻读学位期间发表的学术论文目录}
  \addcontentsline{toc}{chapter}{攻读学位期间发表的学术论文目录}
  \markboth{攻读学位期间发表的学术论文目录}{}
  \setlength{\baselineskip}{20pt}
  \zihao{-4}\songti
}

% Defense
\newcommand{\makedefense}{%
  \chapter*{学位论文评阅及答辩情况}
  \addcontentsline{toc}{chapter}{学位论文评阅及答辩情况}
  \markboth{学位论文评阅及答辩情况}{}
  \setlength{\baselineskip}{20pt}
  \zihao{-4}\songti
}

% Acknowledgement
\newcommand{\acknowledgement}{%
  \chapter*{致\hspace{1em}谢}
  \addcontentsline{toc}{chapter}{致谢}
  \markboth{致谢}{}
  \setlength{\baselineskip}{20pt}
  \zihao{-4}\songti
}

% Appendix
\AtBeginDocument{%
  \let\old@appendix\appendix
  \renewcommand{\appendix}{%
    \old@appendix
    \ctexset{
      chapter={
        name={附录,},
        number=\Alph{chapter},
      }
    }%
  }%
}

% 盲审模式：隐去封面可识别字段
% 注意：必须在 \AtBeginDocument 执行——若在类加载期改字段，随后 \sdusetup 会把真实值写回
% （本模板 v5.0.2 修复的正是这个缺陷：此前 blindreview 实际无效）
\AtBeginDocument{%
  \if@sdublindreview
    \renewcommand{\sdu@author}{（隐去）}%
    \renewcommand{\sdu@supervisor}{（隐去）}%
    \renewcommand{\sdu@studentid}{（隐去）}%
    \renewcommand{\sdu@cosupervisor}{}%
  \fi
}




\endinput










