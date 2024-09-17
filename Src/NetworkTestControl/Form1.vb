Public Class Form1
    '计算缩放比例
    Dim scaleX As Single
    Dim scaleY As Single
    Dim a As Integer
    Private Sub Timer1_Tick(sender As System.Object, e As System.EventArgs) Handles Timer1.Tick
        If My.Computer.Network.IsAvailable = True Then
            Me.Label1.Text = "网络已连接。"
            Me.Hide()
            Me.Location = New Size((System.Windows.Forms.SystemInformation.PrimaryMonitorSize.Width - Me.Width) / 2, 15 * scaleY)
            a = 0
        Else
            Me.Label1.Text = "网络连接已断开！请检查你的网络设置。"
            If a = 0 Then
                Me.Location = New Size((System.Windows.Forms.SystemInformation.PrimaryMonitorSize.Width - Me.Width) / 2, 15 * scaleY)
                a = 1
            End If
            Me.Show()
        End If
    End Sub

    Private Sub Form1_Load(sender As System.Object, e As System.EventArgs) Handles MyBase.Load
        a = 0
        ' 获取当前窗体的 DPI
        Dim currentDpiX As Single = Me.CreateGraphics().DpiX
        Dim currentDpiY As Single = Me.CreateGraphics().DpiY
        '计算缩放比例
        scaleX = currentDpiX / 96
        scaleY = currentDpiY / 96
        Me.Location = New Size(-((Me.Width + 10) * scaleX), -((Me.Height + 10) * scaleY))
        Timer1.Interval = 100
        Timer1.Enabled = True
    End Sub

    'API移动窗体
    Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As IntPtr, ByVal wMsg As Integer, ByVal wParam As Integer, ByVal lParam As Integer) As Boolean
    Declare Function ReleaseCapture Lib "user32" Alias "ReleaseCapture" () As Boolean
    Const WM_SYSCOMMAND = &H112
    Const SC_MOVE = &HF010&
    Const HTCAPTION = 2
    Private Sub Form1_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles MyBase.MouseDown
        ReleaseCapture()
        SendMessage(Me.Handle, WM_SYSCOMMAND, SC_MOVE + HTCAPTION, 0)
    End Sub
    Private Sub Label1_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles Label1.MouseDown
        ReleaseCapture()
        SendMessage(Me.Handle, WM_SYSCOMMAND, SC_MOVE + HTCAPTION, 0)
    End Sub
    Private Sub PictureBox1_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles PictureBox1.MouseDown
        ReleaseCapture()
        SendMessage(Me.Handle, WM_SYSCOMMAND, SC_MOVE + HTCAPTION, 0)
    End Sub
End Class
