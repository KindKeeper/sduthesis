% ========================
% 文档类声明与基本信息
% ========================
\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{sduthesis}[2025/04/03 v2.0.0 山东大学研究生学位论文模板]

% ========================
% 选项处理模块
% ========================
\RequirePackage{kvoptions}          % 键值选项处理
\RequirePackage{etoolbox}           % 工具宏包
\SetupKeyvalOptions{family=SDU, prefix=SDU@opt@, setkeys=\kvsetkeys}
\newcommand{\ekv}[1]{\kvsetkeys{SDU}{#1}}

% 声明布尔选项
\DeclareBoolOption[true]{chsstyle}   % 中文样式开关
\DeclareComplementaryOption{nochsstyle}{chsstyle}
\DeclareBoolOption[false]{print}     % 打印模式开关
\DeclareComplementaryOption{noprint}{print}
\DeclareBoolOption[true]{double}     % 双面打印开关
\DeclareComplementaryOption{single}{double}

% 处理未知选项
\DeclareDefaultOption{\PassOptionsToPackage{\CurrentOption}{ctexcap}}

% ========================
% 文档基础设置
% ========================
\LoadClass[a4paper, 12pt]{book}      % 基于book类，A4纸张，12pt字号
\ProcessKeyvalOptions*\relax         % 处理已声明选项

% 单面打印时取消章节右开页
\ifSDU@opt@double\relax\else
  \PassOptionsToClass{openany}{book}
\fi

% ========================
% 中文支持与字体设置
% ========================
\RequirePackage[noindent,nocap,UTF8]{ctexcap}  % 中文支持

% XeLaTeX环境下的字体设置
\RequirePackage{ifpdf,ifxetex}
\ifxetex
  % 检测并设置黑体伪粗体
  \IfFontExistsTF{SimHei}{
    \newCJKfontfamily[heitiFakeBold]{\heitiFakeBold}{SimHei}[AutoFakeBold=2.5]
  }{
    \newcommand{\heitiFakeBold}{\heiti}
  }
  % 设置西文主字体
  \IfFontExistsTF{Times New Roman}{
    \setmainfont{Times New Roman}
  }
\else
  \newcommand{\heitiFakeBold}{\heiti}  % 非XeLaTeX环境
\fi

% ========================
% 行距与页面设置
% ========================
\RequirePackage{setspace}            % 行距控制
\setstretch{1.667}                   % 固定行距20磅 (12pt×1.667)

% 页面边距设置
\ifSDU@opt@double
  \newcommand{\GeoOptions}{left=2.5cm, right=2.5cm, top=2.8cm, bottom=2.5cm}
\else
  \newcommand{\GeoOptions}{left=2.5cm, right=2.5cm, top=2.8cm, bottom=2.5cm}
\fi
\RequirePackage[\GeoOptions]{geometry} % 页面几何设置

% ========================
% 页眉页脚设置
% ========================
\RequirePackage{fancyhdr}            % 页眉页脚定制
\pagestyle{fancyplain}
\fancyhf{}                           % 清除默认设置

% 自定义页眉装饰线
\newcommand{\makeheadrule}{%
  \makebox[0pt][l]{\rule[.7\baselineskip]{\headwidth}{0.8pt}}%
  \rule[0.85\baselineskip]{\headwidth}{1.5pt}\vskip-.8\baselineskip}

\makeatletter
\renewcommand{\headrule}{%
  {\if@fancyplain\let\headrulewidth\plainheadrulewidth\fi
   \makeheadrule}}
\makeatother

% 页眉内容设置
\fancyhf{}
\makeatletter
\ifSDU@opt@chsstyle
  \chead{\zihao{5}\songti 山东大学博（硕）士学位论文}
\else
  \chead{\small \the\EThesisHeader}
\fi
\makeatother

% 页脚页码设置
\fancyfoot[LE,RO]{\zihao{5}\thepage} % 外侧页码

% ========================
% 数学支持模块
% ========================
\RequirePackage{amsmath, amsfonts, amsthm, amssymb, amsbsy, bm, mathrsfs}
\newcommand*{\me}{\ensuremath{\mathrm{e}}}      % 自然对数底
\newcommand*{\mi}{\ensuremath{\mathrm{i}}}      % 虚数单位
\newcommand*{\dif}{\ensuremath{\,\mathrm{d}}}    % 微分算子
\DeclareMathAlphabet{\mathsfsl}{OT1}{cmss}{m}{sl}
\newcommand*{\VEC}[1]{\ensuremath{\boldsymbol{#1}}}         % 向量
\newcommand*{\MATRIX}[1]{\ensuremath{\mathsfsl{#1}}}         % 矩阵
\newcommand*{\TENSOR}[1]{\ensuremath{\mathsfsl{#1}}}         % 张量
\newcommand*{\HUA}[1]{\ensuremath{\mathscr{{#1}}}}           % 花体字母
\newcommand*{\SHUANG}[1]{\ensuremath{\mathbb{{#1}}}}        % 双线字母
\numberwithin{equation}{chapter}                             % 公式按章编号

% ========================
% 图表支持模块
% ========================
\RequirePackage{graphicx}                      % 图形支持
\graphicspath{{figures/}{figure/}{pictures/}   % 图片搜索路径
   {picture/}{pic/}{pics/}{image/}{images/}}
\RequirePackage{booktabs}                      % 专业表格

% 图表编号设置
\RequirePackage{amsmath}
\numberwithin{figure}{chapter}                 % 图按章编号
\numberwithin{table}{chapter}                   % 表按章编号

% 非浮动图表标题命令
\makeatletter
\newcommand{\figcaption}{\def\@captype{figure}\caption}
\newcommand{\tabcaption}{\def\@captype{table}\caption}
\makeatother

% 表格内换行解决方案
\newcommand{\tabincell}[2]{\begin{tabular}{@{}#1@{}}#2\end{tabular}}

% ========================
% 目录设置
% ========================
\makeatletter
% 章节目录格式定制
\def\@bfdottedtocline#1#2#3#4#5{%
  \ifnum #1>\c@tocdepth \else
    \vskip \z@ \@plus.2\p@
    {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
     \parindent #2\relax\@afterindenttrue
     \interlinepenalty\@M
     \leavevmode \bfseries
     \@tempdima #3\relax
     \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
     {#4}\normalfont\nobreak
     \leaders\hbox{$\m@th
        \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
        mu$}\hfill
     \nobreak
     \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
     \par}%
  \fi}
\renewcommand*\l@chapter{\@bfdottedtocline{0}{0em}{1.5em}}
\makeatother

% ========================
% 英文目录支持
% ========================
\makeatletter
\newcommand\engcontentsname{Contents}
\newcommand\tableofengcontents{%
  \if@twocolumn
    \@restonecoltrue\onecolumn
  \else
    \@restonecolfalse
  \fi
  \chapter*{\engcontentsname
    \@mkboth{\MakeUppercase\engcontentsname}{\MakeUppercase\engcontentsname}}%
  \@starttoc{toe}  % 英文目录专用文件
  \if@restonecol\twocolumn\fi
}

% 英文目录添加条目命令
\newcommand\addengcontents[2]{%
  \addcontentsline{toe}{#1}{\protect\numberline{\csname the#1\endcsname}#2}}
\makeatother

% 各级标题英文目录快捷命令
\newcommand\echapter[1]{\addengcontents{chapter}{#1}}
\newcommand\esection[1]{\addengcontents{section}{#1}}
\newcommand\esubsection[1]{\addengcontents{subsection}{#1}}
\newcommand\esubsubsection[1]{\addengcontents{subsubsection}{#1}}

% ========================
% 摘要环境定义
% ========================
% 英文摘要环境
\newcommand\enabstractname{ABSTRACT}
\newcommand\enkeywordsname{Key words}
\newcommand\enkeywords[1]{\vspace{1cm}\noindent{\bfseries\zihao{-4}\enkeywordsname: }#1}

\newenvironment{enabstract}{%
  \newpage
  \phantomsection
  \centerline{\vspace{.3cm}\zihao{-3}\bfseries\enabstractname}\vspace{.3cm}
  \addcontentsline{toc}{chapter}{ABSTRACT}          % 添加到中文目录
  \addcontentsline{toe}{chapter}{ABSTRACT}          % 添加到英文目录
  \setlength{\parindent}{1.2em}                     % 段落缩进
  \zihao{-4}                                        % 小四字号
  \setstretch{1.667}                                % 固定行距
}{\clearpage}

% 中文摘要环境
\newcommand\cnabstractname{摘\quad{}要}
\newcommand\cnkeywordsname{关键词}
\newcommand\cnkeywords[1]{\vspace{1cm}\noindent{\bfseries\zihao{-4}\cnkeywordsname: }#1}

\newenvironment{cnabstract}{%
  \newpage
  \phantomsection
  \centerline{\vspace{.3cm}\zihao{-3}\bfseries\cnabstractname}\vspace{.3cm}
  \addcontentsline{toc}{chapter}{摘\quad{}要}        % 添加到中文目录
  \addcontentsline{toe}{chapter}{Chinese Abstract}  % 添加到英文目录
  \setlength{\parindent}{2em}                       % 段落缩进
  \zihao{-4}                                        % 小四字号
  \setstretch{1.667}                                % 固定行距
}{\clearpage}

% ========================
% 自定义结构元素
% ========================
% 符号说明章节
\newcommand{\makesymbolnotation}{%
  \clearpage
  \phantomsection
  \chapter*{符号说明}
  \addcontentsline{toc}{chapter}{符号说明}
  \addcontentsline{toe}{chapter}{Symbol Notation}
}

% 发表论文目录
\newcommand{\makepublications}{%
  \clearpage
  \phantomsection
  \chapter*{攻读学位期间发表的学术论文目录}
  \addcontentsline{toc}{chapter}{攻读学位期间发表的学术论文目录}
  \addcontentsline{toe}{chapter}{Publications}
}

% 论文答辩情况
\newcommand{\makedissertationstatus}{%
  \clearpage
  \phantomsection
  \chapter*{学位论文评阅及答辩情况}
  \addcontentsline{toc}{chapter}{学位论文评阅及答辩情况}
  \addcontentsline{toe}{chapter}{Dissertation Review and Defense}
}

% 外文论文章节
\newcommand{\makeforeignpaper}{%
  \clearpage
  \phantomsection
  \chapter*{外文论文}
  \addcontentsline{toc}{chapter}{外文论文}
  \addcontentsline{toe}{chapter}{Foreign Paper}
}

% ========================
% 中文样式定制
% ========================
\makeatletter
\ifSDU@opt@chsstyle
  % 中文标题名称设置
  \CTEXoptions[
    figurename={图},
    tablename={表},
    bibname={参考文献},
    contentsname={目\quad{}{}录}
  ]
  \CTEXoptions[today=small]  % 日期格式

  % 章节标题格式设置
  % 章标题
  \CTEXsetup[name={第,章}]{chapter}
  \CTEXsetup[number={\chinese{chapter}}]{chapter}
  \CTEXsetup[format={\centering}]{chapter}
  \CTEXsetup[nameformat={\bfseries\zihao{-3}\heiti}]{chapter}
  \CTEXsetup[titleformat={\bfseries\zihao{-3}\heiti}]{chapter}
  \CTEXsetup[aftername={\quad{}}]{chapter}
  \CTEXsetup[beforeskip={24pt}]{chapter}  % 段前24磅
  \CTEXsetup[afterskip={18pt}]{chapter}    % 段后18磅
  
  % 节标题
  \CTEXsetup[format={\bfseries\flushleft\zihao{4}\heiti}]{section}
  \CTEXsetup[beforeskip={24pt}]{section}  % 段前24磅
  \CTEXsetup[afterskip={6pt}]{section}    % 段后6磅
  
  % 小节标题
  \CTEXsetup[format={\bfseries\flushleft\zihao{-4}\heiti}]{subsection}
  \CTEXsetup[beforeskip={12pt}]{subsection}  % 段前12磅
  \CTEXsetup[afterskip={6pt}]{subsection}    % 段后6磅
  
  % 小小节标题
  \CTEXsetup[format={\flushleft\zihao{-4}}]{subsubsection}
  
  % 附录标题
  \CTEXsetup[name={附录~}]{appendix}
  \CTEXsetup[number={\Alph{chapter}}]{appendix}
  
  % 致谢章节
  \newcommand{\acknowledgment}{%
    \clearpage
    \phantomsection
    \chapter*{致\hspace{4ex}谢}
    \addcontentsline{toc}{chapter}{致\quad{}谢}
    \addcontentsline{toe}{chapter}{Acknowledgement}
  }
  
  % 段落首行缩进
  \RequirePackage{indentfirst}
  \setlength{\parindent}{2em}  % 首行缩进2字符
\fi
\makeatletter

% ========================
% 封面与声明页
% ========================
\input{styles/sduthesis-front-cover.def}  % 封面定义
\input{styles/sduthesis-statement.def}    % 声明页定义

% ========================
% 文档生成命令
% ========================
\newcommand{\maketitlepagestatement}{%
  \maketitlepage      % 生成封面
  \thispagestyle{empty}
  ~
  \vfill\eject
  \thispagestyle{empty}
  \makestatement      % 生成声明页
  \vfill\eject
  \thispagestyle{empty}
  ~
  \vfill\eject
  \setcounter{page}{1}
}

% 目录生成命令
\newcommand{\maketableofcontents}{%
  \pagenumbering{roman}       % 罗马数字页码
  \tableofcontents            % 生成目录
  \ifSDU@opt@double
    \cleardoublepage          % 双面打印换页
  \else
    \clearpage                % 单面打印换页
  \fi
  \pagenumbering{arabic}      % 阿拉伯数字页码
  \setcounter{page}{1}        % 重置页码
}

% ========================
% 交叉引用设置
% ========================
\RequirePackage{hyperref}      % 超链接支持
\hypersetup{unicode}           % Unicode支持
\hypersetup{colorlinks=true}   % 彩色链接
\hypersetup{linkcolor=black}   % 链接颜色

% 打印模式下全黑链接
\makeatletter
\ifSDU@opt@print
  \hypersetup{allcolors=black}
\fi
\makeatother

% ========================
% 参考文献格式
% ========================
\RequirePackage{natbib}                  % 参考文献处理
\setlength{\bibsep}{0.5ex}               % 条目间距
\renewcommand{\bibfont}{\zihao{-4}\songti} % 宋体小四号

% ========================
% 文件结束
% ========================
\endinput
