Imports System.Net
Imports System.Diagnostics
Imports System.Net.Sockets
Public Class Form1
    '计算缩放比例
    Dim scaleX As Single
    Dim scaleY As Single
    Dim a As Integer
    Dim b As Integer
    Private Sub Timer1_Tick(sender As System.Object, e As System.EventArgs) Handles Timer1.Tick
        If b = 0 Then
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
        Else
            Me.Label1.Text = "网络延时过高！请检查你的网络设置。"
            If a = 0 Then
                Me.Location = New Size((System.Windows.Forms.SystemInformation.PrimaryMonitorSize.Width - Me.Width) / 2, 15 * scaleY)
                a = 1
            End If
            Me.Show()
        End If
    End Sub

    Sub NetworkTest()
        Dim hostName As String = "www.baidu.com" ' 替换为你想测试的主机名
        Dim port As Integer = 80 ' 替换为你想测试的端口号
        Dim stopwatch As New Stopwatch()
        Dim tcpClient As New TcpClient()
        Try
            stopwatch.Start() ' 开始计时
            tcpClient.Connect(hostName, port) ' 尝试连接到主机
            stopwatch.Stop() ' 停止计时

            ' 计算并输出网络延迟
            Dim latency As Long = stopwatch.ElapsedMilliseconds
            'Console.WriteLine("网络延迟是：" & latency & " 毫秒")
            If latency > 1800 Then
                b = 1
            Else
                b = 0
            End If
        Catch ex As Exception
            b = 1
            'Console.WriteLine("无法连接到主机或者测量延迟：" & ex.Message)
        Finally
            tcpClient.Close() ' 关闭TcpClient
        End Try
    End Sub

    Private Sub Form1_Load(sender As System.Object, e As System.EventArgs) Handles MyBase.Load
        a = 0
        b = 0
        ' 获取当前窗体的 DPI
        Dim currentDpiX As Single = Me.CreateGraphics().DpiX
        Dim currentDpiY As Single = Me.CreateGraphics().DpiY
        '计算缩放比例
        scaleX = currentDpiX / 96
        scaleY = currentDpiY / 96
        Me.Location = New Size(-((Me.Width + 10) * scaleX), -((Me.Height + 10) * scaleY))
        Timer1.Interval = 100
        Timer1.Enabled = True
        Timer2.Interval = 100
        Timer2.Enabled = True
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

    Private Sub Timer2_Tick(sender As System.Object, e As System.EventArgs) Handles Timer2.Tick
        Call NetworkTest()
    End Sub
End Class
