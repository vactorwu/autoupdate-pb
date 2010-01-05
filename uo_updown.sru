$PBExportHeader$uo_updown.sru
$PBExportComments$文件处理
forward
global type uo_updown from nonvisualobject
end type
end forward

global type uo_updown from nonvisualobject
end type
global uo_updown uo_updown

type variables
public:
end variables

forward prototypes
public function boolean uf_zip (string as_path, string as_name)
public function boolean uf_zip_onefile (string as_sname, string as_fname)
public function integer uf_unzip_onefile (string as_zippathfile, string as_file, string as_dpathfile)
public function boolean uf_delfile (string as_pathname)
public function boolean uf_upfile (string as_systemname, string as_filename, string as_version)
public function long uf_unzip (string as_name, string as_path)
public function boolean uf_downfile (ref string as_filename)
end prototypes

public function boolean uf_zip (string as_path, string as_name);/*
uf_unzip
入参：as_path压缩路径
      as_name压缩文件名
出参：true false		
注:同名文件会被替换
*/
int li_ren 
// li_ren>0 返回文件数, li_len = 0 压缩文件中未有文件, li_len < 0 解压失败
li_ren = MyZip_AddDirectory(as_path,as_name)
if li_ren > 0 then
	return true
else
	return false
end if
end function

public function boolean uf_zip_onefile (string as_sname, string as_fname);/*
in: 完整路径的源文件名
    压缩后的文件名
out: 真，假
*/

int li_len
li_len = MyZip_AddFile(as_sname,as_fname)
if li_len > 0 then
	return true
else
	return false
end if
end function

public function integer uf_unzip_onefile (string as_zippathfile, string as_file, string as_dpathfile);/*
in:  as_zippathfile  压缩文件(全路径)
     as_file      需要解包的文件(不包含路径)
	  as_dpathfile 目标文件(全路径)
out: > 0 解压正确
     = 0 压缩文件中未包含as_file
	  < 0 解压失败
*/
int li_len
li_len = MyZip_ExtractFile(as_zippathfile,as_file,as_dpathfile)
return li_len
end function

public function boolean uf_delfile (string as_pathname);boolean lbl_re
lbl_re = FileDelete(as_pathname) //as_pathname 可以带路径
return lbl_re
end function

public function boolean uf_upfile (string as_systemname, string as_filename, string as_version);/*
as_systemname 压缩文件名，不带路径
as_filename   压缩文件名包含路径
as_version    版本号
*/
string ls_name,sql
blob lb_file,lb_read
long ll_len,loops,i,ll_filenum
ll_len = FileLength(as_filename)//取得文件大小
lb_file = blob('')
loops = Ceiling(ll_len/32765)
//ll_FileNum = FileOpen('e:\自动升级程序\update.zip', StreamMode!, Read!, Shared! )
ll_FileNum = FileOpen(as_filename, StreamMode!, Read!, Shared! )
if ll_FileNum < 1 then
	messagebox('错误','打开文件' + as_filename + '出错！' + string(ll_FileNum),stopsign!)
	fileclose(ll_FileNum)
	return false
end if

FOR i = 1 to loops
	FileRead(ll_FileNum, lb_read)
	lb_file = lb_file + lb_read			
NEXT

FileClose(ll_FileNum)
sql = "delete share..sys_verfile where systemname = '" + as_systemname +"'"
execute immediate :sql;
gf_commit()
ls_name = as_systemname + as_version+ '.zip'
insert into share..sys_verfile (systemname,version,filename,filesize) 
values (:as_systemname,:as_version,:ls_name,:ll_len);
gf_commit()
UPDATEBLOB share.dbo.sys_verfile SET filebody = :lb_file
	WHERE systemname = :as_systemname and filename = :ls_name ;
gf_commit()

return true
end function

public function long uf_unzip (string as_name, string as_path);/*
uf_unzip
入参：as_path解压路径
      as_name解压文件名
出参：解压文件数		
*/
int li_ren 
// li_ren>0 返回文件数, li_len = 0 压缩文件中未有文件, li_len < 0 解压失败
li_ren = MyZip_ExtractFileAll(as_name,as_path)
return li_ren
end function

public function boolean uf_downfile (ref string as_filename);string ls_systemName,ls_file,ls_path,ls_pathname,ls_ver
blob lb_file,lb_temp
long ll_filenum,i,loops,ll_len //句柄,循环变量,循环值,文件长度
ls_systemname =gs_systemname
select filename,version into :ls_file,:ls_ver from share..sys_verfile
where  systemname=:ls_systemname;
as_filename  = ls_file
gs_ver = ls_ver
//取当前工作路径
ls_path= gs_dir //取出的路径如："d:\升级程序"
ls_path += '\'
ls_pathname = ls_path + ls_file //路径 + 文件名

if isvalid(w_down) then 
	w_down.st_1.text='正在从服务器读取文件，请稍候……'
end if

//读取压缩文件，放到lb_file里面
SelectBlob filebody Into :lb_file From share.dbo.sys_verfile
Where systemname = :ls_systemname And version = :ls_ver;
if isvalid(w_down) then 
	w_down.st_1.text='读取文件完毕……'
end if
ll_len = len(lb_file)
loops = ceiling(ll_len / 32765)
//下载文件
ll_FileNum = FileOpen(ls_pathname,StreamMode!, Write!, LockReadWrite!, Replace!) //s_path+'\'+
If ll_FileNum < 1 Or IsNull(ll_FileNum) Then
	MessageBox('错误','写入文件'+ls_pathname+'出错！',stopsign!)
	FileClose(ll_FileNum)
	return false 
End If
//如果文件大于32765,判断需要多少次读取
for i = 1 to loops //读取次数
	lb_temp = BlobMid(lb_file,1 + (i - 1)*32765,32765)
	filewrite(ll_filenum,lb_temp)
next
FileClose(ll_FileNum)

return true

end function

on uo_updown.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_updown.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

