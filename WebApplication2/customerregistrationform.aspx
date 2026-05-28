<%@ Page Language="C#" AutoEventWireup="true" Async="true" CodeBehind="customerregistrationform.aspx.cs" Inherits="WebApplication2.customerregistrationform" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Sign Up - Housie</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    
    <style>
        /* 1. BACKGROUND SETUP */
        body {
            font-family: 'Inter', sans-serif;
            background-image: url('https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?q=80&w=1920&auto=format&fit=crop');
            background-size: cover; 
            background-position: center;
            background-attachment: fixed; 
            min-height: 100vh; 
            margin: 0;
            color: #222222;
        }

        /* 2. OVERLAY & CONTAINER */
        .glass-container {
            display: flex; justify-content: center; align-items: center; min-height: 100vh;
            background-color: rgba(0, 0, 0, 0.2); /* Soft darkening overlay */
            width: 100%;
            padding: 40px 20px;
        }

        /* 3. CLEAN GLASSMORPHISM CARD */
        .glass-card {
            width: 100%; 
            max-width: 500px; 
            border-radius: 20px;
            /* Frosted glass effect */
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            /* Thin, subtle border */
            border: 1px solid rgba(255, 255, 255, 0.4);
            /* Soft ambient shadow */
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .card-header h4 {
            font-family: 'Plus Jakarta Sans', sans-serif;
            letter-spacing: -0.02em;
            color: #222;
        }

        /* 4. CLEAN SEMI-TRANSPARENT INPUTS */
        .form-control { 
            background-color: rgba(255, 255, 255, 0.6) !important; 
            border: 1px solid rgba(255, 255, 255, 0.8) !important; 
            border-radius: 12px !important; 
            height: 3.8rem; 
            color: #222 !important;
            transition: all 0.2s ease;
            box-shadow: none !important; /* Overriding bootstrap default */
        }
        
        .form-control:focus {
            background-color: rgba(255, 255, 255, 0.9) !important;
            border-color: rgba(230, 30, 77, 0.5) !important;
            box-shadow: 0 0 0 3px rgba(230, 30, 77, 0.15) !important;
        }

        .form-floating > label {
            color: #5a5c5c;
            font-weight: 500;
        }

        /* 5. BUTTONS */
        .btn-brand {
            background: linear-gradient(to right, #E61E4D 0%, #D70466 100%);
            color: white; 
            font-weight: 600; 
            font-family: 'Plus Jakarta Sans', sans-serif;
            border: none; 
            border-radius: 12px; 
            padding: 14px; 
            width: 100%;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            box-shadow: 0 4px 10px rgba(230, 30, 77, 0.2);
        }
        
        .btn-brand:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(230, 30, 77, 0.3);
            color: white;
        }

        .btn-glass-outline {
            background: rgba(255, 255, 255, 0.4);
            border: 1px solid rgba(255, 255, 255, 0.8);
            color: #222222; 
            font-weight: 600; 
            border-radius: 12px; 
            padding: 12px; 
            width: 100%; 
            transition: all 0.2s ease;
        }
        
        .btn-glass-outline:hover { 
            background-color: rgba(255, 255, 255, 0.7); 
        }

        /* 6. EXTRAS */
        .divider { 
            display: flex; align-items: center; text-align: center; 
            color: #5a5c5c; margin: 24px 0; font-size: 14px; font-weight: 500;
        }
        .divider::before, .divider::after { 
            content: ''; flex: 1; border-bottom: 1px solid rgba(0,0,0,0.1); 
        }
        .divider:not(:empty)::before { margin-right: .8em; }
        .divider:not(:empty)::after { margin-left: .8em; }
        
        .glass-link {
            color: #222;
            font-weight: 700;
            text-decoration: underline;
            text-decoration-color: rgba(0,0,0,0.3);
            text-underline-offset: 2px;
            transition: 0.2s;
        }
        .glass-link:hover {
            text-decoration-color: #222;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="glass-container">
            <div class="card glass-card border-0">
                <asp:MultiView ID="mvRegister" runat="server" ActiveViewIndex="0">
                    
                    <asp:View ID="viewMain" runat="server">
                        <div class="card-header text-center border-bottom-0 pt-4 bg-transparent">
                            <h4 class="fw-bold">Create your profile</h4>
                            <p class="text-muted small">Join to start planning your trip</p>
                        </div>
                        <div class="card-body px-4 pb-4">
                            
                            <div style="display: flex; justify-content: center; margin-bottom: 16px;">
                                <div id="g_id_onload" 
                                     data-client_id="216506236992-kos43rmpf4np6k2ckifiq4rkderdrfin.apps.googleusercontent.com" 
                                     data-context="signup" data-ux_mode="popup" data-callback="handleGoogleSignup" data-auto_prompt="false">
                                </div>
                                <div class="g_id_signin" data-type="standard" data-shape="pill" data-theme="outline" data-text="signup_with" data-size="large" data-width="400"></div>
                            </div>

                            <div class="mb-2">
                                <asp:Button ID="btnGoToEmailLogin" runat="server" Text="Log in with email" CssClass="btn btn-glass-outline" OnClick="btnGoToEmailLogin_Click" CausesValidation="false" />
                            </div>

                            <div class="divider">or create account manually</div>

                            <div class="form-floating mb-3">
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="Fname"></asp:TextBox>
                                <label>First Name</label>
                            </div>
                            <div class="form-floating mb-3">
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Lname"></asp:TextBox>
                                <label>Last Name</label>
                            </div>
                            <div class="form-floating mb-3">
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Phone" MaxLength="10"></asp:TextBox>
                                <label>Phone Number</label>
                            </div>
                            <div class="form-floating mb-3">
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Email"></asp:TextBox>
                                <label>Email</label>
                            </div>
                            <div class="form-floating mb-4">
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Pass"></asp:TextBox>
                                <label>Password</label>
                            </div>
                            <asp:Button ID="btnRegister" runat="server" Text="Sign up" CssClass="btn-brand" OnClick="btnRegister_Click" />
                            
                            <div class="text-center mt-4 small">
                                Already have an account? <a href="customerloginform.aspx" class="glass-link">Log in</a>
                            </div>
                        </div>
                    </asp:View>

                    <asp:View ID="viewGoogleExtra" runat="server">
                        <div class="card-header text-center border-bottom-0 pt-4 bg-transparent">
                            <h4 class="fw-bold">Almost there!</h4>
                            <p class="text-muted">Welcome, <asp:Label ID="lblGoogleName" runat="server"></asp:Label>. Just two more details.</p>
                        </div>
                        <div class="card-body px-4 pb-4">
                            <div class="form-floating mb-3">
                                <asp:TextBox ID="txtGooglePhone" runat="server" CssClass="form-control" placeholder="Phone" MaxLength="10"></asp:TextBox>
                                <label>Mobile Number</label>
                            </div>
                            <div class="form-floating mb-4">
                                <asp:TextBox ID="txtGooglePass" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password"></asp:TextBox>
                                <label>Create a Login Password</label>
                            </div>
                            <asp:Button ID="btnFinishGoogle" runat="server" Text="Complete Registration" CssClass="btn-brand" OnClick="btnFinishGoogle_Click" />
                        </div>
                    </asp:View>

                </asp:MultiView>
            </div>
        </div>

        <asp:HiddenField ID="hfGoogleToken" runat="server" />
        <asp:Button ID="btnGoogleHidden" runat="server" OnClick="btnGoogleHidden_Click" style="display:none;" CausesValidation="false" />

        <script>
            function handleGoogleSignup(response) {
                document.getElementById('<%= hfGoogleToken.ClientID %>').value = response.credential;
                document.getElementById('<%= btnGoogleHidden.ClientID %>').click();
            }
        </script>
    </form>
</body>
</html>