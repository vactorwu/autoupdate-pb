$PBExportHeader$w_connect.srw
forward
global type w_connect from window
end type
type ddlb_server from dropdownlistbox within w_connect
end type
type cb_2 from commandbutton within w_connect
end type
type cb_1 from commandbutton within w_connect
end type
type sle_logpass from singlelineedit within w_connect
end type
type st_4 from statictext within w_connect
end type
type st_3 from statictext within w_connect
end type
type sle_logid from singlelineedit within w_connect
end type
type sle_database from singlelineedit within w_connect
end type
type st_2 from statictext within w_connect
end type
type st_1 from statictext within w_connect
end type
type gb_1 from groupbox within w_connect
end type
end forward

global type w_connect from window
integer width = 2112
integer height = 1204
boolean titlebar = true
string title = "Connect Database"
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
ddlb_server ddlb_server
cb_2 cb_2
cb_1 cb_1
sle_logpass sle_logpass
st_4 st_4
st_3 st_3
sle_logid sle_logid
sle_database sle_database
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_connect w_connect

type variables
String is_ininame = 'qcyd_sys.ini'//配置文件名
String is_section
end variables

on w_connect.create
this.ddlb_server=create ddlb_server
this.cb_2=create cb_2
this.cb_1=create cb_1
this.sle_logpass=create sle_logpass
this.st_4=create st_4
this.st_3=create st_3
this.sle_logid=create sle_logid
this.sle_database=create sle_database
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
this.Control[]={this.ddlb_server,&
this.cb_2,&
this.cb_1,&
this.sle_logpass,&
this.st_4,&
this.st_3,&
this.sle_logid,&
this.sle_database,&
this.st_2,&
this.st_1,&
this.gb_1}
end on

on w_connect.destroy
destroy(this.ddlb_server)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.sle_logpass)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.sle_logid)
destroy(this.sle_database)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;is_section = profilestring(is_ininame,'Application','DatabaseName','')

gs_systemname =profilestring(is_ininame,'Application','Sysname','')
gs_file =profilestring(is_ininame,'Application','filename','')

//连接数据库
sqlca.dbms		=profilestring(is_ininame,is_section,"dbms"," ")
sqlca.database	=profilestring(is_ininame,is_section,"database"," ")
sqlca.userid	=profilestring(is_ininame,is_section,"userid"," ")
sqlca.dbpass	=profilestring(is_ininame,is_section,"dbpass"," ")
sqlca.logid		=profilestring(is_ininame,is_section,"logid"," ")
sqlca.logpass	=profilestring(is_ininame,is_section,"logpass"," ")
sqlca.servername	=profilestring(is_ininame,is_section,"servername"," ")
SQLCA.AutoCommit	= False

String	ls_ser[]
Long		ll_i = 1

ls_ser[1] = profilestring(is_ininame,is_section,"server1"," ")
ls_ser[2] = profilestring(is_ininame,is_section,"server2"," ")
ls_ser[3] = profilestring(is_ininame,is_section,"server3"," ")

For ll_i = 1 To 3
	ls_ser[ll_i] = trim(ls_ser[ll_i])
	If ls_ser[ll_i] <> '' Then
		ddlb_server.insertitem( ls_ser[ll_i], ddlb_server.TotalItems() + 1 )
	End If
Next

ddlb_server.text	= profilestring(is_ininame,is_section,"servername"," ")
sle_database.text	= profilestring(is_ininame,is_section,"database"," ")
sle_logid.text	= profilestring(is_ininame,is_section,"logid"," ")
sle_logpass.text	= profilestring(is_ininame,is_section,"logpass"," ")


end event

type ddlb_server from dropdownlistbox within w_connect
integer x = 608
integer y = 172
integer width = 1289
integer height = 476
integer taborder = 30
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_connect
integer x = 1070
integer y = 924
integer width = 713
integer height = 132
integer taborder = 40
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel(&X)"
end type

event clicked;close(parent)
end event

type cb_1 from commandbutton within w_connect
integer x = 219
integer y = 924
integer width = 713
integer height = 132
integer taborder = 20
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK(&Q)"
boolean default = true
end type

event clicked;//连接数据库
sqlca.logid		= trim( sle_logid.text )
sqlca.logpass	= trim( sle_logpass.text )
sqlca.servername	= trim( ddlb_server.text )

Connect Using sqlca;

If SQLCA.SQLCode <> 0 Then
	If POS(SQLCA.sqlerrtext,'DBMS MSS')>0 Then
		Messagebox('网络数据库连接出错','您没有安装Microsoft SQL Server客户端组件!'+&
		'~r~n~r~n请您安装,否则无法连接网络数据库!',exclamation!)
		Return
	Else
		Messagebox('网络数据库连接出错','错误信息:'+SQLCA.sqlerrtext,exclamation! )
		sle_logpass.setfocus()
		sle_logpass.selecttext(1,len(sle_logpass.text))
		Return
	End If
End If

setprofilestring( is_ininame,is_section,"servername", sqlca.servername )

open(w_up)

close(parent)
end event

type sle_logpass from singlelineedit within w_connect
integer x = 608
integer y = 672
integer width = 1289
integer height = 108
integer taborder = 10
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean password = true
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_connect
integer x = 96
integer y = 688
integer width = 466
integer height = 72
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "logpass:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_connect
integer x = 96
integer y = 516
integer width = 466
integer height = 72
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Logid:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_logid from singlelineedit within w_connect
integer x = 608
integer y = 500
integer width = 1289
integer height = 108
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_database from singlelineedit within w_connect
integer x = 608
integer y = 328
integer width = 1289
integer height = 108
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_connect
integer x = 96
integer y = 344
integer width = 466
integer height = 72
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Database:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_connect
integer x = 96
integer y = 180
integer width = 466
integer height = 72
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Servername:"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_connect
integer x = 37
integer y = 24
integer width = 1979
integer height = 848
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

