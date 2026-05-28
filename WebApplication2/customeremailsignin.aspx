<%@ Page Title="Join Housie" Language="C#" MasterPageFile="~/customermaster.Master" AutoEventWireup="true" CodeBehind="customeremailsignin.aspx.cs" Inherits="WebApplication2.customeremailsignin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* --- BACKGROUND --- */
        body {
            font-family: 'Circular', -apple-system, BlinkMacSystemFont, Roboto, Helvetica Neue, sans-serif;
            margin: 0; 
            background-color: #fdfafb;
            background-image: url('https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?q=80&w=1920&auto=format&fit=crop');
            background-size: cover;
            background-attachment: fixed;
        }

        .page-wrapper {
            min-height: 90vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        /* --- CLEAN WHITE CARD --- */
        .housie-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 40px; 
            max-width: 450px; 
            width: 100%; 
        }

        .header-title {
            color: #222222; font-size: 26px; font-weight: 700; margin-bottom: 8px; text-align: center;
        }
        .header-subtitle {
            color: #717171; font-size: 15px; margin-bottom: 30px; text-align: center;
        }

        /* --- INPUT STYLING (Matches the uploaded image perfectly) --- */
        .custom-input {
            width: 100%;
            height: 52px;
            border: 1px solid #b0b0b0;
            border-radius: 8px;
            padding: 0 16px;
            font-size: 16px;
            color: #222222;
            margin-bottom: 16px;
            box-sizing: border-box;
            background: #ffffff;
            transition: border-color 0.2s ease;
        }
        
        .custom-input::placeholder {
            color: #717171;
        }
        
        .custom-input:focus {
            border: 2px solid #222222;
            outline: none;
            padding: 0 15px; /* Prevents text from jumping when border thickness changes */
        }

        /* --- SOLID BUTTON --- */
        .btn-solid-pink {
            background-color: #E61E4D;
            color: white; 
            font-weight: 600; 
            border: none; 
            border-radius: 8px; 
            padding: 14px; 
            width: 100%; 
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.2s ease;
            margin-top: 8px;
        }
        
        .btn-solid-pink:hover {
            background-color: #D70466;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-wrapper">
        <div class="housie-card">
            <asp:MultiView ID="mvSignup" runat="server" ActiveViewIndex="0">
                
                <%-- View 1: Personal Details --%>
                <asp:View ID="viewData" runat="server">
                    <h2 class="header-title">Create an account</h2>
                    <p class="header-subtitle">Join the Housie community today.</p>
                    
                    <%-- Clean Textboxes with Placeholders --%>
                    <asp:TextBox ID="txtFname" runat="server" CssClass="custom-input" placeholder="First Name"></asp:TextBox>
                    
                    <asp:TextBox ID="txtLname" runat="server" CssClass="custom-input" placeholder="Last Name"></asp:TextBox>
                    
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="custom-input" placeholder="Phone Number"></asp:TextBox>
                    
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="custom-input" TextMode="Email" placeholder="Email"></asp:TextBox>
                    
                    <asp:TextBox ID="txtPass" runat="server" CssClass="custom-input" TextMode="Password" placeholder="Password"></asp:TextBox>

                    <asp:Button ID="btnContinue" runat="server" Text="Continue" CssClass="btn-solid-pink" OnClick="btnContinue_Click" />
                    
                    <div class="text-center mt-4" style="font-size: 14px; color: #717171;">
                        Already have an account? <a href="login.aspx" style="color: #222222; font-weight: 600; text-decoration: underline;">Log in</a>
                    </div>
                </asp:View>

                <%-- View 2: OTP Verification --%>
                <asp:View ID="viewOTP" runat="server">
                    <div class="text-center mb-4">
                        <h2 class="header-title">Verify Email</h2>
                        <p class="header-subtitle">Enter the code sent to <br/> <asp:Label ID="lblTargetEmail" runat="server" Font-Bold="true" ForeColor="#222"></asp:Label></p>
                    </div>
                    
                    <asp:TextBox ID="txtOTP" runat="server" CssClass="custom-input text-center fw-bold" style="letter-spacing: 8px; font-size: 1.2rem;" placeholder="000000" MaxLength="6"></asp:TextBox>
                    
                    <asp:Button ID="btnVerify" runat="server" Text="Verify" CssClass="btn-solid-pink" OnClick="btnVerify_Click" />
                </asp:View>

            </asp:MultiView>
        </div>
    </div>
</asp:Content>