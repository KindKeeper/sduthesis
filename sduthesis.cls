% ============================================
% sduthesis.cls - 山东大学学位论文模板（精简版）
% 版本: 3.0.1 (optimized)
% 编译引擎: XeLaTeX
% ============================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sduthesis}[2025/01/01 v3.0.1 SDU Thesis Minimal]

% ============================================
% 选项处理
% ============================================
\newif\if@sdublindreview
\@sdublindreviewfalse
\newif\if@sdumaster
\@sdumastertrue
\newif\if@sducolorcover
\@sducolorcovertrue
\newif\if@sdubiblatex
\@sdubiblatexfalse

\DeclareOption{blindreview}{\@sdublindreviewtrue}
\DeclareOption{master}{\@sdumastertrue}
\DeclareOption{doctor}{\@sdumasterfalse}
\DeclareOption{colorcover}{\@sducolorcovertrue}
\DeclareOption{bwcover}{\@sducolorcoverfalse}
\DeclareOption{biblatex}{\@sdubiblatextrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax

% 加载基础文档类
\LoadClass[a4paper,12pt]{book}

% ============================================
% 必需宏包
% ============================================
\RequirePackage[UTF8]{ctex}
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{amsmath,amsfonts,amssymb}
\RequirePackage{hyperref}
\RequirePackage{fancyhdr}
\RequirePackage{setspace}
\RequirePackage{caption}
\RequirePackage{titlesec}
\RequirePackage{iftex}

% 可选：biblatex支持
\if@sdubiblatex
  \RequirePackage[backend=biber,style=gb7714-2015,gbpub=false]{biblatex}
\fi

% ============================================
% 字体设置（带自动回退）
% ============================================
\ifXeTeX
  % 检测并设置西文字体
  \IfFontExistsTF{Times New Roman}{
    \setmainfont{Times New Roman}
  }{
    \setmainfont{TeX Gyre Termes}
  }
  
  % 检测并设置中文字体（Windows优先）
  \IfFontExistsTF{SimSun}{
    \setCJKmainfont{SimSun}[BoldFont=SimHei]
    \setCJKsansfont{SimHei}
    \setCJKmonofont{FangSong}
  }{
    \IfFontExistsTF{FandolSong}{
      \setCJKmainfont{FandolSong}[BoldFont=FandolSong-Bold]
      \setCJKsansfont{FandolHei}
      \setCJKmonofont{FandolFang}
    }{
      % macOS字体
      \IfFontExistsTF{Songti SC}{
        \setCJKmainfont{Songti SC}[BoldFont=Heiti SC]
        \setCJKsansfont{Heiti SC}
        \setCJKmonofont{STFangsong}
      }{}
    }
  }
\fi

% ============================================
% 页面设置
% ============================================
\geometry{
  paper      = a4paper,
  left       = 2.5cm,
  right      = 2.5cm,
  top        = 2.8cm,
  bottom     = 2.5cm,
  headheight = 15pt,
}

\setstretch{1.667}

% ============================================
% 超链接设置
% ============================================
\hypersetup{
  unicode      = true,
  colorlinks   = true,
  linkcolor    = black,
  citecolor    = black,
  urlcolor     = black,
}

% ============================================
% 章节格式 - 使用 titlesec
% ============================================

% 保存原始章节格式命令
\let\old@chapter\chapter

% 正文章节格式
\titleformat{\chapter}[display]
  {\centering\bfseries\zihao{-3}\heiti}
  {第\chinese{chapter}章}
  {0.5em}
  {}
\titlespacing{\chapter}{0pt}{24pt}{18pt}

% 节标题
\titleformat{\section}
  {\bfseries\zihao{4}\heiti}
  {\thesection}
  {0.5em}
  {}
\titlespacing{\section}{0pt}{24pt}{6pt}

% 小节标题
\titleformat{\subsection}
  {\bfseries\zihao{-4}\heiti}
  {\thesubsection}
  {0.5em}
  {}
\titlespacing{\subsection}{0pt}{12pt}{6pt}

% 小小节标题
\titleformat{\subsubsection}
  {\zihao{-4}}
  {\thesubsubsection}
  {0.5em}
  {}

% 标题名称
\renewcommand{\contentsname}{目\quad 录}
\renewcommand{\figurename}{图}
\renewcommand{\tablename}{表}
\renewcommand{\bibname}{参考文献}

% ============================================
% 附录格式（不覆盖正文章节）
% ============================================
\let\old@appendix\appendix
\renewcommand{\appendix}{
  \old@appendix
  % 重新定义附录章节格式
  \titleformat{\chapter}[display]
    {\centering\bfseries\zihao{-3}\heiti}
    {附录\Alph{chapter}}
    {0.5em}
    {}
  \titlespacing{\chapter}{0pt}{24pt}{18pt}
}

% ============================================
% 页眉页脚
% ============================================
\pagestyle{fancy}
\fancyhf{}
\fancyhead[C]{\zihao{5}山东大学博（硕）士学位论文}
\fancyfoot[C]{\zihao{5}\thepage}
\renewcommand{\headrulewidth}{0.4pt}

\fancypagestyle{plain}{
  \fancyhf{}
  \fancyfoot[C]{\zihao{5}\thepage}
}

% ============================================
% 用户配置接口
% ============================================
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=sdusetup,prefix=sdusetup@}
\DeclareStringOption[]{title}
\DeclareStringOption[]{titleen}
\DeclareStringOption[]{author}
\DeclareStringOption[]{studentid}
\DeclareStringOption[]{supervisor}
\DeclareStringOption[]{college}
\DeclareStringOption[]{major}
\DeclareStringOption[\today]{date}
\DeclareStringOption[TP391]{fenlei}
\DeclareStringOption[公开]{miji}

\newcommand{\sdusetup}[1]{\setkeys{sdusetup}{#1}}

% 盲审处理
\newcommand{\blind}[1]{\if@sdublindreview ***\else #1\fi}

% ============================================
% 封面生成
% ============================================
\renewcommand{\maketitle}{
  \thispagestyle{empty}
  \begin{center}
    \vspace*{1cm}
    
    {\zihao{-4}
      \makebox[3cm][s]{分类号：\sdusetup@fenlei}
      \hfill
      \makebox[3cm][s]{单位代码：10422}
      \par
      \makebox[3cm][s]{密级：\sdusetup@miji}
      \hfill
      \makebox[3cm][s]{学号：\blind{\sdusetup@studentid}}
      \par
    }
    
    \vspace{2cm}
    
    \if@sducolorcover
      \includegraphics[width=8cm]{figures/SDUWordsColor.pdf}
    \else
      \includegraphics[width=8cm]{figures/SDUWords.pdf}
    \fi
    
    \vspace{1cm}
    
    {\zihao{1}\heiti
      \if@sdumaster 硕士学位论文 \else 博士学位论文 \fi
      \par
    }
    
    \vspace{2cm}
    
    {\zihao{-2}\bfseries \sdusetup@title \par}
    \vspace{0.5cm}
    {\zihao{3} \sdusetup@titleen \par}
    
    \vfill
    
    {\zihao{3}
      \begin{tabular}{rl}
        作\quad 者\quad 姓\quad 名： & \blind{\sdusetup@author} \\
        培\quad 养\quad 单\quad 位： & \sdusetup@college \\
        专\quad 业\quad 名\quad 称： & \sdusetup@major \\
        指\quad 导\quad 教\quad 师： & \blind{\sdusetup@supervisor} \\
      \end{tabular}
      \par
    }
    
    \vspace{2cm}
    
    {\zihao{3} \sdusetup@date \par}
    
  \end{center}
  \clearpage
}

% ============================================
% 原创性声明
% ============================================
\newcommand{\makestatement}{
  \thispagestyle{empty}
  \vspace*{2cm}
  
  {\zihao{3}\bfseries\centering 原\quad 创\quad 性\quad 声\quad 明 \par}
  \vspace{1cm}
  
  {\zihao{4}
    本人郑重声明：所呈交的学位论文，是本人在导师指导下，独立进行研究所取得的成果。
    除文中已经注明引用的内容外，本论文不包含任何其他个人或集体已经发表或撰写过的科研成果。
    对本文的研究作出重要贡献的个人和集体，均已在文中以明确方式标明。
    本人完全意识到本声明的法律责任由本人承担。
    \par
  }
  
  \vspace{2cm}
  {\zihao{4} 论文作者签名：\hrulefill \quad 日期：\hrulefill \par}
  
  \vspace{3cm}
  
  {\zihao{3}\bfseries\centering 关于学位论文使用授权的声明 \par}
  \vspace{1cm}
  
  {\zihao{4}
    本人完全了解山东大学有关保留、使用学位论文的规定，同意学校保留或向国家有关部门
    或机构送交论文的复印件和电子版，允许论文被查阅和借阅；本人授权山东大学可以将
    本学位论文的全部或部分内容编入有关数据库进行检索，可以采用影印、缩印或其他复制
    手段保存论文和汇编本学位论文。
    \par
  }
  
  \vspace{0.5cm}
  {\zihao{4}（保密论文在解密后应遵守此规定）\par}
  
  \vspace{2cm}
  {\zihao{4}
    论文作者签名：\hrulefill \quad 导师签名：\hrulefill \quad 日期：\hrulefill
    \par
  }
  
  \clearpage
}

% ============================================
% 摘要环境
% ============================================
\newenvironment{cnabstract}{
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{摘\quad 要}
  \centerline{\zihao{-3}\bfseries 摘\quad 要}
  \vspace{0.5cm}
  \zihao{-4}
  \setlength{\parindent}{2em}
}{\clearpage}

\newenvironment{enabstract}{
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{ABSTRACT}
  \centerline{\zihao{-3}\bfseries ABSTRACT}
  \vspace{0.5cm}
  \zihao{-4}
  \setlength{\parindent}{1.5em}
}{\clearpage}

\newcommand{\keywords}[1]{\vspace{1cm}\noindent\textbf{关键词：}#1 \par}
\newcommand{\keywordsen}[1]{\vspace{1cm}\noindent\textbf{Key Words: }#1 \par}

% ============================================
% 致谢
% ============================================
\newcommand{\acknowledgement}{
  \clearpage
  \phantomsection
  \chapter*{致\quad 谢}
  \addcontentsline{toc}{chapter}{致\quad 谢}
}

% ============================================
% 图表编号格式
% ============================================
\numberwithin{figure}{chapter}
\numberwithin{table}{chapter}
\numberwithin{equation}{chapter}

\captionsetup{font=small,labelsep=space}

% ============================================
% 辅助命令
% ============================================
\newcommand{\tabincell}[2]{\begin{tabular}{@{}#1@{}}#2\end{tabular}}

\newcommand{\me}{\mathrm{e}}
\newcommand{\mi}{\mathrm{i}}
\newcommand{\dif}{\,\mathrm{d}}
\newcommand{\VEC}[1]{\boldsymbol{#1}}
\newcommand{\MATRIX}[1]{\mathsf{#1}}
\newcommand{\TENSOR}[1]{\mathcal{#1}}

% ============================================
% 文件结束
% ============================================
\endinput
