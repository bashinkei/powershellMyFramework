$source = "public enum LogLevel{Error=0, Warn=1, Info=2, Debug=3}"
Add-Type -Language CSharp -TypeDefinition $source 

function Get-Logger
{
    Param(
        [Parameter(Mandatory)]
        [String] $logFilePath,

        [Parameter(Mandatory)]
        [LogLevel] $logLevel,

        [Switch] $NoDisplay

    )

    $loggerObj = New-Object psobject 

    #メンバ変数の追加
    $loggerObj | Add-Member -MemberType NoteProperty -Name logFilePath -Value $logFilePath
    $loggerObj | Add-Member -MemberType NoteProperty -Name logLevel -Value $logLevel

    #ログフォーマット
    $format = "{0} [{1}] {2}"

    #メソッドの追加
    #画面表示用スクリプト
    $outHostScript = {
        Param( 
            [Parameter(Mandatory)] [string] $logStr
        )
        Write-Host $logStr
    }
    $loggerObj | Add-Member -MemberType ScriptMethod -Name OutHost -Value $outHostScript 

    #ファイル出力用スクリプト
    $outFileScript ={
        Param( 
            [Parameter(Mandatory)] [string] $logStr,
            [Parameter(Mandatory)] [LogLevel] $level
        )
        $logStr = $format -f (Get-Date).ToString("yyyy/MM/dd HH:mm:ss.fff"), $level.PadRight(5, " "), $logStr
        $logStr | Out-File -FilePath $this.logFilePath -Append -Encoding default 
    }
    $loggerObj | Add-Member -MemberType ScriptMethod -Name OutFile -Value $outFileScript 

    #ログ出力用スクリプト
    $script = {
        Param( 
            [Parameter(Mandatory)] [System.Object[]] $logStrArray
        )

        if($this.logLevel -ge $Script:level)
        {
            foreach($log in $logStrArray ){
                if( -Not($NoDisplay)){
                    $this.OutHost($log)
                }
                $this.OutFile($log, $Script:level)
            }
        }
    }
    #logLevel分メソッド作成
    foreach($level_tmep in ([System.Enum]::GetNames([LogLevel])))
    {
        [LogLevel] $level = $level_tmep
        $loggerObj | Add-Member -MemberType ScriptMethod -Name $level.toString() -Value $script.GetNewClosure()
    }

    return $loggerObj 
}
