Add-Type -AssemblyName System.Windows.Forms,PresentationCore,PresentationFramework
[System.Windows.Forms.Application]::EnableVisualStyles()
[void][Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")

# Globals
$CLI_Arguments = @{}
$Options = @{
    Target       = "127.0.0.1"
    Target_Count = "10"
    Use_Auth     = $false
    Creds        = $null
    Auth_Method  = "Kerberos"
    Mod_Path     = ".\Modules"
    JSON_Depth   = "10"
    Port         = "5985"
}

Function Read-Module-List(){
    # Generates an array of modules available for Kansa
    Push-Location .\Kansa
    $Modules = $(.\kansa.ps1 -ListModules) | Out-String
    Pop-Location
    $Modules = $Modules.Split("`r`n",[System.StringSplitOptions]::RemoveEmptyEntries)
    Return $Modules[0..($Modules.Length-2)] | Sort-Object -Unique
}

Function Read-Script-List(){
    # Generates an array of analysis scripts available for Kansa
    Push-Location .\Kansa
    $Scripts = $(.\kansa.ps1 -ListAnalysis) | Out-String
    Pop-Location
    $Scripts = $Scripts.Split("`r`n",[System.StringSplitOptions]::RemoveEmptyEntries)
    Return $Scripts[0..($Scripts.Length-2)] | Sort-Object -Unique
}

Function Initialize-Target-List($items){
    # Builds Targets.txt in the Kansa Directory
    If (!(Test-Path ".\Kansa\Targets.txt")){
        New-Item -Path ".\Kansa\Targets.txt" -Type "File"
    }
    Clear-Content -Path ".\Kansa\Targets.txt"
    ForEach ($i in $items){
        Add-Content ".\Kansa\Targets.txt" $i
    }
}

Function Initialize-Splat(){
    # Build the HashTable for Kansa's arguments

    # Targeting
    If ($rad_target.Checked){
        $CLI_Arguments.Target = $Options.Target
        $CLI_Arguments.Remove("TargetList")
        $CLI_Arguments.Remove("TargetCount")
    } ElseIf ($rad_target_list.Checked){
        If ($lst_target_list.Items.Count -eq 0){
            [System.Windows.MessageBox]::Show("You must add targets to the list!", "No Targets", "OK", "Warning") > $null
            Return $false
        }
        $CLI_Arguments.TargetList = "Targets.txt"
        $CLI_Arguments.Remove("Target")
        $CLI_Arguments.Remove("TargetCount")
    } Else {
        $CLI_Arguments.TargetCount = $Options.Target_Count
        $CLI_Arguments.Remove("Target")
        $CLI_Arguments.Remove("TargetList")
    }

    # Authentication
    If ($chk_auth){
        If ($Options.Creds){
            $CLI_Arguments.Credential = $Options.Creds
        } Else {
            $CLI_Arguments.Remove("Credential")
        }
        If (!($Options.Auth_Method -eq "Kerberos")){
            $CLI_Arguments.Authentication = $Options.Auth_Method
        } Else {
            $CLI_Arguments.Remove("Authentication")
        }
    }

    # Settings
    If (!($Options.Mod_Path -eq ".\Modules")){
        $CLI_Arguments.ModulePath = $Options.Mod_Path
    } Else {
        $CLI_Arguments.Remove("ModulePath")
    }
    If (!($Options.JSON_Depth -eq "10")){
        $CLI_Arguments.JSONDepth = $Options.JSON_Depth
    } Else {
        $CLI_Arguments.Remove("JSONDepth")
    }
    If ($chk_ascii.Checked){
        $CLI_Arguments.Ascii = $true
    } Else {
        $CLI_Arguments.Remove("Ascii")
    }
    If ($chk_transcribe.Checked){
        $CLI_Arguments.Transcribe = $true
    } Else {
        $CLI_Arguments.Remove("Transcribe")
    }

    # Connection Settings
    If ($chk_ssl.Checked){
        $CLI_Arguments.UseSSL = $true
        If (!($Options.Port -eq "5986")){
            $CLI_Arguments.Port = $Options.Port
        } Else {
            $CLI_Arguments.Remove("Port")
        }
    } Else {
        $CLI_Arguments.Remove("UseSSL")
        If (!($Options.Port -eq "5985")){
            $CLI_Arguments.Port = $Options.Port
        } Else {
            $CLI_Arguments.Remove("Port")
        }
    }

    # Module Settings
    If ($chk_push_bin.Checked){
        $CLI_Arguments.Pushbin = $true
    } Else {
        $CLI_Arguments.Remove("Pushbin")
    }
    If ($chk_rm_bin.Checked){
        $CLI_Arguments.Rmbin = $true
    } Else {
        $CLI_Arguments.Remove("Rmbin")
    }

    # Analysis Settings
    If ($chk_analysis.Checked){
        $CLI_Arguments.Analysis = $true
    } Else {
        $CLI_Arguments.Remove("Analysis")
    }

    Return $true
}

# GUI
$frm_kansa                       = New-Object system.Windows.Forms.Form
$frm_kansa.ClientSize            = '790,610'
$frm_kansa.text                  = "Kansa GUI"
$frm_kansa.BackColor             = "#4d4d4d"
$frm_kansa.TopMost               = $false
$frm_kansa.icon                  = "icon.ico"

# Targeting
$grp_targeting                   = New-Object system.Windows.Forms.Groupbox
$grp_targeting.height            = 280
$grp_targeting.width             = 250
$grp_targeting.BackColor         = "#cccccc"
$grp_targeting.text              = "Targeting"
$grp_targeting.location          = New-Object System.Drawing.Point(10,10)

$rad_target                      = New-Object system.Windows.Forms.RadioButton
$rad_target.text                 = "Target:"
$rad_target.AutoSize             = $false
$rad_target.width                = 107
$rad_target.height               = 20
$rad_target.location             = New-Object System.Drawing.Point(10,20)
$rad_target.Font                 = 'Microsoft Sans Serif,10'
$rad_target.Checked              = $true
$rad_target.Cursor               = [System.Windows.Forms.Cursors]::Hand

$rad_target_list                 = New-Object system.Windows.Forms.RadioButton
$rad_target_list.text            = "Target List:"
$rad_target_list.AutoSize        = $false
$rad_target_list.width           = 107
$rad_target_list.height          = 20
$rad_target_list.location        = New-Object System.Drawing.Point(10,50)
$rad_target_list.Font            = 'Microsoft Sans Serif,10'
$rad_target_list.Cursor          = [System.Windows.Forms.Cursors]::Hand

$rad_target_count                = New-Object system.Windows.Forms.RadioButton
$rad_target_count.text           = "Target Count:"
$rad_target_count.AutoSize       = $false
$rad_target_count.width          = 107
$rad_target_count.height         = 20
$rad_target_count.location       = New-Object System.Drawing.Point(10,255)
$rad_target_count.Font           = 'Microsoft Sans Serif,10'
$rad_target_count.Cursor         = [System.Windows.Forms.Cursors]::Hand

$txt_target                      = New-Object system.Windows.Forms.TextBox
$txt_target.multiline            = $false
$txt_target.text                 = "127.0.0.1"
$txt_target.BackColor            = "#b3b3b3"
$txt_target.width                = 125
$txt_target.height               = 20
$txt_target.location             = New-Object System.Drawing.Point(117,18)
$txt_target.Font                 = 'Microsoft Sans Serif,10'

$txt_target_count                = New-Object system.Windows.Forms.TextBox
$txt_target_count.multiline      = $false
$txt_target_count.text           = "10"
$txt_target_count.BackColor      = "#b3b3b3"
$txt_target_count.width          = 125
$txt_target_count.height         = 20
$txt_target_count.location       = New-Object System.Drawing.Point(117,253)
$txt_target_count.Font           = 'Microsoft Sans Serif,10'

$lst_target_list                 = New-Object system.Windows.Forms.ListBox
$lst_target_list.BackColor       = "#b3b3b3"
$lst_target_list.width           = 125
$lst_target_list.height          = 200
$lst_target_list.location        = New-Object System.Drawing.Point(117,48)
$lst_target_list.SelectionMode  = "MultiExtended"

$btn_target_add                  = New-Object system.Windows.Forms.Button
$btn_target_add.BackColor        = "#fad6fc"
$btn_target_add.text             = "+"
$btn_target_add.width            = 20
$btn_target_add.height           = 20
$btn_target_add.location         = New-Object System.Drawing.Point(90,70)
$btn_target_add.Font             = 'Microsoft Sans Serif,10'
$btn_target_add.Cursor           = [System.Windows.Forms.Cursors]::Hand

$btn_target_sub                  = New-Object system.Windows.Forms.Button
$btn_target_sub.BackColor        = "#fad6fc"
$btn_target_sub.text             = "-"
$btn_target_sub.width            = 20
$btn_target_sub.height           = 20
$btn_target_sub.location         = New-Object System.Drawing.Point(90,90)
$btn_target_sub.Font             = 'Microsoft Sans Serif,10'
$btn_target_sub.Cursor           = [System.Windows.Forms.Cursors]::Hand

# Authentication
$grp_auth                        = New-Object system.Windows.Forms.Groupbox
$grp_auth.height                 = 120
$grp_auth.width                  = 270
$grp_auth.BackColor              = "#cccccc"
$grp_auth.text                   = "Authentication"
$grp_auth.location               = New-Object System.Drawing.Point(275,10)

$chk_auth                        = New-Object system.Windows.Forms.CheckBox
$chk_auth.text                   = "Use Authentication"
$chk_auth.AutoSize               = $false
$chk_auth.width                  = 140
$chk_auth.height                 = 20
$chk_auth.location               = New-Object System.Drawing.Point(10,20)
$chk_auth.Font                   = 'Microsoft Sans Serif,10'
$chk_auth.Cursor                 = [System.Windows.Forms.Cursors]::Hand

$lbl_cur_user                    = New-Object system.Windows.Forms.Label
$lbl_cur_user.text               = "Current User:"
$lbl_cur_user.AutoSize           = $false
$lbl_cur_user.width              = 100
$lbl_cur_user.height             = 20
$lbl_cur_user.location           = New-Object System.Drawing.Point(10,45)
$lbl_cur_user.Font               = 'Microsoft Sans Serif,10'

$lbl_user                        = New-Object system.Windows.Forms.Label
$lbl_user.text                   = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$lbl_user.AutoSize               = $false
$lbl_user.width                  = 260
$lbl_user.height                 = 20
$lbl_user.location               = New-Object System.Drawing.Point(10,65)
$lbl_user.Font                   = 'Microsoft Sans Serif,10,style=Bold'

$lbl_method                      = New-Object system.Windows.Forms.Label
$lbl_method.text                 = "Method:"
$lbl_method.AutoSize             = $false
$lbl_method.width                = 55
$lbl_method.height               = 20
$lbl_method.location             = New-Object System.Drawing.Point(10,90)
$lbl_method.Font                 = 'Microsoft Sans Serif,10'

$btn_set_user                    = New-Object system.Windows.Forms.Button
$btn_set_user.BackColor          = "#fad6fc"
$btn_set_user.text               = "Set User"
$btn_set_user.width              = 100
$btn_set_user.height             = 24
$btn_set_user.location           = New-Object System.Drawing.Point(160,17)
$btn_set_user.Font               = 'Microsoft Sans Serif,10'
$btn_set_user.Cursor              = [System.Windows.Forms.Cursors]::Hand

$cmb_auth                        = New-Object system.Windows.Forms.ComboBox
$cmb_auth.text                   = "Kerberos"
$cmb_auth.BackColor              = "#b3b3b3"
$cmb_auth.width                  = 195
$cmb_auth.height                 = 20
$cmb_auth.location               = New-Object System.Drawing.Point(65,86)
$cmb_auth.Font                   = 'Microsoft Sans Serif,10'
$cmb_auth.Cursor                 = [System.Windows.Forms.Cursors]::Hand
$cmb_auth.Items.AddRange(("Basic", "CredSSP", "Digest", "Kerberos", "Negotiate", "NegotiateWithImplicitCredential")) > $null

# Settings
$grp_settings                    = New-Object system.Windows.Forms.Groupbox
$grp_settings.height             = 145
$grp_settings.width              = 270
$grp_settings.BackColor          = "#cccccc"
$grp_settings.text               = "App Settings"
$grp_settings.location           = New-Object System.Drawing.Point(275,145)

$lbl_mod_path                    = New-Object system.Windows.Forms.Label
$lbl_mod_path.text               = "Module Path:"
$lbl_mod_path.AutoSize           = $false
$lbl_mod_path.width              = 90
$lbl_mod_path.height             = 20
$lbl_mod_path.location           = New-Object System.Drawing.Point(10,20)

$lbl_mod_path.Font               = 'Microsoft Sans Serif,10'
$lbl_json_depth                  = New-Object system.Windows.Forms.Label
$lbl_json_depth.text             = "JSON Depth:"
$lbl_json_depth.AutoSize         = $false
$lbl_json_depth.width            = 90
$lbl_json_depth.height           = 20
$lbl_json_depth.location         = New-Object System.Drawing.Point(10,58)
$lbl_json_depth.Font             = 'Microsoft Sans Serif,10'

$txt_mod_path                    = New-Object system.Windows.Forms.TextBox
$txt_mod_path.Text               = ".\Modules"
$txt_mod_path.multiline          = $false
$txt_mod_path.BackColor          = "#b3b3b3"
$txt_mod_path.width              = 160
$txt_mod_path.height             = 20
$txt_mod_path.location           = New-Object System.Drawing.Point(100,17)
$txt_mod_path.Font               = 'Microsoft Sans Serif,10'

$txt_json_depth                  = New-Object system.Windows.Forms.TextBox
$txt_json_depth.Text             = "10"
$txt_json_depth.multiline        = $false
$txt_json_depth.BackColor        = "#b3b3b3"
$txt_json_depth.width            = 160
$txt_json_depth.height           = 20
$txt_json_depth.location         = New-Object System.Drawing.Point(100,55)
$txt_json_depth.Font             = 'Microsoft Sans Serif,10'

$chk_ascii                       = New-Object system.Windows.Forms.CheckBox
$chk_ascii.text                  = "ASCII Output"
$chk_ascii.AutoSize              = $false
$chk_ascii.width                 = 120
$chk_ascii.height                = 20
$chk_ascii.location              = New-Object System.Drawing.Point(10,88)
$chk_ascii.Font                  = 'Microsoft Sans Serif,10'

$chk_transcribe                  = New-Object system.Windows.Forms.CheckBox
$chk_transcribe.text             = "Transcribe"
$chk_transcribe.AutoSize         = $false
$chk_transcribe.width            = 120
$chk_transcribe.height           = 20
$chk_transcribe.location         = New-Object System.Drawing.Point(10,115)
$chk_transcribe.Font             = 'Microsoft Sans Serif,10'

# Connection Settings
$grp_connection                  = New-Object system.Windows.Forms.Groupbox
$grp_connection.height           = 145
$grp_connection.width            = 220
$grp_connection.BackColor        = "#cccccc"
$grp_connection.text             = "Connection Settings"
$grp_connection.location         = New-Object System.Drawing.Point(560,145)

$chk_ssl                         = New-Object system.Windows.Forms.CheckBox
$chk_ssl.text                    = "Use SSL"
$chk_ssl.AutoSize                = $false
$chk_ssl.width                   = 95
$chk_ssl.height                  = 20
$chk_ssl.location                = New-Object System.Drawing.Point(10,35)
$chk_ssl.Font                    = 'Microsoft Sans Serif,10'

$lbl_port                        = New-Object system.Windows.Forms.Label
$lbl_port.text                   = "Port:"
$lbl_port.AutoSize               = $false
$lbl_port.width                  = 40
$lbl_port.height                 = 20
$lbl_port.location               = New-Object System.Drawing.Point(10,68)
$lbl_port.Font                   = 'Microsoft Sans Serif,10'

$txt_port                        = New-Object system.Windows.Forms.TextBox
$txt_port.Text                   = "5985"
$txt_port.multiline              = $false
$txt_port.BackColor              = "#b3b3b3"
$txt_port.width                  = 160
$txt_port.height                 = 20
$txt_port.location               = New-Object System.Drawing.Point(50,65)
$txt_port.Font                   = 'Microsoft Sans Serif,10'

# Button Panel
$pnl_execute                     = New-Object system.Windows.Forms.Panel
$pnl_execute.height              = 120
$pnl_execute.width               = 220
$pnl_execute.BackColor           = "#cccccc"
$pnl_execute.location            = New-Object System.Drawing.Point(560,10)

$btn_run                         = New-Object system.Windows.Forms.Button
$btn_run.BackColor               = "#fad6fc"
$btn_run.text                    = "Make, Go, Happen!"
$btn_run.width                   = 160
$btn_run.height                  = 50
$btn_run.location                = New-Object System.Drawing.Point(30,33)
$btn_run.Font                    = 'Microsoft Sans Serif,10'

# Module List
$grp_modules                     = New-Object system.Windows.Forms.Groupbox
$grp_modules.height              = 300
$grp_modules.width               = 377
$grp_modules.BackColor           = "#cccccc"
$grp_modules.text                = "Modules"
$grp_modules.location            = New-Object System.Drawing.Point(10,300)

$lst_modules                     = New-Object system.Windows.Forms.ListBox
$lst_modules.BackColor           = "#b3b3b3"
$lst_modules.width               = 355
$lst_modules.height              = 240
$lst_modules.location            = New-Object System.Drawing.Point(10,20)
$lst_modules.SelectionMode       = "MultiExtended"
$lst_modules.Items.AddRange($(Read-Module-List))

$chk_push_bin                    = New-Object system.Windows.Forms.CheckBox
$chk_push_bin.text               = "Push Binary"
$chk_push_bin.AutoSize           = $false
$chk_push_bin.width              = 100
$chk_push_bin.height             = 20
$chk_push_bin.location           = New-Object System.Drawing.Point(10,270)
$chk_push_bin.Font               = 'Microsoft Sans Serif,10'

$chk_rm_bin                      = New-Object system.Windows.Forms.CheckBox
$chk_rm_bin.text                 = "Remove Binary"
$chk_rm_bin.AutoSize             = $false
$chk_rm_bin.width                = 120
$chk_rm_bin.height               = 20
$chk_rm_bin.location             = New-Object System.Drawing.Point(120,270)
$chk_rm_bin.Font                 = 'Microsoft Sans Serif,10'

# Analysis Scripts
$grp_analysis                    = New-Object system.Windows.Forms.Groupbox
$grp_analysis.height             = 300
$grp_analysis.width              = 377
$grp_analysis.BackColor          = "#cccccc"
$grp_analysis.text               = "Post-Analysis"
$grp_analysis.location           = New-Object System.Drawing.Point(403,300)

$lst_analysis                    = New-Object system.Windows.Forms.ListBox
$lst_analysis.BackColor          = "#b3b3b3"
$lst_analysis.width              = 355
$lst_analysis.height             = 240
$lst_analysis.location           = New-Object System.Drawing.Point(10,20)
$lst_analysis.SelectionMode      = "MultiExtended"
$lst_analysis.Items.AddRange($(Read-Script-List))

$chk_analysis                    = New-Object system.Windows.Forms.CheckBox
$chk_analysis.text               = "Use Post-Analysis"
$chk_analysis.AutoSize           = $false
$chk_analysis.width              = 135
$chk_analysis.height             = 20
$chk_analysis.location           = New-Object System.Drawing.Point(10,270)
$chk_analysis.Font               = 'Microsoft Sans Serif,10'

$frm_kansa.controls.AddRange(@($grp_targeting,$grp_auth,$grp_settings,$grp_connection,$pnl_execute,$grp_modules,$grp_analysis))
$grp_targeting.controls.AddRange(@($rad_target,$rad_target_list,$rad_target_count,$txt_target,$txt_target_count,$lst_target_list,$btn_target_add,$btn_target_sub))
$grp_auth.controls.AddRange(@($chk_auth,$lbl_cur_user,$lbl_user,$lbl_method,$btn_set_user,$cmb_auth))
$grp_settings.controls.AddRange(@($lbl_mod_path, $lbl_json_depth,$txt_mod_path,$txt_json_depth,$chk_ascii,$chk_transcribe))
$grp_connection.controls.AddRange(@($chk_ssl,$lbl_port,$txt_port))
$grp_modules.controls.AddRange(@($lst_modules,$chk_push_bin,$chk_rm_bin))
$grp_analysis.controls.AddRange(@($lst_analysis,$chk_analysis))
$pnl_execute.controls.AddRange(@($btn_run))

# Targeting Events
$btn_target_add.Add_Click({
    $rad_target_list.Checked = $true
    $text = [Microsoft.VisualBasic.Interaction]::InputBox("Add a target to Kansa.`nMultiple targets can be comma seperated.", "Add Target")
    $text = $text.Replace("\s","").Split(",")
    $lst_target_list.Items.AddRange($text)
    Initialize-Target-List($lst_target_list.Items)
})

$btn_target_sub.Add_Click({
    $temp = @()
    If ($lst_target_list.SelectedItems.Count -gt 0){
        For ($i=0; $i -le $lst_target_list.Items.Count-1; $i++){
            If ($lst_target_list.SelectedItems -NotContains $lst_target_list.Items[$i]){
                $temp += $lst_target_list.Items[$i]
            }
        }
        $lst_target_list.Items.Clear()
        $lst_target_list.Items.AddRange($temp)
        $temp.Clear()
        Initialize-Target-List($lst_target_list.Items)
    }
})

$txt_target.Add_TextChanged({
    If ($txt_target.Text -eq ""){
        $txt_target.Text = "127.0.0.1"
    } Else {
        $Options.Target = $txt_target.Text
    }
})

$txt_target_count.Add_TextChanged({
    If ($txt_target_count.Text -eq ""){
        $txt_target_count.Text = "10"
    } ElseIf ($txt_target_count.Text -Match "\D"){
        $txt_target_count.Text = $txt_target_count.Text -Replace "\D"
        $txt_target_count.Focus()
        $txt_target_count.SelectionStart = $txt_target_count.Text.Length
    }
    $Options.Target_Count = $txt_target_count.Text
})

$rad_target_list.Add_Click({
    If ($rad_target_list.Checked){
        Initialize-Target-List($lst_target_list.Items)
    }
})

# Authentication Events
$btn_set_user.Add_Click({
    $Options.Creds = Get-Credential
    $lbl_user.Text = $Options.Creds.UserName
    $lbl_user.Refresh()
})

$cmb_auth.Add_TextChanged({$Options.Auth_Method = $cmb_auth.Text})

# Settings Events
$txt_mod_path.Add_TextChanged({
    If ($txt_mod_path.Text -eq ""){
        $txt_mod_path.Text = ".\Modules"
    }
    $Options.Mod_Path = $txt_mod_path.Text
    ### UPDATE MODULE LIST TO REFLECT NEW PATH!!!! ###
})

$txt_json_depth.Add_TextChanged({
    If ($txt_json_depth.Text -eq ""){
        $txt_json_depth.Text = "10"
    } ElseIf ($txt_json_depth.Text -Match "\D"){
        $txt_json_depth.Text = $txt_json_depth.Text -Replace "\D"
        $txt_json_depth.Focus()
        $txt_json_depth.SelectionStart = $txt_json_depth.Text.Length
    }
    $Options.JSON_Depth = $txt_json_depth.Text
})

# Connection Events
$txt_port.Add_TextChanged({
    If ($chk_ssl.Checked -And $txt_port.Text -eq ""){
        $txt_port.Text -eq "5986"
    } ElseIf ($txt_port.Text -eq ""){
        $txt_port.Text -eq "5985"
    } ElseIf ($txt_port.Text -Match "\D"){
        $txt_port.Text = $txt_port.Text -Replace "\D"
        $txt_port.Focus()
        $txt_port.SelectionStart = $txt_port.Text.Length
    }
    $Options.Port = $txt_port.Text
})

$chk_ssl.Add_CheckedChanged({
    If ($chk_ssl.Checked){
        $txt_port.Text = "5986"
    } Else {
        $txt_port.Text = "5985"
    }
})

# Module List Events
$lst_modules.Add_SelectedIndexChanged({
    If ($lst_modules.SelectedItems.Count -gt 0){
        Clear-Content ".\Kansa\$($Options.Mod_Path)\Modules.conf"
        ForEach ($i in $lst_modules.SelectedItems){
            Add-Content ".\Kansa\$($Options.Mod_Path)\Modules.conf" $i
        }
    }
})

# Analysis Scripts List Events
$lst_analysis.Add_SelectedIndexChanged({
    If ($lst_analysis.SelectedItems.Count -gt 0){
        Clear-Content ".\Kansa\Analysis\Analysis.conf"
        ForEach ($i in $lst_analysis.SelectedItems){
            Add-Content ".\Kansa\Analysis\Analysis.conf" $i
        }
    }
})

# Panel Events
$btn_run.Add_Click({
    $build_success = (Initialize-Splat)
    If ($build_success){
        Write-Host $($CLI_Arguments | Out-String)
        Push-Location .\Kansa
        .\kansa.ps1 @CLI_Arguments
        Pop-Location
        Move-Item -Path ".\Kansa\Output_*" -Destination "."
    }
})

[void]$frm_kansa.ShowDialog()
$CLI_Arguments.Clear()
$Options.Clear()
