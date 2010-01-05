$PBExportHeader$w_up.srw
$PBExportComments$上传文件
forward
global type w_up from window
end type
type st_3 from statictext within w_up
end type
type sle_sys from singlelineedit within w_up
end type
type cb_3 from commandbutton within w_up
end type
type cb_2 from commandbutton within w_up
end type
type cb_1 from commandbutton within w_up
end type
type sle_ver from singlelineedit within w_up
end type
type sle_file from singlelineedit within w_up
end type
type st_2 from statictext within w_up
end type
type st_1 from statictext within w_up
end type
type gb_1 from groupbox within w_up
end type
end forward

global type w_up from window
integer width = 1755
integer height = 896
boolean titlebar = true
string title = "上传文件"
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_3 st_3
sle_sys sle_sys
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
sle_ver sle_ver
sle_file sle_file
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_up w_up

type variables
string is_pathname,is_filename


end variables

on w_up.create
this.st_3=create st_3
this.sle_sys=create sle_sys
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.sle_ver=create sle_ver
this.sle_file=create sle_file
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.st_3,&
this.sle_sys,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.sle_ver,&
this.sle_file,&
this.st_2,&
this.st_1,&
this.gb_1}
end on

on w_up.destroy
destroy(this.st_3)
destroy(this.sle_sys)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.sle_ver)
destroy(this.sle_file)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

type st_3 from statictext within w_up
integer x = 151
integer y = 436
integer width = 288
integer height = 72
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "sysname"
boolean focusrectangle = false
end type

type sle_sys from singlelineedit within w_up
integer x = 462
integer y = 424
integer width = 1079
integer height = 96
integer taborder = 30
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event constructor;this.text=gs_systemname
end event

type cb_3 from commandbutton within w_up
integer x = 1093
integer y = 620
integer width = 489
integer height = 128
integer taborder = 40
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "关闭(&X)"
end type

event clicked;halt;
end event

type cb_2 from commandbutton within w_up
integer x = 608
integer y = 620
integer width = 489
integer height = 128
integer taborder = 30
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "上传(&U)"
end type

event clicked;string ls_ver
this.enabled = false
cb_1.enabled = false
cb_3.enabled = false
if sle_ver.text = '' then
	Messagebox('错误','请输入版本号!')
	sle_ver.setfocus()
	return
end if

if sle_file.text = '' then
	Messagebox('错误','请选择要上传的文件!')
	sle_file.setfocus()
	return
end if

ls_ver = trim(sle_ver.text)

//更新应用程序名
gs_systemname = trim(sle_sys.text)

luo_updown = create uo_updown

if luo_updown.uf_upfile(gs_systemname,is_pathname,ls_ver) then
	messagebox('提示','上传成功!')
	cb_1.enabled = true
	cb_3.enabled = true
else
	messagebox('提示','上传失败!',exclamation!)
	cb_1.enabled = true
	cb_3.enabled = true
end if
end event

type cb_1 from commandbutton within w_up
integer x = 123
integer y = 620
integer width = 489
integer height = 128
integer taborder = 20
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "打开(&O)"
end type

event clicked;string ls_pathname, ls_filename
integer li_return

li_return = GetFileOpenName("选择文件名", &
	+ ls_pathname, ls_filename, "*", &
	"ZIP文件(*.zip),*.zip")

if li_return<>1 then return
cb_2.enabled = true
//ls_pathname = ls_pathname + ls_filename

is_pathname = ls_pathname
is_filename = ls_filename
sle_file.text = ls_filename
sle_ver.text =left(right(is_filename,12),8)
sle_sys.text =left(is_filename,4)
 

end event

type sle_ver from singlelineedit within w_up
integer x = 462
integer y = 280
integer width = 1079
integer height = 96
integer taborder = 20
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_file from singlelineedit within w_up
integer x = 462
integer y = 144
integer width = 1079
integer height = 96
integer taborder = 10
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_up
integer x = 146
integer y = 284
integer width = 279
integer height = 72
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "版本号:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_up
integer x = 146
integer y = 152
integer width = 279
integer height = 72
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "文件名:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_up
integer x = 46
integer y = 16
integer width = 1605
integer height = 568
integer taborder = 10
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

