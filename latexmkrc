# ============================================================
#  latexmkrc —— XeLaTeX 构建配置
#
#  用法：
#    latexmk            # 编译 thesis.tex
#    latexmk -pvc       # 监视改动并自动重编
#    latexmk -c         # 清理中间文件
#    latexmk -C         # 连 PDF 一起清理
#
#  设计说明：
#    1. 所有产物统一输出到 build/，不单独设 $aux_dir。
#       早期版本把 aux 放到 build/aux/，导致日志与 PDF 分处两地、
#       且自定义 $biber 的 --output-directory 指向不存在目录，
#       biblatex 模式必然失败（已由 tests/matrix.ps1 捕获）。
#    2. 不覆盖 $biber：交给 latexmk 默认处理，biber 日志与 .bbl
#       才能正确落在 out_dir 内。
# ============================================================

$pdf_mode = 5;                                  # xelatex -> xdvipdfmx -> pdf
$xelatex  = 'xelatex -synctex=1 -interaction=nonstopmode %O %S';
$pdflatex = $xelatex;

$out_dir  = 'build';

$clean_ext = 'synctex.gz run.xml';

@default_files = ('thesis.tex');
