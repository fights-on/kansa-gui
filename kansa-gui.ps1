<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Kansa Gui
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

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
$group_targeting.location        = New-Object System.Drawing.Point(20,19)

$group_auth                      = New-Object system.Windows.Forms.Groupbox
$group_auth.height               = 140
$group_auth.width                = 200
$group_auth.text                 = "Authentication"
$group_auth.location             = New-Object System.Drawing.Point(360,20)

$group_settings                  = New-Object system.Windows.Forms.Groupbox
$group_settings.height           = 100
$group_settings.width            = 200
$group_settings.text             = "App Settings"
$group_settings.location         = New-Object System.Drawing.Point(574,20)

$group_connection                = New-Object system.Windows.Forms.Groupbox
$group_connection.height         = 100
$group_connection.width          = 200
$group_connection.text           = "Connection Settings"
$group_connection.location       = New-Object System.Drawing.Point(361,175)

$group_modules                   = New-Object system.Windows.Forms.Groupbox
$group_modules.height            = 294
$group_modules.width             = 375
$group_modules.text              = "Modules"
$group_modules.location          = New-Object System.Drawing.Point(20,333)

$group_analysis                  = New-Object system.Windows.Forms.Groupbox
$group_analysis.height           = 295
$group_analysis.width            = 365
$group_analysis.text             = "Post-Analysis"
$group_analysis.location         = New-Object System.Drawing.Point(409,332)

$Panel1                          = New-Object system.Windows.Forms.Panel
$Panel1.height                   = 150
$Panel1.width                    = 204
$Panel1.BackColor                = "#f2f2f2"
$Panel1.location                 = New-Object System.Drawing.Point(574,149)

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
$radio_target_list.location      = New-Object System.Drawing.Point(10,50)
$radio_target_list.Font          = 'Microsoft Sans Serif,10'

$radio_target_count              = New-Object system.Windows.Forms.RadioButton
$radio_target_count.text         = "Target Count:"
$radio_target_count.AutoSize     = $false
$radio_target_count.width        = 110
$radio_target_count.height       = 20
$radio_target_count.location     = New-Object System.Drawing.Point(10,272)
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
$text_target_count.location      = New-Object System.Drawing.Point(120,270)
$text_target_count.Font          = 'Microsoft Sans Serif,10'

$list_target_list                = New-Object system.Windows.Forms.ListView
$list_target_list.BackColor      = "#cccccc"
$list_target_list.text           = "listView"
$list_target_list.width          = 170
$list_target_list.height         = 210
$list_target_list.location       = New-Object System.Drawing.Point(120,50)

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
$lbl_user.text                   = "DOMAIN\USER"
$lbl_user.AutoSize               = $true
$lbl_user.width                  = 100
$lbl_user.height                 = 10
$lbl_user.location               = New-Object System.Drawing.Point(50,45)
$lbl_user.Font                   = 'Microsoft Sans Serif,10'

$combo_auth                      = New-Object system.Windows.Forms.ComboBox
$combo_auth.text                 = "Kerberos"
$combo_auth.width                = 180
$combo_auth.height               = 20
$combo_auth.location             = New-Object System.Drawing.Point(10,105)
$combo_auth.Font                 = 'Microsoft Sans Serif,10'

$form_kansa.controls.AddRange(@($group_targeting,$group_auth,$group_settings,$group_connection,$group_modules,$group_analysis,$Panel1))
$group_targeting.controls.AddRange(@($radio_target,$radio_target_list,$radio_target_count,$text_targetRRR,$text_target_count,$list_target_list))
$group_auth.controls.AddRange(@($check_auth,$btn_set_user,$lbl_user,$combo_auth))

#region gui events {
#endregion events }

#endregion GUI }




[void]$form_kansa.ShowDialog()
