import ace from "brace"
import "brace/theme/dawn"
import "brace/mode/markdown"

var editor = ace.edit("editor");
editor.setTheme("ace/theme/dawn");
editor.getSession().setMode("ace/mode/markdown");
editor.getSession().setUseSoftTabs(true);
editor.renderer.setShowPrintMargin(false);
editor.$blockScrolling = Infinity
