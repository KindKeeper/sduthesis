<#
.SYNOPSIS
    sduthesis 一键构建脚本（Windows）。

.DESCRIPTION
    本机通常没有 make，此脚本用 PowerShell 直接驱动 latexmk，
    并自动把 MiKTeX 与 Git 自带 perl 注入 PATH
    （MiKTeX 版 latexmk 是 perl 脚本封装，缺 perl 会直接失败）。

.PARAMETER Clean
    编译前清空 build/，强制全量重编。

.PARAMETER Check
    编译后运行 tests/check_spec.py 做格式合规实测。

.PARAMETER View
    编译后打开 PDF。

.EXAMPLE
    pwsh -File build.ps1
    pwsh -File build.ps1 -Clean -Check
#>
param(
    [switch]$Clean,
    [switch]$Check,
    [switch]$View,
    [string]$Target = 'thesis'
)

$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot
Set-Location $repo

# ---------- 环境前置 ----------
$miktex  = "C:\Users\$env:USERNAME\AppData\Local\Programs\MiKTeX\miktex\bin\x64"
$gitPerl = "C:\Program Files\Git\usr\bin"
foreach ($p in @($gitPerl, $miktex)) {
    if ((Test-Path $p) -and ($env:PATH -notlike "*$p*")) { $env:PATH = "$p;$env:PATH" }
}

$latexmk = $null
if (Test-Path -LiteralPath $miktex) {
    $candidate = Join-Path $miktex 'latexmk.exe'
    if (Test-Path -LiteralPath $candidate) { $latexmk = $candidate }
}
if (-not $latexmk) {
    $c = Get-Command latexmk -ErrorAction SilentlyContinue
    if ($c) { $latexmk = $c.Source } else { throw '找不到 latexmk，请确认 MiKTeX 已安装' }
}
if (-not (Get-Command perl -ErrorAction SilentlyContinue) -and -not (Test-Path (Join-Path $gitPerl 'perl.exe'))) {
    Write-Warning '未找到 perl。MiKTeX 的 latexmk 依赖 perl 脚本引擎，可能需要安装 Strawberry Perl 或 Git for Windows。'
}

# ---------- 环境自检 ----------
# 缺 biber 会直接导致参考文献生成失败；缺字体则会在编译时才报错。
# 这里先一次列清，比让用户去翻几千行日志友好。
Write-Host '环境自检：' -ForegroundColor Cyan
$checks = [ordered]@{}
$checks['latexmk'] = [bool](Get-Command $latexmk -ErrorAction SilentlyContinue)
foreach ($tool in @('xelatex', 'biber', 'kpsewhich')) {
    $checks[$tool] = [bool](Get-Command $tool -ErrorAction SilentlyContinue)
}
if ($checks['kpsewhich']) {
    foreach ($f in @('simsun.ttc', 'simhei.ttf', 'FandolSong-Regular.otf', 'NotoSerifCJKsc-Regular.otf')) {
        $hit = & kpsewhich $f 2>$null
        if ($hit) { $checks["font:$f"] = $true }
    }
}
foreach ($k in $checks.Keys) {
    $mark = if ($checks[$k]) { 'OK  ' } else { 'MISS' }
    $color = if ($checks[$k]) { 'Green' } else { 'Yellow' }
    Write-Host ("  [{0}] {1}" -f $mark, $k) -ForegroundColor $color
}
if (-not $checks['biber']) {
    Write-Warning '未找到 biber：参考文献（GB/T 7714-2015）无法生成。请安装 biber 或改用 TeX Live 完整安装。'
}
Write-Host ''

# ---------- 清理 ----------
if ($Clean -and (Test-Path 'build')) {
    Write-Host '清理 build/ ...' -ForegroundColor Yellow
    Remove-Item 'build' -Recurse -Force
}

# ---------- 编译 ----------
Write-Host "编译 $Target.tex ..." -ForegroundColor Cyan
$sw = [Diagnostics.Stopwatch]::StartNew()
& $latexmk -xelatex -synctex=1 -interaction=nonstopmode $Target
$code = $LASTEXITCODE
$sw.Stop()

$pdf = "build/$Target.pdf"
if ($code -ne 0) {
    Write-Host "编译失败（exit=$code），详见 build/$Target.log" -ForegroundColor Red
    exit $code
}

# ---------- 报告 ----------
$log = "build/$Target.log"
$errs = if (Test-Path $log) { (Select-String -Path $log -Pattern '^!' | Measure-Object).Count } else { -1 }
Write-Host ""
Write-Host "完成：$pdf" -ForegroundColor Green
Write-Host "  耗时   $([math]::Round($sw.Elapsed.TotalSeconds,1)) s"
Write-Host "  错误数 $errs"

if (Get-Command py -ErrorAction SilentlyContinue) {
    $pages = & py -c "import sys; from pypdf import PdfReader; print(len(PdfReader(sys.argv[1]).pages))" $pdf 2>$null
    if ($pages) { Write-Host "  页数   $pages" }
}

# ---------- 合规实测 ----------
if ($Check) {
    $python = if (Get-Command py -ErrorAction SilentlyContinue) { 'py' } else { 'python' }
    Write-Host "`n运行格式合规实测 ..." -ForegroundColor Cyan
    & $python 'tests/check_spec.py' $pdf $log
}

if ($View) { Start-Process $pdf }

