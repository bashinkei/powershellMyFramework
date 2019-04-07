function Get-SqliteExecuter
{
    Param(
        [Parameter(Mandatory)]
        [String] $dbPath,

        [Parameter(Mandatory)]
        [String] $dllPath
    )

    $exeObj = New-Object psobject 

    # System.Data.sqlite.dllのロード
    [void][System.Reflection.Assembly]::LoadFile("$($dllPath)")
    
    #connectionの作成
    $sqlite = New-Object System.Data.SQLite.SQLiteConnection
    $sqlite.ConnectionString = "Data Source = $($dbPath)"
    $sqlite.Open()

    #メンバ変数の追加
    $exeObj | Add-Member -MemberType NoteProperty -Name sqlite -Value $sqlite


    #メソッドの追加
    #select実行用スクリプト
    $ExecuteReadable = {
        Param( 
            [Parameter(Mandatory)] [string] $sql
        )
        
        $sqlcmd = New-Object System.Data.SQLite.SQLiteCommand
        $sqlcmd.Connection = $this.sqlite

        $sqlcmd.CommandText = $sql
        $rs =  $sqlcmd.ExecuteReader()

        $selectObjects = @()

        while($rs.Read()){
            $selectObject = New-Object psobject 
            for($i=0;$i -lt $rs.FieldCount;$i++){
                $selectObject | Add-Member -MemberType NoteProperty -Name $rs.GetName($i) -Value $rs.GetValue($i)
            }
            $selectObjects += $selectObject
        }

        $sqlcmd.Dispose()


        return $selectObjects
    }
    $exeObj | Add-Member -MemberType ScriptMethod -Name ExecuteReadable -Value $ExecuteReadable 

    #終了用スクリプト
    $close = {
        $this.sqlite.Close()
    }
    $exeObj | Add-Member -MemberType ScriptMethod -Name close -Value $close 


    return $exeObj 
}
