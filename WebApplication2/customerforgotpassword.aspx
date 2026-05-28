<%@ Page Title="Customer - Reset Password" Language="C#" MasterPageFile="~/customermaster.Master" AutoEventWireup="true" CodeBehind="customerforgotpassword.aspx.cs" Inherits="WebApplication2.customerforgotpassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .reset-box {
            max-width: 400px;
            margin: 60px auto;
            padding: 30px;
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            text-align: center;
            font-family: 'Poppins', sans-serif;
        }
        .reset-box h2 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 24px;
        }
        .reset-box p {
            color: #7f8c8d;
            font-size: 14px;
            margin-bottom: 25px;
        }
        .form-input {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #dcdde1;
            border-radius: 8px;
            outline: none;
            transition: 0.3s;
        }
        .form-input:focus { border-color: #3498db; }
        .btn-submit {
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn-email { background: #3498db; color: white; }
        .btn-verify { background: #2ecc71; color: white; }
        .btn-update { background: #f1c40f; color: #2c3e50; }
        .btn-submit:hover { opacity: 0.9; transform: translateY(-2px); }
        .msg-display {
            display: block;
            margin-bottom: 15px;
            font-size: 13px;
            font-weight: 500;
        }
        .otp-input {
            text-align: center;
            font-size: 22px;
            letter-spacing: 8px;
            font-weight: bold;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="reset-box">
        <h2>Forgot Password?</h2>
        
        <asp:Label ID="lblMsg" runat="server" CssClass="msg-display" ForeColor="Red"></asp:Label>

        <asp:Panel ID="pnlEmail" runat="server">
            <p>Enter your customer email address to receive a verification code.</p>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-input" placeholder="Enter your email"></asp:TextBox>
            <asp:Button ID="btnCheckEmail" runat="server" Text="Send Verification Code" OnClick="btnCheckEmail_Click" CssClass="btn-submit btn-email" />
        </asp:Panel>

        <asp:Panel ID="pnlOTP" runat="server" Visible="false">
            <p>We've sent a code to your email. Please enter it below.</p>
            <asp:TextBox ID="txtEnteredOTP" runat="server" CssClass="form-input otp-input" placeholder="000000" MaxLength="6"></asp:TextBox>
            <asp:Button ID="btnVerify" runat="server" Text="Verify Code" OnClick="btnVerify_Click" CssClass="btn-submit btn-verify" />
        </asp:Panel>

        <asp:Panel ID="pnlReset" runat="server" Visible="false">
            <p>Set a new secure password for your account.</p>
            <asp:TextBox ID="txtNewPass" runat="server" CssClass="form-input" TextMode="Password" placeholder="New Password"></asp:TextBox>
            <asp:TextBox ID="txtConfirmPass" runat="server" CssClass="form-input" TextMode="Password" placeholder="Confirm Password"></asp:TextBox>
            <asp:Button ID="btnUpdate" runat="server" Text="Reset Password" OnClick="btnUpdate_Click" CssClass="btn-submit btn-update" />
        </asp:Panel>

        <div style="margin-top: 20px;">
            <a href="customerloginform.aspx" style="text-decoration:none; color:#3498db; font-size: 13px;">Return to Login</a>
        </div>
    </div>
</asp:Content>