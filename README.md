# sduthesis - 山东大学研究生学位论文 LaTeX 模板

一个优雅、规范、易于使用的 LaTeX 模板，用于撰写山东大学硕士与博士学位论文。

## 模板参照

- [关于印发《山东大学研究生学位论文撰写指南》的通知](http://www.me.sdu.edu.cn/info/1033/1838.htm)，山大研字〔2022〕1号，2022年1月5日
- [2024版学位论文封面（扉页）](https://www.grad.sdu.edu.cn/info/1138/20664.htm)，2025年4月3日发布

## 模板特点

本模板参照山东大学研究生学位论文撰写指南》完成，同时针对理工科学位做了调整，满足毕业论文的撰写要求。

在之前版本基础上修复 bug 若干：

- 修改论文封面。
- 论文封面增加新的字段。
- 增加英文摘要、中英文关键字。
- 修复摘要 `minipage` 无法换页的问题。
- 按要求修改页码显示方式。
- 单页只能有两张图片的 bug。
- 增加致谢、参考文献等章节。
- 设置某些特定章节在目录中不参与编号。
- 修复双页打印问题。
- 使用 `tabincell` 完成表格内换行，多行表格可垂直居中。
- 使用 `wrapfigure` 并添加 `wrapfig` 包。
- 修复复制时英文字符映射为乱码的问题。
- 修复目录页为 `minipage` 导致目录显示不全的问题。
- 从目录中移除目录项 `nottoc` 参数。
- 增加英文目录。
- 修复目录页 `section` 等字段不显示点号的问题。
- 去掉正文前 `section` 前的双 S 符号。
- 增加定理定义等命令定义。
- ……

特别感谢[ChenMeng0518](https://github.com/ChenMeng0518/sduthesis)同学提供学士学位论文模板。

## 编译环境

请使用 CTeX 套装进行编译，需要 `xelatex` 和 `pdflatex` 命令支持。

如果你的 CTeX 套装中 ctex 包为 1.02c 或更早的版本，请将`SDUthesistemplate.tex`当中下面这句话取消注释：

```latex
% \expandafter\def\csname CTEX@spaceChar\endcsname{\hspace{1em}}
```

## 代码结构

- `sduthesis-front-cover.def`： 封面。
- `sduthesis-statement.def`： 原创性声明。
- `SDUthesistemplate.tex`： 主文件，你的论文结构在此文件当中。
- `sduthesis.cls`： 论文样式文件。
- `fonts/`： 字体文件路径(用于自动加载字体)。
- `figures/`： 图片存放路径，你也可以创建`figure`/`pictures`/`picture`/`pic`/`image`等路径。
- `contents/`： 论文所在路径。其中`usersettings.tex` 为整个项目的设置。

## 怎样编译

文档使用 XeLaTeX 进行编译。这要求所有参与编译的文档必须使用 UTF8 编码格式，因此建议你新建的任何参与编译的 `.tex` 文件都必须使用 UTF-8 编码。

- 运行 `run.bat` 即可编译生成 pdf 文件。
- 在运行失败时使用 `clean.bat` 清理项目。
- 运行 `run_open.bat` 在编译完成之后打开 pdf 文件。

### 打印

将编译生成的 pdf 文件直接打印即可，注意要求打印社使用双面打印。

## 版权与许可

本项目 (`sduthesis`) 是基于 [cnDelbert/SDU_thesis_template_for_postgraduate](https://github.com/cnDelbert/SDU_thesis_template_for_postgraduate) 的二次开发版本。

- **原始项目**
  - 作者：cnDelbert
  - 许可：署名-非商业性使用 3.0 中国大陆 (CC BY-NC 3.0 CN)

- **本衍生项目**
  - 作者：KindKeeper
  - 许可：署名-非商业性使用 4.0 国际 (CC BY-NC 4.0)

### 使用条件

1. **署名**：必须注明原始作者 (cnDelbert) 和本作品作者 (KindKeeper)
2. **非商业**：不得用于商业用途
3. **相同方式共享**：基于本项目的衍生作品需使用相同许可协议

[](https://creativecommons.org/licenses/by-nc/4.0/deed.zh)