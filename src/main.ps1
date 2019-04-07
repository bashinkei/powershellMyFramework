. .\common\common.ps1
. .\common\sqlileExecuter.ps1


$cwd = Split-Path $MyInvocation.MyCommand.Path -Parent
$workRoot = Split-Path $cwd -Parent

echo "----------"
echo "test1"
echo "----------"

  $sqlexcuter = Get-SqliteExecuter -dbPath "$($workRoot)\data\db\testdb.sqlite3" -dllPath "$($workRoot)\resource\lib\System.Data.sqlite.dll"
try {
  $test = $sqlexcuter.ExecuteReadable("SELECT * FROM t1")

  $test|Where-Object -FilterScript {$_.name -eq "Ubuntu"}

  foreach($t in $test){
    echo�@"$($t.name), $($t.ostype)"
  }
  
}
finally {
  $sqlexcuter.Close()
}
    

echo "----------"
echo "test2"
echo "----------"



# System.Data.sqlite.dll�̃��[�h
# [void][System.Reflection.Assembly]::LoadFile("$($workRoot)\resource\lib\System.Data.sqlite.dll")

# # SQLite�ւ̐ڑ������SQL�X�e�[�g�����g���s�p��System.Data.SQLite.SQLiteCommand�̐���
# $sqlite = New-Object System.Data.SQLite.SQLiteConnection
# $sqlite.ConnectionString = "Data Source = $($workRoot)\data\db\testdb.sqlite3"
# $sqlcmd = New-Object System.Data.SQLite.SQLiteCommand
# $sqlcmd.Connection = $sqlite
# $sqlite.Open()

# # SQLite�̃o�[�W�����\��
# $sql = "SELECT sqlite_version()"
# $sqlcmd.CommandText = $sql
# $rs =  $sqlcmd.ExecuteReader()
# while ($rs.Read()){
#   $rs[0]
# }

# try {
# # SQLiteCommand�̔j��
# # ��������Ȃ��ƁA�ȉ���SQL���s�ňȉ��̗�O���b�Z�[�W���\�����ꒆ�f����܂��B
# # "DataReader already active on this command"
# $sqlcmd.Dispose()
# $sql = "CREATE TABLE t1 (name, ostype)"
# $sqlcmd.CommandText = $sql
# $ret = $sqlcmd.ExecuteNonQuery()
# }
# finally {
#   echo "final"
# }

# # INSERT���s
# $ins_data = @(@("Windows10","Windows"),@("Ubuntu","Linux"),@("FreeBSD","BSD"))
# $ins_data | % {
#   $name  =$_[0];
#   $ostype=$_[1];
#   $sql="INSERT INTO t1 VALUES('${name}','${ostype}')"
#   $sqlcmd.CommandText = $sql
#   $ret = $sqlcmd.ExecuteNonQuery()
# }

# # SELECT���s����ѕ\��
# $sql = "SELECT * FROM t1"
# $sqlcmd.CommandText = $sql
# $rs =  $sqlcmd.ExecuteReader()
# while ($rs.Read()){
#   Write-Host ("|{0,-12}|{1,-12}|" -f $rs[0], $rs[1])
# }

# # SQLite�̐ؒf
# $sqlcmd.Dispose()
# $sqlite.Close()