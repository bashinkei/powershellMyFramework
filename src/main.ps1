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
    echo　"$($t.name), $($t.ostype)"
  }
  
}
finally {
  $sqlexcuter.Close()
}
    

echo "----------"
echo "test2"
echo "----------"



# System.Data.sqlite.dllのロード
# [void][System.Reflection.Assembly]::LoadFile("$($workRoot)\resource\lib\System.Data.sqlite.dll")

# # SQLiteへの接続およびSQLステートメント発行用のSystem.Data.SQLite.SQLiteCommandの生成
# $sqlite = New-Object System.Data.SQLite.SQLiteConnection
# $sqlite.ConnectionString = "Data Source = $($workRoot)\data\db\testdb.sqlite3"
# $sqlcmd = New-Object System.Data.SQLite.SQLiteCommand
# $sqlcmd.Connection = $sqlite
# $sqlite.Open()

# # SQLiteのバージョン表示
# $sql = "SELECT sqlite_version()"
# $sqlcmd.CommandText = $sql
# $rs =  $sqlcmd.ExecuteReader()
# while ($rs.Read()){
#   $rs[0]
# }

# try {
# # SQLiteCommandの破棄
# # これをしないと、以下のSQL発行で以下の例外メッセージが表示され中断されます。
# # "DataReader already active on this command"
# $sqlcmd.Dispose()
# $sql = "CREATE TABLE t1 (name, ostype)"
# $sqlcmd.CommandText = $sql
# $ret = $sqlcmd.ExecuteNonQuery()
# }
# finally {
#   echo "final"
# }

# # INSERT実行
# $ins_data = @(@("Windows10","Windows"),@("Ubuntu","Linux"),@("FreeBSD","BSD"))
# $ins_data | % {
#   $name  =$_[0];
#   $ostype=$_[1];
#   $sql="INSERT INTO t1 VALUES('${name}','${ostype}')"
#   $sqlcmd.CommandText = $sql
#   $ret = $sqlcmd.ExecuteNonQuery()
# }

# # SELECT実行および表示
# $sql = "SELECT * FROM t1"
# $sqlcmd.CommandText = $sql
# $rs =  $sqlcmd.ExecuteReader()
# while ($rs.Read()){
#   Write-Host ("|{0,-12}|{1,-12}|" -f $rs[0], $rs[1])
# }

# # SQLiteの切断
# $sqlcmd.Dispose()
# $sqlite.Close()