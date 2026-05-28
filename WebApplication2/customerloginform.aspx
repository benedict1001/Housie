<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="customerloginform.aspx.cs" Inherits="WebApplication2.customerloginform" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Login - Housie</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    
    <style>
        /* 1. BACKGROUND SETUP */
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f7f7f7;
            background-image: url('https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?q=80&w=1920&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            height: 100vh;
            margin: 0;
            padding: 0;
        }

        /* 2. OVERLAY & CONTAINER */
        .glass-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: radial-gradient(circle at 50% 50%, rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.5));
            width: 100%;
            padding: 20px;
        }

        /* 3. LIQUID GLASS CARD */
        .glass-card {
            width: 100%;
            max-width: 480px;
            padding: 40px;
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.65) 0%, rgba(255, 255, 255, 0.25) 100%);
            backdrop-filter: blur(25px) saturate(120%);
            -webkit-backdrop-filter: blur(25px) saturate(120%);
            border-top: 1.5px solid rgba(255, 255, 255, 0.9);
            border-left: 1.5px solid rgba(255, 255, 255, 0.9);
            border-bottom: 1.5px solid rgba(255, 255, 255, 0.3);
            border-right: 1.5px solid rgba(255, 255, 255, 0.3);
            border-radius: 2.5rem;
            box-shadow: 0 25px 50px rgba(0,0,0,0.2), inset 2px 2px 10px rgba(255,255,255,0.5);
            color: #2d2f2f;
        }

        .glass-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .glass-header h4 {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-weight: 800;
            font-size: 32px;
            letter-spacing: -0.03em;
            text-shadow: 1px 1px 0px rgba(255,255,255,0.8);
            margin-bottom: 8px;
            color: #222;
        }

        .glass-header p {
            color: #5a5c5c;
            font-weight: 500;
            font-size: 15px;
        }

        /* 4. RECESSED INPUT FIELDS */
        .form-control {
            background: rgba(255, 255, 255, 0.4) !important;
            border: 1px solid rgba(255, 255, 255, 0.6) !important;
            border-radius: 1rem !important;
            box-shadow: inset 4px 4px 8px rgba(0,0,0,0.05), inset -4px -4px 8px rgba(255,255,255,0.7) !important;
            color: #222 !important;
            font-weight: 600;
            height: 3.8rem;
            transition: all 0.2s;
        }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.8) !important;
            box-shadow: inset 2px 2px 5px rgba(0,0,0,0.05), 0 0 0 3px rgba(230, 30, 77, 0.2) !important;
            border-color: transparent !important;
        }

        .form-floating > label {
            color: #5a5c5c;
            font-weight: 500;
            padding-left: 12px;
        }

        /* 5. 3D PHYSICAL BUTTON */
        .btn-glass {
            background: linear-gradient(180deg, #FA4871 0%, #D70466 100%);
            color: white;
            font-weight: 700;
            font-size: 16px;
            font-family: 'Plus Jakarta Sans', sans-serif;
            border: 1px solid #A8004E;
            border-top: 1px solid #FF8AA9;
            border-radius: 1rem;
            padding: 16px;
            width: 100%;
            box-shadow: 0 6px 0 #A8004E, 0 12px 20px rgba(230, 30, 77, 0.3);
            transition: all 0.1s ease;
            text-shadow: 0 -1px 0 rgba(0,0,0,0.2);
            margin-top: 15px;
        }

        .btn-glass:hover {
            color: white;
            filter: brightness(1.05);
        }

        .btn-glass:active {
            transform: translateY(6px);
            box-shadow: 0 0 0 #A8004E, inset 0 4px 8px rgba(0,0,0,0.4);
        }

        /* 6. LINKS & EXTRAS */
        .glass-link {
            color: #b90038;
            font-weight: 700;
            text-decoration: none;
            transition: 0.2s;
        }

        .glass-link:hover {
            color: #8a0029;
            text-decoration: underline;
        }

        .form-check-input {
            background-color: rgba(255,255,255,0.5);
            border-color: rgba(0,0,0,0.2);
        }
        .form-check-input:checked {
            background-color: #b90038;
            border-color: #b90038;
        }
        .form-check-label {
            font-weight: 500;
            color: #222;
        }
        
        .val-error {
            color: #b90038;
            font-size: 13px;
            font-weight: 700;
            display: block;
            margin-top: 6px;
            margin-left: 12px;
            text-shadow: 1px 1px 0px rgba(255,255,255,0.5);
        }

        .glass-divider {
            height: 1px;
            background: rgba(0,0,0,0.1);
            margin: 25px 0;
            box-shadow: 0 1px 0 rgba(255,255,255,0.5);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="glass-container">
            <div class="glass-card">
                
                <div class="glass-header">
                    <h4>Welcome back</h4>
                    <p>Login to your account</p>
                </div>

                <div class="card-body">
                    
                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtLoginEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="name@example.com"></asp:TextBox>
                        <label for="txtLoginEmail">Email</label>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtLoginEmail" 
                            ErrorMessage="Email is required" CssClass="val-error" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtLoginPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password"></asp:TextBox>
                        <label for="txtLoginPassword">Password</label>
                        <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtLoginPassword" 
                            ErrorMessage="Password is required" CssClass="val-error" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="form-check">
                            <asp:CheckBox ID="chkRemember" runat="server" CssClass="form-check-input" />
                            <label class="form-check-label small" for="chkRemember">Remember me</label>
                        </div>
                        <a href="customerforgotpassword.aspx" class="glass-link small">Forgot password?</a>
                    </div>

                    <div class="d-grid gap-2">
                        <asp:Button ID="btnLogin" runat="server" Text="Continue" CssClass="btn-glass" OnClick="btnLogin_Click" />
                    </div>

                    <div class="glass-divider"></div>

                    <div class="text-center">
                        <span class="small" style="color: #5a5c5c; font-weight: 500;">Don't have an account? </span>
                        <a href='<%= Request.QueryString.Count > 0 ? "customerregistrationform.aspx?" + Request.QueryString.ToString() : "customerregistrationform.aspx" %>' class="glass-link small" style="font-size: 15px;">Sign up</a>
                    </div>

                </div>
            </div>
        </div>
    </form>
</body>
</html>