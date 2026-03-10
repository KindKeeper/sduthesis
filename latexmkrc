# ============================================
# latexmkrc - LaTeX编译配置
# 使用: latexmk (编译) / latexmk -c (清理)
# ============================================

# 使用 XeLaTeX
$pdf_mode = 5;

# 输出目录
$out_dir = 'build';
$aux_dir = 'build/aux';

# XeLaTeX 参数
$xelatex = 'xelatex -synctex=1 -interaction=nonstopmode %O %S';

# Biber 处理参考文献
$biber = 'biber %O --output-directory %B %S';

# 编译链: xelatex -> biber -> xelatex -> xelatex
$pdflatex = $xelatex;

# 文件扩展名清理
$clean_ext = 'synctex.gz run.xml';

# 预览设置（latexmk -pvc）
$preview_mode = 0;
$pdf_previewer = 'start';

# 静默模式（减少输出）
$quiet = 0;

# 依赖检查
@default_files = ('thesis.tex');
