$PBExportHeader$w_down.srw
$PBExportComments$下载窗口
forward
global type w_down from window
end type
type cb_close from commandbutton within w_down
end type
type cb_down from commandbutton within w_down
end type
type st_1 from statictext within w_down
end type
end forward

global type w_down from window
integer width = 1755
integer height = 332
boolean titlebar = true
string title = "程序自动更新"
boolean resizable = true
long backcolor = 134217748
string icon = "AppIcon!"
boolean center = true
cb_close cb_close
cb_down cb_down
st_1 st_1
end type
global w_down w_down

type variables
datetime idt_next

end variables

on w_down.create
this.cb_close=create cb_close
this.cb_down=create cb_down
this.st_1=create st_1
this.Control[]={this.cb_close,&
this.cb_down,&
this.st_1}
end on

on w_down.destroy
destroy(this.cb_close)
destroy(this.cb_down)
destroy(this.st_1)
end on

event open;idt_next = datetime(today(),relativetime(time(now()),1))
timer(1)
end event

event timer;datetime ldt_now
ldt_now = datetime(today(),time(now()))
if string(idt_next,'yyyy-mm-dd hh:mm:ss') = string(ldt_now,'yyyy-mm-dd hh:mm:ss') then
	cb_down.triggerevent(clicked!)
	timer(0)
end if

end event

event key;if key=KeyEscape! then
	cb_close.trigger event clicked()
end if

end event

type cb_close from commandbutton within w_down
boolean visible = false
integer x = 1966
integer y = 92
integer width = 233
integer height = 112
integer taborder = 20
integer textsize = -12
integer weight = 700
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
string text = "none"
end type

event clicked;//需要打开的文件
if gs_file <> '' then
	run(gs_file)
	Close(parent)
	Halt Close ;
else
	close(parent)
	halt close;
end if

end event

type cb_down from commandbutton within w_down
boolean visible = false
integer x = 1573
integer y = 88
integer width = 370
integer height = 112
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
string text = "cb_down"
end type

event clicked;luo_updown = create uo_updown
string ls_file,ls_path
int li_len

if luo_updown.uf_downfile(ls_file) then
	st_1.text = '文件已下载，正在解压缩……'
	//取当前工作路径
	ls_path=gs_dir //取出的路径如："d:\升级程序"
	ls_path += '\'
	li_len = luo_updown.uf_unzip(ls_file,ls_path)
	if li_len > 0 then 
		st_1.text = '升级文件数：' + string(li_len) + ',升级成功!'
	elseif li_len = 0 then
		st_1.text = '无法找到升级文件!'
	else
		st_1.text = '软件升级失败!任ESC键退出!'
	end if
else
	st_1.text = '软件升级失败!任(ESC)键退出!'
end if

if luo_updown.uf_delfile(ls_path + ls_file) then
	st_1.text = '升级成功!'
	cb_close.trigger event clicked()
else
	st_1.text = '软件升级失败!任[ESC]键退出!'
end if


end event

type st_1 from statictext within w_down
integer x = 59
integer y = 64
integer width = 1765
integer height = 72
integer textsize = -12
integer weight = 700
fontcharset fontcharset = gb2312charset!
fontpitch fontpitch = variable!
string facename = "宋体"
long textcolor = 255
long backcolor = 134217748
string text = "正在升级，请等待…"
boolean focusrectangle = false
end type

