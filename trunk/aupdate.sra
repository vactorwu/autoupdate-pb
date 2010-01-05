$PBExportHeader$aupdate.sra
$PBExportComments$Generated Application Object
forward
global type aupdate from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
uo_updown luo_updown
string gs_systemname, gs_file, gs_ver, gs_dir
end variables

global type aupdate from application
string appname = "aupdate"
end type
global aupdate aupdate

type prototypes
//单个文件的压缩，解压缩
Function integer MyZip_AddFile(string SrcFile, string ZipFile) Library "MyZip.dll"
Function integer MyZip_ExtractFile(string ZipFile,string srcName, string DstName) Library "MyZip.dll"
//一个文件夹的压缩，解压缩
Function integer MyZip_AddDirectory(string SrcPath,string ZipFile) library "MyZip.dll"
Function integer MyZip_ExtractFileAll(string ZipFile,string PathName) library "MyZip.dll"
//设置当前路径
FUNCTION ulong GetCurrentDirectoryA(ulong BufferLen, ref string currentdir) LIBRARY "Kernel32.dll"
Function ulong SetCurrentDirectory(ref string lpPathName) LIBRARY "kernel32.dll" ALIAS FOR "SetCurrentDirectoryA"
end prototypes

type variables

end variables

forward prototypes
public function string uf_get_next_value (ref string as_parm, string as_sep)
public function boolean uf_get_parm (string as_parm, ref string as_sysname, ref string as_filename, ref transaction at_tran)
end prototypes

public function string uf_get_next_value (ref string as_parm, string as_sep);////////////////////////////////////////////////////////////////////////////////
//
// Event: uf_get_next_value()
//
// Access:
//
// Description:
//
// Arguments:
// 	reference	string	as_parm	//截取的源字符串
// 	value    	string	as_sep 	//分隔符
//
// Returns:  string
//
////////////////////////////////////////////////////////////////////////////////
//
// Revision History
//
// Version        Who         Date         Desc
//   1.0          MingXuan.Su     20090804      Initial version
//
////////////////////////////////////////////////////////////////////////////////

String ls_ret_value
Long	ll_pos

ll_pos = pos(as_parm, as_sep, 1)

if ll_pos > 0 then
	ls_ret_value = left(as_parm, ll_pos - 1 )
	as_parm = right(as_parm, len(as_parm) - ( ll_pos - 1 ) - len(as_sep) )
else
	ls_ret_value = as_parm
	as_parm = ''
end if

Return ls_ret_value
end function

public function boolean uf_get_parm (string as_parm, ref string as_sysname, ref string as_filename, ref transaction at_tran);////////////////////////////////////////////////////////////////////////////////
//
// Event: f_get_parm()
//
// Access:
//
// Description:
//
// Arguments:
// 	value    	string     	as_parm    	//传入参数	
// 	reference	string     	as_sysname 	//应用程序名
// 	reference	string     	as_filename	//应用程序exe文件名
// 	reference	transaction	at_tran    	//事物对象
//
// Returns:  (none)
//
////////////////////////////////////////////////////////////////////////////////
//
// Revision History
//
// Version        Who         Date         Desc
//   1.0          MingXuan.Su     20090804      Initial version
//
////////////////////////////////////////////////////////////////////////////////

Boolean lb_ret = True
Long ll_sep //前两位定义分隔符的长度
String ls_sep //从第三位开始到第n位指定使用的分隔符
String ls_tmp

ll_sep = long(left(as_parm,2))
ls_sep = mid(as_parm, 3 ,ll_sep)

ls_tmp = right(as_parm, len(as_parm) - ll_sep - 2 )

at_tran.dbms		= uf_get_next_value(ls_tmp, ls_sep)
at_tran.database	= uf_get_next_value(ls_tmp, ls_sep)
at_tran.userid		= uf_get_next_value(ls_tmp, ls_sep)
at_tran.dbpass		= uf_get_next_value(ls_tmp, ls_sep)
at_tran.logid		= uf_get_next_value(ls_tmp, ls_sep)
at_tran.logpass	= uf_get_next_value(ls_tmp, ls_sep)
at_tran.servername	= uf_get_next_value(ls_tmp, ls_sep)
at_tran.AutoCommit	= False

as_sysname	= uf_get_next_value(ls_tmp, ls_sep)
as_filename	= uf_get_next_value(ls_tmp, ls_sep)

connect using at_tran;

IF at_tran.SQLCode <> 0 THEN
	
	lb_ret = false
	
	if POS(at_tran.sqlerrtext,'DBMS MSS')>0 then
		Messagebox('网络数据库连接出错','您没有安装Microsoft SQL Server客户端组件!'+&
		'~r~n~r~n请您安装,否则无法连接网络数据库!',exclamation!)
	else
		Messagebox('网络数据库连接出错','错误信息:'+at_tran.sqlerrtext,exclamation! )
	end if
end if

Return lb_ret
end function

on aupdate.create
appname="aupdate"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on aupdate.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;///////////////////////////////////////////////////
//  感谢网上自动升级程序原作者的思路帮助         //
//  感谢公司sumx提供的热情帮助                   //
///////////////////////////////////////////////////
string ls_parm
ls_parm = upper(CommandParm( )) //代入参数，取参数值 "参数类型"

long l_len
gs_dir=space(100)
l_len=len(gs_dir)
GetCurrentDirectoryA(l_len,ref gs_dir)

if left(ls_parm,10) = '-DOWN PARM' then 
	//不使用配置文件，使用传递的参数
	if not uf_get_parm( right(ls_parm, len(ls_parm) - 10), gs_systemname, gs_file, sqlca) then
		return
	end if
	ls_parm = '-DOWN'
end if

choose case ls_parm 
//	case '-AF' //单个文件压缩
//		//暂时没有用，可用uo_updown 里面uf_zip_onefile
//	case '-AD' //压缩一个目录
//		//暂时没有用，可用uo_updown 里面uf_zip
//	case '-EF' //单个文件解压
//		//暂时没有用，可用uo_updown 里面uf_unzip_onefile
//	case '-EA' //解压到一个目录
//		//暂时没有用，可用uo_updown 里面uf_unzip
	case '-UP' //上传一个压缩文件
		open(w_connect)
//		if f_connect() < 0  then //连接数据库
//			return
//		end if
//		open(w_up)
	case '-DOWN' //下载一个压缩文件
		open(w_down)
end choose
end event

