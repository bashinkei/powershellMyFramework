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

    #�����o�ϐ��̒ǉ�
    $loggerObj | Add-Member -MemberType NoteProperty -Name logFilePath -Value $logFilePath
    $loggerObj | Add-Member -MemberType NoteProperty -Name logLevel -Value $logLevel

    #���O�t�H�[�}�b�g
    $format = "{0} [{1}] {2}"

    #���\�b�h�̒ǉ�
    #��ʕ\���p�X�N���v�g
    $outHostScript = {
        Param( 
            [Parameter(Mandatory)] [string] $logStr
        )
        Write-Host $logStr
    }
    $loggerObj | Add-Member -MemberType ScriptMethod -Name OutHost -Value $outHostScript 

    #�t�@�C���o�͗p�X�N���v�g
    $outFileScript ={
        Param( 
            [Parameter(Mandatory)] [string] $logStr,
            [Parameter(Mandatory)] [LogLevel] $level
        )
        $logStr = $format -f (Get-Date).ToString("yyyy/MM/dd HH:mm:ss.fff"), $level.PadRight(5, " "), $logStr
        $logStr | Out-File -FilePath $this.logFilePath -Append -Encoding default 
    }
    $loggerObj | Add-Member -MemberType ScriptMethod -Name OutFile -Value $outFileScript 

    #���O�o�͗p�X�N���v�g
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
    #logLevel�����\�b�h�쐬
    foreach($level_tmep in ([System.Enum]::GetNames([LogLevel])))
    {
        [LogLevel] $level = $level_tmep
        $loggerObj | Add-Member -MemberType ScriptMethod -Name $level.toString() -Value $script.GetNewClosure()
    }

    return $loggerObj 
}
