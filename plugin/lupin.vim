scriptencoding utf-8

" lupin-title.el
"     https://github.com/mugijiru/lupin-title

if !has('python')
  finish
endif

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:script_dir = expand('<sfile>:p:h')

function! s:lupin()
  python << EOT
import wave
import ossaudiodev

def lupin_vim_play_wave(f):
    # http://d.hatena.ne.jp/yatt/20090913/1252850731
    wav = wave.open(f, 'r')
    dev = ossaudiodev.open('w')
    fmt = [None, ossaudiodev.AFMT_U8, ossaudiodev.AFMT_S16_LE][wav.getsampwidth()]
    dev.setparameters(fmt, wav.getnchannels(), wav.getframerate())
    dev.write(wav.readframes(wav.getnframes()))
EOT
  let wave1 = s:script_dir . '/lupin1.wav'
  let wave2 = s:script_dir . '/lupin2.wav'
  let save_statusline = &statusline
  let s = input('title? ')
  let l = split(s, '.\zs')
  for c in l
    let &statusline = c
    redrawstatus
    execute 'python lupin_vim_play_wave(''' . wave1 . ''')'
  endfor
  let &statusline = s
  redrawstatus
  execute 'python lupin_vim_play_wave(''' . wave2 . ''')'
  let &statusline = save_statusline
endfunction

command Lupin call <SID>lupin()

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions

