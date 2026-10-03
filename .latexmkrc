#!/usr/bin/env perl

$latex = 'uplatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

$bibtex     = 'upbibtex %O %S';
$biber      = 'biber --bblencoding=utf8 -u -U --output_safechars %O %S';
$makeindex  = 'upmendex %O -o %D %S';
$dvipdf     = 'dvipdfmx %O -o %D %S';
$pdf_mode   = 3;
$max_repeat = 5;

$pvc_view_file_via_temporary = 0;
$pdf_previewer = 'wsl-open %S';
