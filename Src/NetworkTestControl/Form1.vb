'****************************************************************************
'    NetworkTestControl
'    Copyright (C) 2024  CJH
'
'    This program is free software: you can redistribute it and/or modify
'    it under the terms of the GNU General Public License as published by
'    the Free Software Foundation, either version 3 of the License, or
'    (at your option) any later version.
'
'    This program is distributed in the hope that it will be useful,
'    but WITHOUT ANY WARRANTY; without even the implied warranty of
'    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'    GNU General Public License for more details.
'
'    You should have received a copy of the GNU General Public License
'    along with this program.  If not, see <http://www.gnu.org/licenses/>.
'****************************************************************************
'/*****************************************************\
'*                                                     *
'*     NetworkTestControl - Form1.vb                   *
'*                                                     *
'*     Copyright (c) CJH.                              *
'*                                                     *
'*     The main test and message form.                 *
'*                                                     *
'\*****************************************************/
Imports System.Net
Imports System.Diagnostics
Imports System.Net.Sockets
Imports Microsoft.Win32

Public Class Form1
    '计算缩放比例
    Dim scaleX As Single
    Dim scaleY As Single
    Dim a As Integer
    Dim b As Integer

    Dim TestHostName As String
    Dim TestTimer As Integer
    Dim NetworkTimer As Integer
    Dim MyTimeOut As Integer
    Dim UseTcpTest As Integer
    Dim DisbTest As Integer
    Private Sub Timer1_Tick(sender As System.Object, e As System.EventArgs) Handles Timer1.Tick
        If My.Computer.Network.IsAvailable = True Then
            If b = 0 Then
                Me.Label1.Text = "网络已连接。"
                Me.Hide()
                Me.Location = New Size((System.Windows.Forms.SystemInformation.PrimaryMonitorSize.Width - Me.Width) / 2, 15 * scaleY)
                a = 0
            Else
                'Me.Label1.Text = "网络延时过高！请检查你的网络设置。"
                Me.Label1.Text = "网络不可用，请检查你的网络设置"
                If a = 0 Then
                    Me.Location = New Size((System.Windows.Forms.SystemInformation.PrimaryMonitorSize.Width - Me.Width) / 2, 15 * scaleY)
                    a = 1
                End If
                Me.Show()
            End If
        Else
            'Me.Label1.Text = "网络连接已断开！请检查你的网络设置。"
            Me.Label1.Text = "网络不可用，请检查你的网络设置"
            If a = 0 Then
                Me.Location = New Size((System.Windows.Forms.SystemInformation.PrimaryMonitorSize.Width - Me.Width) / 2, 15 * scaleY)
                a = 1
            End If
            Me.Show()
        End If
    End Sub
    Sub NetworkTestPing()
        Dim hostName As String
        If Not TestHostName = "" Then
            hostName = TestHostName
        Else
            hostName = "www.baidu.com" ' 替换为你想测试的主机名
        End If
        Dim stopwatch As New Stopwatch()
        Try
            'stopwatch.Start() ' 开始计时
            'My.Computer.Network.Ping(hostName, MyTimeOut)
            'stopwatch.Stop() ' 停止计时
            ' 计算并输出网络延迟
            'Dim latency As Long = stopwatch.ElapsedMilliseconds
            'Console.WriteLine("网络延迟是：" & latency & " 毫秒")
            'If latency > MyTimeOut Then
            If My.Computer.Network.Ping(hostName, MyTimeOut) = False Then
                b = 1
            Else
                b = 0
            End If
        Catch ex As Exception
            b = 1
        End Try
    End Sub
    Sub NetworkTestTcp()
        Dim hostName As String
        If Not TestHostName = "" Then
            hostName = TestHostName
        Else
            hostName = "www.baidu.com" ' 替换为你想测试的主机名
        End If
        Dim port As Integer = 80 ' 替换为你想测试的端口号
        Dim stopwatch As New Stopwatch()
        Dim tcpClient As New TcpClient()
        Try
            tcpClient.ReceiveTimeout = MyTimeOut
            stopwatch.Start() ' 开始计时
            tcpClient.Connect(hostName, port) ' 尝试连接到主机
            stopwatch.Stop() ' 停止计时

            ' 计算并输出网络延迟
            Dim latency As Long = stopwatch.ElapsedMilliseconds
            'Console.WriteLine("网络延迟是：" & latency & " 毫秒")
            If latency > MyTimeOut Then
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
        'On Error Resume Next
        a = 0
        b = 0
        ' 获取当前窗体的 DPI
        Dim currentDpiX As Single = Me.CreateGraphics().DpiX
        Dim currentDpiY As Single = Me.CreateGraphics().DpiY
        '计算缩放比例
        scaleX = currentDpiX / 96
        scaleY = currentDpiY / 96
        Me.Location = New Size(-((Me.Width + 10) * scaleX), -((Me.Height + 10) * scaleY))

        Dim mykey As RegistryKey = Registry.CurrentUser.OpenSubKey("Software\CJH\NetworkTestControl\Settings", True)
        ' Try

        Try
            Dim myt As Integer
            If (Not mykey Is Nothing) Then
                myt = mykey.GetValue("TestTimer", -1)
                If myt > 0 Then
                    TestTimer = myt
                Else
                    TestTimer = 1000
                End If
            Else
                TestTimer = 1000
            End If
        Catch ex As Exception
            TestTimer = 1000
        End Try
        Try
            Dim myt As Integer
            If (Not mykey Is Nothing) Then
                myt = mykey.GetValue("NetworkTimer", -1)
                If myt > 0 Then
                    NetworkTimer = myt
                Else
                    NetworkTimer = 1000
                End If
            Else
                NetworkTimer = 1000
            End If
        Catch ex As Exception
            NetworkTimer = 1000
        End Try
        Try
            Dim myt As Integer
            If (Not mykey Is Nothing) Then
                myt = mykey.GetValue("UseTcpTest", -1)
                If myt > 0 Then
                    UseTcpTest = myt
                ElseIf myt > 1 Then
                    UseTcpTest = 0
                Else
                    UseTcpTest = 0
                End If
            Else
                UseTcpTest = 0
            End If
        Catch ex As Exception
            UseTcpTest = 0
        End Try
        Try
            Dim myt As Integer
            If (Not mykey Is Nothing) Then
                myt = mykey.GetValue("DisableNetworkTest", -1)
                If myt > 0 Then
                    DisbTest = myt
                ElseIf myt > 1 Then
                    DisbTest = 0
                Else
                    DisbTest = 0
                End If
            Else
                DisbTest = 0
            End If
        Catch ex As Exception
            DisbTest = 0
        End Try
        Try
            Dim myt As Integer
            If (Not mykey Is Nothing) Then
                myt = mykey.GetValue("Timeout", -1)
                If myt > 0 Then
                    MyTimeOut = myt
                Else
                    MyTimeOut = 2000
                End If
            Else
                MyTimeOut = 2000
            End If
        Catch ex As Exception
            MyTimeOut = 2000
        End Try
        Try
            Dim myv As String
            If (Not mykey Is Nothing) Then
                myv = mykey.GetValue("TestHostName", "-1")
                If Not myv = "-1" Then
                    TestHostName = myv
                Else
                    TestHostName = "www.baidu.com"
                End If
            Else
                TestHostName = "www.baidu.com"
            End If
        Catch ex As Exception
            TestHostName = "www.baidu.com"
        End Try
        ' Catch ex As Exception
        'Finally
        If (Not mykey Is Nothing) Then
            mykey.Close()
        End If
        'End Try

        If NetworkTimer > 0 Then
            Timer1.Interval = NetworkTimer
        Else
            Timer1.Interval = 1000
        End If
        Timer1.Enabled = True
        If TestTimer > 0 Then
            Timer2.Interval = TestTimer
        Else
            Timer2.Interval = 1000
        End If
        If DisbTest = 0 Then
            Timer2.Enabled = True
        Else
            Timer2.Enabled = False
        End If
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
        If UseTcpTest = 1 Then
            Call NetworkTestTcp()
        Else
            Call NetworkTestPing()
        End If
    End Sub
End Class
