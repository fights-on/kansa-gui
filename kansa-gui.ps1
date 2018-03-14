Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$CREDENTIAL = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
Push-Location .\Kansa
$MODULES = $(.\kansa.ps1 -ListModules) | Out-String
$MODULES = $MODULES.Split("`r`n",[System.StringSplitOptions]::RemoveEmptyEntries)
$MODULES = $MODULES[0..($MODULES.Length-2)]
$ANALYSIS = $(.\kansa.ps1 -ListAnalysis) | Out-String
$ANALYSIS = $ANALYSIS.Split("`r`n",[System.StringSplitOptions]::RemoveEmptyEntries)
$ANALYSIS = $ANALYSIS[0..($ANALYSIS.Length-2)]
Pop-Location

#region begin GUI{

$form_kansa                      = New-Object system.Windows.Forms.Form
$form_kansa.ClientSize           = '795,647'
$form_kansa.text                 = "Kansa"
$form_kansa.BackColor            = "#4d4d4d"
$form_kansa.TopMost              = $false
$form_kansa.icon                 = "icon.ico"

$group_targeting                 = New-Object system.Windows.Forms.Groupbox
$group_targeting.height          = 300
$group_targeting.width           = 300
$group_targeting.text            = "Targeting"
$group_targeting.location        = New-Object System.Drawing.Point(10,10)

$group_auth                      = New-Object system.Windows.Forms.Groupbox
$group_auth.height               = 140
$group_auth.width                = 223
$group_auth.text                 = "Authentication"
$group_auth.location             = New-Object System.Drawing.Point(320,10)

$group_settings                  = New-Object system.Windows.Forms.Groupbox
$group_settings.height           = 163
$group_settings.width            = 236
$group_settings.text             = "App Settings"
$group_settings.location         = New-Object System.Drawing.Point(555,10)

$group_connection                = New-Object system.Windows.Forms.Groupbox
$group_connection.height         = 123
$group_connection.width          = 216
$group_connection.text           = "Connection Settings"
$group_connection.location       = New-Object System.Drawing.Point(555,186)

$group_modules                   = New-Object system.Windows.Forms.Groupbox
$group_modules.height            = 294
$group_modules.width             = 375
$group_modules.text              = "Modules"
$group_modules.location          = New-Object System.Drawing.Point(20,332)

$group_analysis                  = New-Object system.Windows.Forms.Groupbox
$group_analysis.height           = 295
$group_analysis.width            = 365
$group_analysis.text             = "Post-Analysis"
$group_analysis.location         = New-Object System.Drawing.Point(409,332)

$panel_execute                   = New-Object system.Windows.Forms.Panel
$panel_execute.height            = 150
$panel_execute.width             = 223
$panel_execute.BackColor         = "#f2f2f2"
$panel_execute.location          = New-Object System.Drawing.Point(322,160)

$radio_target                    = New-Object system.Windows.Forms.RadioButton
$radio_target.text               = "Target:"
$radio_target.AutoSize           = $false
$radio_target.width              = 110
$radio_target.height             = 20
$radio_target.location           = New-Object System.Drawing.Point(10,20)
$radio_target.Font               = 'Microsoft Sans Serif,10'

$radio_target_list               = New-Object system.Windows.Forms.RadioButton
$radio_target_list.text          = "Target List:"
$radio_target_list.AutoSize      = $false
$radio_target_list.width         = 110
$radio_target_list.height        = 20
$radio_target_list.location      = New-Object System.Drawing.Point(10,60)
$radio_target_list.Font          = 'Microsoft Sans Serif,10'

$radio_target_count              = New-Object system.Windows.Forms.RadioButton
$radio_target_count.text         = "Target Count:"
$radio_target_count.AutoSize     = $false
$radio_target_count.width        = 110
$radio_target_count.height       = 20
$radio_target_count.location     = New-Object System.Drawing.Point(10,274)
$radio_target_count.Font         = 'Microsoft Sans Serif,10'

$text_targetRRR                  = New-Object system.Windows.Forms.TextBox
$text_targetRRR.multiline        = $false
$text_targetRRR.BackColor        = "#cccccc"
$text_targetRRR.width            = 170
$text_targetRRR.height           = 20
$text_targetRRR.location         = New-Object System.Drawing.Point(120,20)
$text_targetRRR.Font             = 'Microsoft Sans Serif,10'

$text_target_count               = New-Object system.Windows.Forms.TextBox
$text_target_count.multiline     = $false
$text_target_count.BackColor     = "#cccccc"
$text_target_count.width         = 170
$text_target_count.height        = 20
$text_target_count.location      = New-Object System.Drawing.Point(120,269)
$text_target_count.Font          = 'Microsoft Sans Serif,10'

$list_target_list                = New-Object system.Windows.Forms.ListView
$list_target_list.BackColor      = "#cccccc"
$list_target_list.text           = "listView"
$list_target_list.width          = 170
$list_target_list.height         = 210
$list_target_list.location       = New-Object System.Drawing.Point(120,48)

$check_auth                      = New-Object system.Windows.Forms.CheckBox
$check_auth.text                 = "Use Authentication"
$check_auth.AutoSize             = $true
$check_auth.width                = 95
$check_auth.height               = 20
$check_auth.location             = New-Object System.Drawing.Point(20,20)
$check_auth.Font                 = 'Microsoft Sans Serif,10'

$btn_set_user                    = New-Object system.Windows.Forms.Button
$btn_set_user.BackColor          = "#fad6fc"
$btn_set_user.text               = "Set User"
$btn_set_user.width              = 100
$btn_set_user.height             = 24
$btn_set_user.location           = New-Object System.Drawing.Point(50,70)
$btn_set_user.Font               = 'Microsoft Sans Serif,10'
$btn_set_user.ForeColor          = "#4d4d4d"

$lbl_user                        = New-Object system.Windows.Forms.Label
$lbl_user.text                   = $CREDENTIAL
$lbl_user.AutoSize               = $true
$lbl_user.width                  = 100
$lbl_user.height                 = 10
$lbl_user.location               = New-Object System.Drawing.Point(18,49)
$lbl_user.Font                   = 'Microsoft Sans Serif,10'

$combo_auth                      = New-Object system.Windows.Forms.ComboBox
$combo_auth.text                 = "Kerberos"
$combo_auth.BackColor            = "#cccccc"
$combo_auth.width                = 180
$combo_auth.height               = 20
$combo_auth.location             = New-Object System.Drawing.Point(10,105)
$combo_auth.Font                 = 'Microsoft Sans Serif,10'

$list_modules                    = New-Object system.Windows.Forms.ListBox
$list_modules.BackColor          = "#cccccc"
$list_modules.text               = "listBox"
$list_modules.width              = 334
$list_modules.height             = 235
$list_modules.location           = New-Object System.Drawing.Point(10,20)

$list_analysis                   = New-Object system.Windows.Forms.ListBox
$list_analysis.BackColor         = "#cccccc"
$list_analysis.text              = "list_analysis"
$list_analysis.width             = 346
$list_analysis.height            = 267
$list_analysis.location          = New-Object System.Drawing.Point(10,20)

$check_ssl                       = New-Object system.Windows.Forms.CheckBox
$check_ssl.text                  = "Use SSL"
$check_ssl.AutoSize              = $false
$check_ssl.width                 = 95
$check_ssl.height                = 20
$check_ssl.location              = New-Object System.Drawing.Point(16,26)
$check_ssl.Font                  = 'Microsoft Sans Serif,10'

$txt_port                        = New-Object system.Windows.Forms.TextBox
$txt_port.multiline              = $false
$txt_port.BackColor              = "#cccccc"
$txt_port.width                  = 134
$txt_port.height                 = 20
$txt_port.location               = New-Object System.Drawing.Point(62,59)
$txt_port.Font                   = 'Microsoft Sans Serif,10'

$lbl_port                        = New-Object system.Windows.Forms.Label
$lbl_port.text                   = "Port:"
$lbl_port.AutoSize               = $true
$lbl_port.width                  = 25
$lbl_port.height                 = 10
$lbl_port.location               = New-Object System.Drawing.Point(20,62)
$lbl_port.Font                   = 'Microsoft Sans Serif,10'

$lbl_mod_path                    = New-Object system.Windows.Forms.Label
$lbl_mod_path.text               = "Module Path:"
$lbl_mod_path.AutoSize           = $true
$lbl_mod_path.width              = 25
$lbl_mod_path.height             = 10
$lbl_mod_path.location           = New-Object System.Drawing.Point(16,22)
$lbl_mod_path.Font               = 'Microsoft Sans Serif,10'

$txt_mod_path                    = New-Object system.Windows.Forms.TextBox
$txt_mod_path.multiline          = $false
$txt_mod_path.BackColor          = "#cccccc"
$txt_mod_path.width              = 121
$txt_mod_path.height             = 20
$txt_mod_path.location           = New-Object System.Drawing.Point(105,17)
$txt_mod_path.Font               = 'Microsoft Sans Serif,10'

$check_push_bin                  = New-Object system.Windows.Forms.CheckBox
$check_push_bin.text             = "Push Binary"
$check_push_bin.AutoSize         = $false
$check_push_bin.width            = 95
$check_push_bin.height           = 20
$check_push_bin.location         = New-Object System.Drawing.Point(21,267)
$check_push_bin.Font             = 'Microsoft Sans Serif,10'

$check_rm_bin                    = New-Object system.Windows.Forms.CheckBox
$check_rm_bin.text               = "Remove Binary"
$check_rm_bin.AutoSize           = $false
$check_rm_bin.width              = 95
$check_rm_bin.height             = 20
$check_rm_bin.location           = New-Object System.Drawing.Point(218,269)
$check_rm_bin.Font               = 'Microsoft Sans Serif,10'

$check_ascii                     = New-Object system.Windows.Forms.CheckBox
$check_ascii.text                = "ASCII Output"
$check_ascii.AutoSize            = $false
$check_ascii.width               = 95
$check_ascii.height              = 20
$check_ascii.location            = New-Object System.Drawing.Point(16,48)
$check_ascii.Font                = 'Microsoft Sans Serif,10'

$check_analysis                  = New-Object system.Windows.Forms.CheckBox
$check_analysis.text             = "Run Analysis"
$check_analysis.AutoSize         = $false
$check_analysis.width            = 95
$check_analysis.height           = 20
$check_analysis.location         = New-Object System.Drawing.Point(18,76)
$check_analysis.Font             = 'Microsoft Sans Serif,10'

$check_transcribe                = New-Object system.Windows.Forms.CheckBox
$check_transcribe.text           = "Transcribe"
$check_transcribe.AutoSize       = $false
$check_transcribe.width          = 95
$check_transcribe.height         = 20
$check_transcribe.location       = New-Object System.Drawing.Point(16,102)
$check_transcribe.Font           = 'Microsoft Sans Serif,10'

$lbl_json_depth                  = New-Object system.Windows.Forms.Label
$lbl_json_depth.text             = "JSON Depth:"
$lbl_json_depth.AutoSize         = $true
$lbl_json_depth.width            = 25
$lbl_json_depth.height           = 10
$lbl_json_depth.location         = New-Object System.Drawing.Point(14,130)
$lbl_json_depth.Font             = 'Microsoft Sans Serif,10'

$txt_json_depth                  = New-Object system.Windows.Forms.TextBox
$txt_json_depth.multiline        = $false
$txt_json_depth.BackColor        = "#cccccc"
$txt_json_depth.width            = 123
$txt_json_depth.height           = 20
$txt_json_depth.location         = New-Object System.Drawing.Point(103,126)
$txt_json_depth.Font             = 'Microsoft Sans Serif,10'

$btn_run                         = New-Object system.Windows.Forms.Button
$btn_run.BackColor               = "#fad6fc"
$btn_run.text                    = "Make, Go, Happen!"
$btn_run.width                   = 123
$btn_run.height                  = 30
$btn_run.location                = New-Object System.Drawing.Point(51,10)
$btn_run.Font                    = 'Microsoft Sans Serif,10'

$btn_cancel                      = New-Object system.Windows.Forms.Button
$btn_cancel.BackColor            = "#fad6fc"
$btn_cancel.text                 = "Cancel"
$btn_cancel.width                = 122
$btn_cancel.height               = 30
$btn_cancel.location             = New-Object System.Drawing.Point(51,45)
$btn_cancel.Font                 = 'Microsoft Sans Serif,10'

$bar_execute                     = New-Object system.Windows.Forms.ProgressBar
$bar_execute.width               = 209
$bar_execute.height              = 33
$bar_execute.location            = New-Object System.Drawing.Point(10,88)

$form_kansa.controls.AddRange(@($group_targeting,$group_auth,$group_settings,$group_connection,$group_modules,$group_analysis,$panel_execute))
$group_targeting.controls.AddRange(@($radio_target,$radio_target_list,$radio_target_count,$text_targetRRR,$text_target_count,$list_target_list))
$group_auth.controls.AddRange(@($check_auth,$btn_set_user,$lbl_user,$combo_auth))
$group_modules.controls.AddRange(@($list_modules,$check_push_bin,$check_rm_bin))
$group_analysis.controls.AddRange(@($list_analysis))
$group_connection.controls.AddRange(@($check_ssl,$txt_port,$lbl_port))
$group_settings.controls.AddRange(@($lbl_mod_path,$txt_mod_path,$check_ascii,$check_analysis,$check_transcribe,$lbl_json_depth,$txt_json_depth))
$panel_execute.controls.AddRange(@($btn_run,$btn_cancel,$bar_execute))

#region gui events {
$btn_set_user.Add_Click({  })
$btn_run.Add_Click({  })
$panel_execute.Add_Click({  })
$check_ascii.Add_CheckedChanged({  })
$check_analysis.Add_CheckedChanged({  })
$check_transcribe.Add_CheckedChanged({  })
$radio_target.Add_CheckedChanged({  })
$radio_target_list.Add_CheckedChanged({  })
$radio_target_count.Add_CheckedChanged({  })
$check_push_bin.Add_CheckedChanged({  })
$check_rm_bin.Add_CheckedChanged({  })
$check_auth.Add_CheckedChanged({  })
$txt_mod_path.Add_TextChanged({  })
$txt_json_depth.Add_TextChanged({  })
$txt_port.Add_TextChanged({  })
$text_targetRRR.Add_TextChanged({  })
$text_target_count.Add_TextChanged({  })
#endregion events }

#endregion GUI }

[void]$form_kansa.ShowDialog()
